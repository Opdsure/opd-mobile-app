# opdsure

OPDSure

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

- [App-Specific Password]
## dfiy-trth-euqp-cwde

---

## Android Release & CI/CD (Google Play Internal Testing)

Automated release pipeline: **GitHub Actions → Fastlane → Google Play (internal testing track)**.
Workflow file: [`.github/workflows/android-release.yml`](.github/workflows/android-release.yml).

### Release flow

```
Push / Manual dispatch
  → Validate (dart format = report-only; flutter analyze = errors are fatal)
  → Test (flutter test, if tests exist)
  → Configure signing (decode keystore + generate key.properties from secrets)
  → Resolve versionCode (manual input, else Play max + 1)
  → Build signed AAB (flutter build appbundle --release)
  → Verify AAB exists & non-empty
  → Upload AAB as workflow artifact
  → Publish to Google Play INTERNAL testing track (Fastlane)
  → Clean up signing material (always)
```

Production publishing is **intentionally disabled**. The pipeline only targets the
internal testing track until a separate, explicitly approved production config is added.

**Validation strictness (current):** the codebase has pre-existing formatting diffs and
analyzer warnings (0 errors). To avoid blocking every release on unrelated debt, the
workflow treats `dart format` as report-only and `flutter analyze` as fatal on **errors**
only (`--no-fatal-warnings --no-fatal-infos`). After a one-time cleanup
(`dart format .` + resolving warnings), tighten the workflow: set `continue-on-error: false`
on the format step and drop the `--no-fatal-*` flags from analyze.

### How to run

- **Automatically:** push to the configured release branch (`master`; also `Aman--Dev`
  during active development — adjust the `push.branches` list in the workflow to your
  real default branch).
- **Manually:** GitHub → Actions → *Android Release (Internal Testing)* → **Run workflow**.
  Optionally supply an explicit `version_code`; leave blank to auto-derive from Play.

### Required GitHub repository secrets

| Secret | Description |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | Base64 of the **upload** keystore (`android/upload-keystore.jks`). Create with `base64 -w0 android/upload-keystore.jks` (Linux) or `[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/upload-keystore.jks"))` (PowerShell). |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore (store) password. |
| `ANDROID_KEY_ALIAS` | Key alias (e.g. `upload`). |
| `ANDROID_KEY_PASSWORD` | Key password. |
| `PLAY_STORE_JSON` | **Full raw JSON** of the Google Play service-account key (not a path). Passed to Fastlane as `json_key_data`; never written to disk. |

Signing uses the existing release config in `android/app/build.gradle`, which reads
`android/key.properties`. The workflow generates `key.properties` at runtime from the
secrets and deletes it (and the decoded keystore) after the run, including on failure.

### Version code strategy

- The versionCode is **not** committed to the repo. It is passed to Flutter at build time
  via `--build-number`.
- Default: Fastlane queries Google Play (`google_play_track_version_codes` across
  internal/alpha/beta/production) and uses **max existing + 1**, so it never collides with
  an existing release.
- Override: provide a `version_code` input when running the workflow manually.
- If the Play query fails **and** no manual value is given, the workflow **fails with a clear
  error** rather than guessing an offset.
- The versionName comes from `pubspec.yaml` (`version:` before the `+`).

### Google Play API prerequisites (manual, one-time)

These cannot be verified by the pipeline and must be set up in the Google Cloud / Play Console:

1. **Enable** the *Google Play Android Developer API* in the Google Cloud project.
2. Create a **service account** and grant it access in **Play Console → Users & permissions**
   with at least *Release to testing tracks* permission for this app.
3. Put the service-account JSON content into the `PLAY_STORE_JSON` secret.
4. The app `io.app.opdsure` must already exist in Play Console with at least one prior
   manual upload on the internal track (Play requires the first bundle to be uploaded via the
   console before API uploads to that track work).

### ⚠️ Rotate the exposed service-account key (do this before the first run)

A Google Play service-account key was exposed in a screenshot and must be treated as
**compromised**. Rotate it manually:

1. Google Cloud Console → **IAM & Admin → Service Accounts** → open the account used for Play.
2. **Keys** tab → **delete** the exposed key → **Add key → Create new key → JSON**.
3. Update the `PLAY_STORE_JSON` GitHub secret with the **new** JSON.
4. Confirm the service account still has the Play Console permission above.
5. Treat the old `android/playstore-credentials.json` as burned (see cleanup below).

### Secret files already committed to git (clean up)

The following secret files are currently tracked and should be removed from tracking
(and ideally purged from history). This repository update adds them to `.gitignore` but
that does **not** untrack already-committed files:

```bash
git rm --cached android/opdsure.jks android/playstore-credentials.json
git commit -m "chore: stop tracking signing keystore and Play credentials"
```

Because both are secret/compromised, also purge them from history (e.g. with
`git filter-repo` or BFG) and rotate the Play key as above. The `android/upload-keystore.jks`
and `android/key.properties` files are already untracked.
