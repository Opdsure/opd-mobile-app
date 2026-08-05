#!/usr/bin/env bash
# Fail the deploy early, with an actionable message, when a secret or variable
# is missing or malformed — rather than 40 minutes later inside xcodebuild.
set -uo pipefail

ERRORS=0

fail() {
  echo "::error::$1"
  ERRORS=$((ERRORS + 1))
}

ok() { echo "  ✓ $1"; }

require_nonempty() {
  local name="$1" value="${2:-}"
  if [ -z "$value" ]; then
    fail "$name is not set."
    return 1
  fi
  ok "$name"
}

validate_base64() {
  local name="$1" value="${2:-}"
  require_nonempty "$name" "$value" || return 1
  if ! printf '%s' "$value" | base64 -d >/dev/null 2>&1; then
    fail "$name is not valid base64. Encode with: base64 -i <file> | tr -d '\\n'"
    return 1
  fi
}

decode_base64_to() { printf '%s' "$1" | base64 -d > "$2"; }

SKIP_ANDROID="${SKIP_ANDROID:-false}"
SKIP_IOS="${SKIP_IOS:-false}"
BUNDLE_ID="${BUNDLE_ID:-io.app.opdsure}"

# ---------------------------------------------------------------- Android ----
if [ "$SKIP_ANDROID" != "true" ]; then
  echo "::group::Android configuration"

  # Check each independently so one missing secret doesn't hide the rest.
  KEYSTORE_OK=0
  validate_base64 "RELEASE_KEYSTORE_BASE64" "${RELEASE_KEYSTORE_BASE64:-}" || KEYSTORE_OK=1
  require_nonempty "KEY_ALIAS" "${KEY_ALIAS:-}" || KEYSTORE_OK=1
  require_nonempty "KEYSTORE_PASSWORD" "${KEYSTORE_PASSWORD:-}" || KEYSTORE_OK=1
  require_nonempty "KEY_PASSWORD" "${KEY_PASSWORD:-}" || KEYSTORE_OK=1

  if [ "$KEYSTORE_OK" -eq 0 ]; then
    KS="$(mktemp)"
    decode_base64_to "$RELEASE_KEYSTORE_BASE64" "$KS"
    if keytool -list -keystore "$KS" -alias "$KEY_ALIAS" \
        -storepass "$KEYSTORE_PASSWORD" -keypass "$KEY_PASSWORD" >/dev/null 2>&1; then
      ok "keystore opens with the supplied alias and passwords"
    else
      fail "RELEASE_KEYSTORE_BASE64 / KEY_ALIAS / KEYSTORE_PASSWORD / KEY_PASSWORD do not match a valid keystore entry."
    fi
    rm -f "$KS"
  fi

  if require_nonempty "PLAY_STORE_SERVICE_ACCOUNT_JSON" "${PLAY_STORE_SERVICE_ACCOUNT_JSON:-}"; then
    if printf '%s' "$PLAY_STORE_SERVICE_ACCOUNT_JSON" | python3 -c \
      "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('type')=='service_account' and d.get('private_key') and d.get('client_email') else 1)" 2>/dev/null; then
      ok "Play service-account JSON is well formed"
    else
      fail "PLAY_STORE_SERVICE_ACCOUNT_JSON is not service-account JSON (needs type=service_account, private_key, client_email). Paste the file contents raw — do not base64-encode it."
    fi
  fi

  PKG="${PLAY_STORE_PACKAGE_NAME:-io.app.opdsure}"
  if [ "$PKG" != "$BUNDLE_ID" ]; then
    echo "::warning::PLAY_STORE_PACKAGE_NAME ($PKG) differs from the app id ($BUNDLE_ID)."
  else
    ok "PLAY_STORE_PACKAGE_NAME = $PKG"
  fi
  echo "::endgroup::"
fi

# -------------------------------------------------------------------- iOS ----
if [ "$SKIP_IOS" != "true" ]; then
  echo "::group::iOS configuration"

  require_nonempty "APPLE_TEAM_ID" "${APPLE_TEAM_ID:-}"
  require_nonempty "PROVISIONING_PROFILE_NAME" "${PROVISIONING_PROFILE_NAME:-}"
  require_nonempty "IOS_DISTRIBUTION_CERTIFICATE_PASSWORD" "${IOS_DISTRIBUTION_CERTIFICATE_PASSWORD:-}"
  require_nonempty "IOS_KEYCHAIN_PASSWORD" "${IOS_KEYCHAIN_PASSWORD:-}"
  validate_base64 "IOS_DISTRIBUTION_CERTIFICATE_BASE64" "${IOS_DISTRIBUTION_CERTIFICATE_BASE64:-}"

  if validate_base64 "IOS_PROVISIONING_PROFILE_BASE64" "${IOS_PROVISIONING_PROFILE_BASE64:-}"; then
    PP="$(mktemp)"
    PP_PLIST="$(mktemp)"
    decode_base64_to "$IOS_PROVISIONING_PROFILE_BASE64" "$PP"
    # No `security` on Linux — openssl reads the CMS wrapper fine.
    if openssl smime -inform der -verify -noverify -in "$PP" -out "$PP_PLIST" 2>/dev/null; then
      if ! python3 - "$PP_PLIST" "$BUNDLE_ID" "${APPLE_TEAM_ID:-}" "${PROVISIONING_PROFILE_NAME:-}" <<'PY'
