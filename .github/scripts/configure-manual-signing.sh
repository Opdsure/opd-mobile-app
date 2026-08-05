#!/usr/bin/env bash
# Configure the Xcode project for manual App Store signing in CI.
# Rewrites the checked-out worktree only — the Development configs your team
# uses locally stay on Automatic signing in git.
set -euo pipefail

XCODE_PROJECT="${XCODE_PROJECT:-ios/Runner.xcodeproj/project.pbxproj}"
TEAM_ID="${APPLE_TEAM_ID:-}"
PROFILE_NAME="${PROVISIONING_PROFILE_NAME:-}"
RELEASE_CONFIG="${RELEASE_CONFIG:-Release}"
# App target only — never rewrite RunnerTests with the app's distribution profile.
BUNDLE_ID="${BUNDLE_ID:-io.app.opdsure}"

if [ -z "$TEAM_ID" ]; then
  echo "Error: APPLE_TEAM_ID is required"
  exit 1
fi
if [ -z "$PROFILE_NAME" ]; then
  echo "Error: PROVISIONING_PROFILE_NAME is required"
  exit 1
fi
if [ ! -f "$XCODE_PROJECT" ]; then
  echo "Error: Xcode project not found at $XCODE_PROJECT"
  exit 1
fi

echo "Configuring manual signing for $RELEASE_CONFIG"
echo "  Team ID:  $TEAM_ID"
echo "  Profile:  $PROFILE_NAME"
echo "  Bundle:   $BUNDLE_ID"
# Must match the certificate CN prefix from the .p12 (portal type):
#   Apple Distribution | iOS Distribution | iPhone Distribution
CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY:-Apple Distribution}"
echo "  Identity: $CODE_SIGN_IDENTITY"

python3 - "$XCODE_PROJECT" "$RELEASE_CONFIG" "$TEAM_ID" "$PROFILE_NAME" "$BUNDLE_ID" "$CODE_SIGN_IDENTITY" <<'PY'
import re
import sys

path, release_config, team_id, profile_name, bundle_id, code_sign_identity = sys.argv[1:7]
text = open(path, encoding="utf-8").read()

# Xcode quotes the name only when it needs to ("Release-prod"), so accept both
# `name = Release;` and `name = "Release-prod";`.
config_re = re.compile(
    r"(/\* "
    + re.escape(release_config)
    + r" \*/ = \{)"
    r"(.*?)"
    r"(\n\t\t\tname = \"?"
    + re.escape(release_config)
    + r"\"?;)",
    re.S,
)


def upsert(settings: str, key: str, value: str) -> str:
    needs_quotes = any(c in key for c in "[]*")
    lhs = f'"{key}"' if needs_quotes else key
    pattern = re.compile(
        r'^(\t+)' + re.escape(lhs) + r'\s*=\s*[^;]*;',
        re.M,
    )
    line = f"\t\t\t\t{lhs} = {value};"
    if pattern.search(settings):
        return pattern.sub(lambda m: f"{m.group(1)}{lhs} = {value};", settings, count=1)
    if "buildSettings = {" in settings:
        return settings.replace(
            "buildSettings = {",
            "buildSettings = {\n" + line,
            1,
        )
    return line + "\n" + settings


def patch_block(block: str) -> str:
    # CODE_SIGN_IDENTITY must match the certificate CN prefix. Setting
    # "Apple Distribution" when the .p12 is an older "iOS Distribution" /
    # "iPhone Distribution" cert produces the familiar
    # "No signing certificate … found" error even though the key is present.
    block = upsert(block, "CODE_SIGN_STYLE", "Manual")
    block = upsert(block, "DEVELOPMENT_TEAM", f'"{team_id}"')
    block = upsert(block, "CODE_SIGN_IDENTITY", f'"{code_sign_identity}"')
    block = upsert(
        block,
        "CODE_SIGN_IDENTITY[sdk=iphoneos*]",
        f'"{code_sign_identity}"',
    )
    block = upsert(block, "PROVISIONING_PROFILE_SPECIFIER", f'"{profile_name}"')
    return block


matches = list(config_re.finditer(text))
if not matches:
    raise SystemExit(
        f"No build configuration named {release_config!r} found in {path}"
    )

patched_count = 0
out = text
for m in reversed(matches):
    body = m.group(2)
    # Project-level configs (compiler flags only) have no bundle id — skip.
    # RunnerTests has io.app.opdsure.RunnerTests — skip (wrong profile).
    if f'PRODUCT_BUNDLE_IDENTIFIER = {bundle_id};' not in body and \
       f'PRODUCT_BUNDLE_IDENTIFIER = "{bundle_id}";' not in body:
        continue
    patched = patch_block(body)
    out = out[: m.start(2)] + patched + out[m.end(2) :]
    patched_count += 1

if patched_count == 0:
    raise SystemExit(
        f"Found {release_config!r} configs but none for bundle {bundle_id!r}"
    )

open(path, "w", encoding="utf-8", newline="\n").write(out)
print(f"  Patched {patched_count} app-target {release_config!r} configuration(s)")
PY

echo "Manual signing configuration complete"
