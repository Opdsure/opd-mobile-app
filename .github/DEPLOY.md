# OPDSure deploy pipeline

One workflow ships the app. Push to `master` → Google Play **production** and
App Store **review**.

| Stage | Runs on | What it does |
|---|---|---|
| `validate` | ubuntu | Fails fast if any secret/variable is missing or malformed; computes the version + build number |
| `android` | ubuntu | Builds a signed AAB, uploads to Google Play `production` track |
| `ios-build` | macos-15 | Builds a signed IPA with manual signing, uploads to TestFlight |
| `ios-submit` | macos-15 | Waits for processing, attaches the build to the version, submits for App Store review |

Workflow: [`deploy-prod.yml`](workflows/deploy-prod.yml).
`workflow_dispatch` exposes **Skip Android** / **Skip iOS** checkboxes for
re-running one half.

---

## Version numbers

`pubspec.yaml`'s `version:` supplies the **version name** (e.g. `1.0.2`).
The **build number** is `github.run_number + BUILD_NUMBER_OFFSET`.

Play rejects a `versionCode` that isn't strictly greater than the last upload,
and App Store Connect rejects a duplicate build number — so set
`BUILD_NUMBER_OFFSET` once, high enough that the first CI build clears both
stores. Check the current highest values in Play Console → Release → App
bundle explorer, and App Store Connect → TestFlight.

To ship a **new App Store version** (not just a new build), bump
`version:` in `pubspec.yaml`. Re-submitting a version that is already "Ready
for Sale" fails in `ios-submit`.

---

## GitHub configuration

Everything lives in a GitHub **environment named `Prod`**
(Settings → Environments → New environment → `Prod`). Add a required reviewer
there if you want a manual gate before anything reaches the stores.

### Secrets

| Secret | How to produce it |
|---|---|
| `RELEASE_KEYSTORE_BASE64` | `base64 -i android/opdsure.jks \| tr -d '\n'` |
| `KEYSTORE_PASSWORD` | keystore password |
| `KEY_ALIAS` | `opdsure` |
| `KEY_PASSWORD` | key password |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Play Console → Setup → API access → service account JSON. Paste **raw**, not base64. Needs the "Release manager" role, or at least Release apps to production. |
| `IOS_DISTRIBUTION_CERTIFICATE_BASE64` | Keychain Access → export the **Apple Distribution** identity as `.p12` → `base64 -i cert.p12 \| tr -d '\n'` |
| `IOS_DISTRIBUTION_CERTIFICATE_PASSWORD` | the password you set during that export |
| `IOS_PROVISIONING_PROFILE_BASE64` | developer.apple.com → Profiles → the **App Store** profile for `io.app.opdsure` → download → `base64 -i profile.mobileprovision \| tr -d '\n'` |
| `IOS_KEYCHAIN_PASSWORD` | any random string; only unlocks the throwaway CI keychain |
| `APPSTORE_API_PRIVATE_KEY` | contents of `AuthKey_XXXXXXXXXX.p8`, pasted with **real newlines**. Not base64, not a path. |

### Variables

| Variable | Value |
|---|---|
| `APPLE_TEAM_ID` | `X8JCSQZDGC` |
| `PROVISIONING_PROFILE_NAME` | exact `Name` of the App Store profile in the portal — must match character for character |
| `APPSTORE_ISSUER_ID` | App Store Connect → Users and Access → Integrations → Issuer ID |
| `APPSTORE_API_KEY_ID` | the Key ID next to that API key |
| `BUILD_NUMBER_OFFSET` | see [Version numbers](#version-numbers) |
| `PLAY_STORE_PACKAGE_NAME` | `io.app.opdsure` (default if unset) |
| `FLUTTER_VERSION` | `3.29.3` (default if unset). `intl: ^0.19.0` caps this at 3.29.x — Flutter 3.32+ pins intl 0.20.2 and `pub get` fails |
| `IOS_SUBMIT_FOR_REVIEW` | set to `false` to stop at TestFlight and submit manually |

---

## One-time store setup

- **Google Play:** the app must already exist in Play Console with at least one
  release on the production track. The API cannot create a listing from zero.
- **App Store Connect:** the app record must exist, and metadata
  (description, screenshots, privacy) must be complete for the version being
  submitted — CI runs with `skip_metadata`, so it submits whatever you have
  entered there.
- **Apple:** an **Apple Distribution** certificate and an **App Store**
  provisioning profile for `io.app.opdsure`. Xcode's "Automatic" signing does
  not work headless — the pipeline switches the `Release` config to Manual at
  build time and reverts nothing in git.

---

## Local signing

`android/key.properties` is gitignored. To build a signed release locally:

```properties
# android/key.properties
storePassword=…
keyPassword=…
keyAlias=opdsure
storeFile=opdsure.jks   # path relative to android/
```

Without that file, `flutter build apk --release` falls back to the debug key.

---

## Relationship to the old Jenkins pipeline

`Jenkinsfile` and the fastlane lanes under `ios/fastlane` + `android/fastlane`
were tied to one developer's Mac (absolute paths under
`/Users/intileotechnologies/…`) and pulled from Bitbucket. This workflow
replaces both. `.github/fastlane/Fastfile` is used only for the App Store
review submission; the app's own fastlane directories are untouched.