import plistlib, sys

path, bundle_id, team_id, profile_name = sys.argv[1:5]
with open(path, "rb") as f:
    p = plistlib.load(f)

errors = []
app_id = p.get("Entitlements", {}).get("application-identifier", "")
want = f"{team_id}.{bundle_id}"
if app_id != want:
    errors.append(
        f"profile is for {app_id!r} but this app ships {want!r} "
        "(wrong bundle id or wrong team)"
    )

# An App Store profile provisions no specific devices and disables debugging.
if p.get("ProvisionedDevices"):
    errors.append(
        "profile is Development/Ad Hoc (it lists ProvisionedDevices); "
        "an App Store distribution profile is required"
    )
if p.get("Entitlements", {}).get("get-task-allow"):
    errors.append("profile has get-task-allow=true — that is a Development profile")

if p.get("Name") != profile_name:
    errors.append(
        f"PROVISIONING_PROFILE_NAME is {profile_name!r} but the profile is "
        f"named {p.get('Name')!r} — they must match exactly"
    )

if not p.get("DeveloperCertificates"):
    errors.append("profile contains no DeveloperCertificates")

import datetime
exp = p.get("ExpirationDate")
if isinstance(exp, datetime.datetime):
    now = datetime.datetime.now(tz=exp.tzinfo)
    if exp < now:
        errors.append(f"profile expired on {exp:%Y-%m-%d}")
    elif (exp - now).days < 14:
        print(f"::warning::Provisioning profile expires in {(exp - now).days} days ({exp:%Y-%m-%d}).")

for e in errors:
    print(f"::error::{e}")
sys.exit(1 if errors else 0)
PY
      then
        fail "IOS_PROVISIONING_PROFILE_BASE64 cannot produce a signed App Store build (see above)."
      else
        ok "provisioning profile matches $BUNDLE_ID and is an App Store profile"
      fi
    else
      fail "IOS_PROVISIONING_PROFILE_BASE64 does not decode to a .mobileprovision."
    fi
    rm -f "$PP" "$PP_PLIST"
  fi

  require_nonempty "APPSTORE_ISSUER_ID" "${APPSTORE_ISSUER_ID:-}"
  require_nonempty "APPSTORE_API_KEY_ID" "${APPSTORE_API_KEY_ID:-}"
  if require_nonempty "APPSTORE_API_PRIVATE_KEY" "${APPSTORE_API_PRIVATE_KEY:-}"; then
    # GitHub secrets are often pasted as one line with literal "\n", which
    # OpenSSL rejects with "DECODER routines::unsupported". Normalize, then check.
    KEYF="$(mktemp)"
    if python3 - "$KEYF" <<'PY'
import os, sys
key = os.environ["APPSTORE_API_PRIVATE_KEY"].strip().strip('"').strip("'")
key = key.replace("\\r\\n", "\n").replace("\\n", "\n").replace("\r\n", "\n")
if "BEGIN PRIVATE KEY" not in key:
    print("::error::APPSTORE_API_PRIVATE_KEY has no 'BEGIN PRIVATE KEY' header — paste the AuthKey_*.p8 contents, not a path or base64.")
    sys.exit(1)
with open(sys.argv[1], "w", encoding="utf-8") as f:
    f.write(key if key.endswith("\n") else key + "\n")
PY
    then
      if openssl pkey -in "$KEYF" -noout 2>/dev/null; then
        ok "App Store Connect API key is a valid PKCS#8 .p8"
      else
        fail "APPSTORE_API_PRIVATE_KEY is not a valid .p8 key (OpenSSL could not decode it). Re-paste it with real newlines."
      fi
    else
      fail "APPSTORE_API_PRIVATE_KEY is malformed."
    fi
    rm -f "$KEYF"
  fi
  echo "::endgroup::"
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "::error::$ERRORS configuration problem(s) found. See .github/DEPLOY.md for how to produce each value."
  exit 1
fi

echo "✅ Deploy configuration looks good."
