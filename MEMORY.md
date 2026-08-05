# OPDSure — release engineering context

Working notes for whoever picks this up next. Setup instructions live in
[`.github/DEPLOY.md`](.github/DEPLOY.md); this file is the *why* and the
current state.

Last updated: 2026-08-06.

---

## What changed and why

The app used to ship from a Jenkins pipeline (`Jenkinsfile`) pinned to one
developer's Mac — absolute paths under `/Users/intileotechnologies/…`, checking
out from Bitbucket (`sahil1321/opd_sure_app`) rather than this repo. Only the
iOS stages were active; every Android stage was commented out.

That is replaced by GitHub Actions: **push to `master` → Google Play production
track + TestFlight + App Store review submission**. Modelled on an existing
Flutter pipeline, minus flavors and Firebase App Distribution, which this app
does not use.

`Jenkinsfile` and `ios/fastlane` / `android/fastlane` are left in place but are
no longer the deployment path. `.github/fastlane/Fastfile` is used only for the
App Store review submission.

---

## Facts that are easy to get wrong

**Flutter is capped at 3.29.x.** `pubspec.yaml` has `intl: ^0.19.0`.
`flutter_localizations` pins `intl 0.19.0` through Flutter 3.29.x and `0.20.2`
from 3.32.0 onward, so anything newer fails `pub get` with a version-solving
error. CI pins 3.29.3 via the `FLUTTER_VERSION` repo variable. Confirmed working
in CI on 2026-08-06.

**`pubspec.lock` is gitignored, and it has already bitten us.** `permission_handler`
was declared as `any`, so CI resolved `permission_handler 13.0.0` →
`permission_handler_android 14.0.0`, published 2026-07-31. That version's
`android/build.gradle.kts` declares `classpath("com.android.tools.build:gradle:9.0.1")`
and calls `kotlin { compilerOptions { jvmTarget } }` *without applying the Kotlin
plugin* — it assumes AGP 9. The build failed with `Unresolved reference:
compilerOptions` even though nothing in the app had changed.

Bumping the Kotlin Gradle plugin does **not** fix this, and it is a trap worth
knowing about: the `buildscript { classpath ... }` block in `android/build.gradle`
is dead config. `android/settings.gradle`'s `plugins { }` block is what actually
resolves plugin versions (AGP 8.8.1, Kotlin 1.9.23), and the two disagree.

The fix was pinning `permission_handler: ^12.0.1`, which resolves
`permission_handler_android` to 13.0.1 (Mar 2025, pre-AGP-9). **Commit
`pubspec.lock`.** Until then, every production build re-resolves every
dependency and can break with no code change.

**Two toolchains cannot move independently.** `intl: ^0.19.0` caps Flutter at
3.29.x, which caps AGP at 8.x, which caps how new any plugin's Android module can
be. Unblocking newer plugins means dropping the `intl` constraint first.

**Build numbers come from CI, not `pubspec.yaml`.** The version *name* is read
from `pubspec.yaml`; the build number is `github.run_number +
BUILD_NUMBER_OFFSET`. The offset is 50 because Play production was on
versionCode 42. Play rejects a versionCode that is not strictly greater than the
last upload; App Store Connect rejects duplicate build numbers.

**`master` was not the release branch.** Until 2026-08-06 it held the Nov 2024
open-testing build (1.0.2+8) while production ran 1.21.0+42 from `Aman--Dev`.
Deploying it would have shipped a year-old app to production users and moved the
version name *backwards* — Play only enforces versionCode, not version name, so
it would have been accepted silently. `Aman--Dev` is now merged in.

**Two fixes get reverted every time `Aman--Dev` is merged.** Watch for these:
- `android/app/build.gradle` — release signing must read `android/key.properties`,
  not a hardcoded absolute path with plaintext passwords
- `ios/Runner/Info.plist` — `CFBundleVersion` must stay `$(FLUTTER_BUILD_NUMBER)`.
  `Aman--Dev` pins it to a literal `30`, which silently overrides `--build-number`
  and makes every TestFlight upload collide. Git does *not* flag this as a
  conflict, because only one side touches it.

---

## Credentials — all of these were committed to a public repo

Verified 2026-08-06 by testing each against the live APIs:

| Credential | State |
|---|---|
| `android/opdsure.jks` | **Works.** PKCS12 despite the `.jks` name; password opens it, alias `opdsure` |
| Play service account | **Revoked.** `invalid_grant: Invalid JWT Signature` — key is dead, needs reissuing |
| App Store Connect `.p8` | **Key valid, account blocked.** Returns `FORBIDDEN.REQUIRED_AGREEMENTS_MISSING_OR_EXPIRED` |
| iOS distribution `.p12` | Never in the repo |
| iOS provisioning profile | Never in the repo |

These files are now gitignored and untracked, **but they remain in git history**
and the repo is public. They must still be revoked and rotated; the keystore
additionally needs a Play Console upload-key reset, which is the only way to
rotate a leaked upload key.

The expired Apple agreement blocks **all** iOS releases — CI and manual alike —
until an Account Holder signs it in App Store Connect → Business. It is
independent of certificates.

---

## How the pipeline degrades

`validate` distinguishes "not configured yet" from "configured wrongly":

- A credential group that is entirely empty → notice, and its job is skipped
- A group that is *partly* filled → hard error, because that is almost always a
  typo that would otherwise fail deep inside a 40-minute build

It emits `android-build`, `android-upload`, `ios-build`, `ios-upload`, and each
job and upload step is gated on the matching flag. The AAB is always kept as a
workflow artifact, so builds stay verifiable before store credentials exist.
The run summary lists exactly what will and will not happen.

---

## Current state

- ✅ Pipeline live on `master`; `validate` green
- ✅ **Android build verified end to end** — CI produced a signed
  `opdsure-1.21.0-55-aab` artifact (49 MB), and the same build reproduces
  locally on Flutter 3.29.3 with Android Studio's bundled JDK 21
- ⛔ Play upload — blocked on a new service-account JSON; everything up to the
  upload step already works
- ⛔ iOS entirely — blocked on the Apple agreement, then `.p12` + profile

## Local development

Flutter **3.29.3** is required (see the version cap above); the build will not
resolve on 3.32+. `android/key.properties` is gitignored — create it to build a
signed release locally:

```properties
storePassword=…
keyPassword=…
keyAlias=opdsure
storeFile=opdsure.jks   # relative to android/
```

Without it, release builds fall back to the debug key. The keystore is no longer
in the repo, so you need your own copy.
