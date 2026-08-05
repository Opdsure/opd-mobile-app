#!/usr/bin/env bash
# Decide what this run is able to do, and fail only on real misconfiguration.
#
# A credential group that is entirely absent is not an error — it just means
# that capability is not wired up yet, and the matching job is skipped. A group
# that is *partly* filled in IS an error, because that is almost always a typo
# or a half-finished setup that would fail 40 minutes into a build.
#
# Emits to $GITHUB_OUTPUT:
#   android-build / android-upload / ios-build / ios-upload  (true|false)
set -uo pipefail

ERRORS=0
declare -a SUMMARY

fail() { echo "::error::$1"; ERRORS=$((ERRORS + 1)); }
ok()   { echo "  ✓ $1"; }
skip() { echo "::notice::$1"; }

# present <NAME>… → echoes "<present count> <total count>"
count_present() {
  local present=0 total=0 name
  for name in "$@"; do
    total=$((total + 1))
    [ -n "${!name:-}" ] && present=$((present + 1))
  done
  echo "$present $total"
}

# Reports which members of a group are missing (used when partially filled).
report_missing() {
  local name
  for name in "$@"; do
    [ -n "${!name:-}" ] || fail "$name is not set (the rest of its group is)."
  done
}

validate_base64() {
  local name="$1" value="${2:-}"
  if ! printf '%s' "$value" | base64 -d >/dev/null 2>&1; then
    fail "$name is not valid base64. Encode with: base64 -i <file> | tr -d '\\n'"
    return 1
  fi
}

decode_base64_to() { printf '%s' "$1" | base64 -d > "$2"; }

emit() {
  [ -n "${GITHUB_OUTPUT:-}" ] && echo "$1=$2" >> "$GITHUB_OUTPUT"
  echo "  → $1=$2"
}

BUNDLE_ID="${BUNDLE_ID:-io.app.opdsure}"
ANDROID_BUILD=false; ANDROID_UPLOAD=false
IOS_BUILD=false;     IOS_UPLOAD=false

# ------------------------------------------------- Android: signing --------
echo "::group::Android signing"
read -r P T <<<"$(count_present RELEASE_KEYSTORE_BASE64 KEY_ALIAS KEYSTORE_PASSWORD KEY_PASSWORD)"
if [ "$P" -eq 0 ]; then
  skip "Android signing is not configured — the Android job will be skipped."
  SUMMARY+=("⏭️ **Android build** — skipped, no keystore configured")
elif [ "$P" -lt "$T" ]; then
  report_missing RELEASE_KEYSTORE_BASE64 KEY_ALIAS KEYSTORE_PASSWORD KEY_PASSWORD
  SUMMARY+=("❌ **Android build** — keystore secrets are incomplete")
else
  if validate_base64 "RELEASE_KEYSTORE_BASE64" "${RELEASE_KEYSTORE_BASE64:-}"; then
    KS="$(mktemp)"
    decode_base64_to "$RELEASE_KEYSTORE_BASE64" "$KS"
    KS_OK=1
    # -storetype is deliberately omitted: opdsure.jks is actually PKCS12
    # despite the extension, and keytool auto-detects either format.
    KT_OUT="$(keytool -list -keystore "$KS" -alias "$KEY_ALIAS" \
      -storepass "$KEYSTORE_PASSWORD" -keypass "$KEY_PASSWORD" 2>&1)"
    KT_RC=$?
    if [ "$KT_RC" -eq 0 ]; then
      KS_OK=0
    elif grep -qiE "unable to locate a java runtime|command not found|no such file" <<<"$KT_OUT"; then
      # macOS ships a keytool shim that exists but fails without a JDK, so
      # probing `command -v` is not enough. openssl can still confirm the store
      # password for a PKCS12 keystore; it cannot check the alias.
      echo "::warning::No working keytool (no JDK) — falling back to openssl, which cannot verify KEY_ALIAS."
      openssl pkcs12 -in "$KS" -nokeys -passin pass:"$KEYSTORE_PASSWORD" >/dev/null 2>&1 && KS_OK=0
    fi

    if [ "$KS_OK" -eq 0 ]; then
      ok "keystore opens with the supplied alias and passwords"
      ANDROID_BUILD=true
      SUMMARY+=("✅ **Android build** — will build a signed AAB")
    else
      fail "Keystore, alias or passwords do not match. Check KEY_ALIAS and both passwords."
      SUMMARY+=("❌ **Android build** — keystore did not open")
    fi
    rm -f "$KS"
  fi
fi
echo "::endgroup::"

# ------------------------------------------------- Android: Play upload ----
echo "::group::Google Play upload"
if [ -z "${PLAY_STORE_SERVICE_ACCOUNT_JSON:-}" ]; then
  skip "PLAY_STORE_SERVICE_ACCOUNT_JSON is not set — the AAB will be built and kept as a workflow artifact, but not uploaded to Play."
  SUMMARY+=("⏭️ **Play upload** — skipped, no service account")
elif printf '%s' "$PLAY_STORE_SERVICE_ACCOUNT_JSON" | python3 -c \
  "import json,sys; d=json.load(sys.stdin); sys.exit(0 if d.get('type')=='service_account' and d.get('private_key') and d.get('client_email') else 1)" 2>/dev/null; then
  ok "Play service-account JSON is well formed"
  ANDROID_UPLOAD=true
  SUMMARY+=("✅ **Play upload** — production track")
else
  fail "PLAY_STORE_SERVICE_ACCOUNT_JSON is not service-account JSON (needs type=service_account, private_key, client_email). Paste the file contents raw — do not base64-encode it."
  SUMMARY+=("❌ **Play upload** — service-account JSON is malformed")
fi

PKG="${PLAY_STORE_PACKAGE_NAME:-io.app.opdsure}"
[ "$PKG" = "$BUNDLE_ID" ] || echo "::warning::PLAY_STORE_PACKAGE_NAME ($PKG) differs from the app id ($BUNDLE_ID)."
echo "::endgroup::"

# ------------------------------------------------- iOS: signing ------------
echo "::group::iOS signing"
IOS_GROUP=(APPLE_TEAM_ID PROVISIONING_PROFILE_NAME IOS_DISTRIBUTION_CERTIFICATE_BASE64
           IOS_DISTRIBUTION_CERTIFICATE_PASSWORD IOS_PROVISIONING_PROFILE_BASE64 IOS_KEYCHAIN_PASSWORD)
read -r P T <<<"$(count_present "${IOS_GROUP[@]}")"
if [ "$P" -eq 0 ]; then
  skip "iOS signing is not configured — the iOS jobs will be skipped."
  SUMMARY+=("⏭️ **iOS build** — skipped, no signing assets configured")
elif [ "$P" -lt "$T" ]; then
  report_missing "${IOS_GROUP[@]}"
  SUMMARY+=("❌ **iOS build** — signing secrets are incomplete")
else
  IOS_OK=0
  validate_base64 "IOS_DISTRIBUTION_CERTIFICATE_BASE64" "$IOS_DISTRIBUTION_CERTIFICATE_BASE64" || IOS_OK=1
  if validate_base64 "IOS_PROVISIONING_PROFILE_BASE64" "$IOS_PROVISIONING_PROFILE_BASE64"; then
    PP="$(mktemp)"; PP_PLIST="$(mktemp)"
    decode_base64_to "$IOS_PROVISIONING_PROFILE_BASE64" "$PP"
    # No `security` on Linux — openssl reads the CMS wrapper fine.
    if openssl smime -inform der -verify -noverify -in "$PP" -out "$PP_PLIST" 2>/dev/null; then
      if ! python3 - "$PP_PLIST" "$BUNDLE_ID" "$APPLE_TEAM_ID" "$PROVISIONING_PROFILE_NAME" <<'PY'
import datetime, plistlib, sys

path, bundle_id, team_id, profile_name = sys.argv[1:5]
with open(path, "rb") as f:
    p = plistlib.load(f)

errors = []
app_id = p.get("Entitlements", {}).get("application-identifier", "")
want = f"{team_id}.{bundle_id}"
if app_id != want:
    errors.append(f"profile is for {app_id!r} but this app ships {want!r} (wrong bundle id or wrong team)")

# An App Store profile provisions no specific devices and disables debugging.
if p.get("ProvisionedDevices"):
    errors.append("profile is Development/Ad Hoc (it lists ProvisionedDevices); an App Store distribution profile is required")
if p.get("Entitlements", {}).get("get-task-allow"):
    errors.append("profile has get-task-allow=true — that is a Development profile")
if p.get("Name") != profile_name:
    errors.append(f"PROVISIONING_PROFILE_NAME is {profile_name!r} but the profile is named {p.get('Name')!r} — they must match exactly")
if not p.get("DeveloperCertificates"):
    errors.append("profile contains no DeveloperCertificates")

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
        IOS_OK=1
      else
        ok "provisioning profile matches $BUNDLE_ID and is an App Store profile"
      fi
    else
      fail "IOS_PROVISIONING_PROFILE_BASE64 does not decode to a .mobileprovision."
      IOS_OK=1
    fi
    rm -f "$PP" "$PP_PLIST"
  else
    IOS_OK=1
  fi
  if [ "$IOS_OK" -eq 0 ]; then
    IOS_BUILD=true
    SUMMARY+=("✅ **iOS build** — will archive a signed IPA")
  else
    SUMMARY+=("❌ **iOS build** — signing assets are unusable")
  fi
fi
echo "::endgroup::"

# ------------------------------------------------- iOS: App Store Connect --
echo "::group::App Store Connect"
read -r P T <<<"$(count_present APPSTORE_ISSUER_ID APPSTORE_API_KEY_ID APPSTORE_API_PRIVATE_KEY)"
if [ "$P" -eq 0 ]; then
  skip "App Store Connect API key is not set — TestFlight upload and review submission will be skipped."
  SUMMARY+=("⏭️ **TestFlight / review** — skipped, no App Store Connect key")
elif [ "$P" -lt "$T" ]; then
  report_missing APPSTORE_ISSUER_ID APPSTORE_API_KEY_ID APPSTORE_API_PRIVATE_KEY
  SUMMARY+=("❌ **TestFlight / review** — App Store Connect config is incomplete")
else
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
      IOS_UPLOAD=true
      SUMMARY+=("✅ **TestFlight / review** — will upload and submit")
    else
      fail "APPSTORE_API_PRIVATE_KEY is not a valid .p8 key (OpenSSL could not decode it). Re-paste it with real newlines."
      SUMMARY+=("❌ **TestFlight / review** — .p8 key is unreadable")
    fi
  else
    fail "APPSTORE_API_PRIVATE_KEY is malformed."
    SUMMARY+=("❌ **TestFlight / review** — .p8 key is malformed")
  fi
  rm -f "$KEYF"
fi
echo "::endgroup::"

# ------------------------------------------------------------- outputs ----
echo "::group::Resolved capabilities"
emit android-build  "$ANDROID_BUILD"
emit android-upload "$ANDROID_UPLOAD"
emit ios-build      "$IOS_BUILD"
emit ios-upload     "$IOS_UPLOAD"
echo "::endgroup::"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "## What this run will do"
    echo
    for line in "${SUMMARY[@]}"; do echo "- $line"; done
    echo
    echo "_Configure missing values in the \`Prod\` environment — see \`.github/DEPLOY.md\`._"
  } >> "$GITHUB_STEP_SUMMARY"
fi

if [ "$ERRORS" -gt 0 ]; then
  echo "::error::$ERRORS configuration problem(s) found. See .github/DEPLOY.md for how to produce each value."
  exit 1
fi

echo "✅ Configuration is consistent. Anything not configured will be skipped, not failed."
