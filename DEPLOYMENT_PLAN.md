# Nutrinfo Production Deployment Plan

This plan details the process to move the Nutrinfo app from a local development environment to production. We will deploy the FastAPI backend to the cloud for free (via Render) and prepare a signed Android APK for free distribution (via GitHub Releases or direct sharing), completely bypassing the paid Google Play Store.

## User Review Required

> [!WARNING]
> **Database Size limitation on GitHub:** Your SQLite database is ~266MB, which exceeds GitHub's 100MB limit for a single file. We MUST use **Git LFS (Large File Storage)** to push it to your repository. This process can be slow on slower networks. 

> [!CAUTION]
> **App Signing:** We will generate a cryptographic keystore. **You must back up this file securely.** If you lose it, you will never be able to push updates to your app again.

> [!NOTE]
> **Wait For Approval:** This document is strictly an advisory plan. I will not run any of the commands listed below without your explicit instruction to "Proceed with Phase 1" or "Proceed with Phase 2".

## Proposed Changes

---

### Phase 1: Backend Deployment Readiness (FastAPI)

To deploy the backend to a cloud service like Render or Google Cloud Run, it needs to be containerized and tracked properly.

#### [NEW] `nutrinfo_api/Dockerfile`
Create a standard Python 3.11 Dockerfile that:
1. Installs requirements.
2. Copies the application and database.
3. Exposes the correct port (Render dynamically assigns $PORT).
4. Runs `uvicorn` bounded to `0.0.0.0:$PORT`.

#### [NEW] `nutrinfo_api/.gitattributes`
Track the large ML model and database.
- Register `*.db` and `*.pkl` using `git lfs`.
- This ensures successful commits without GitHub rejecting the push.

#### [MODIFY] Git Tracking (Commands)
We will execute the following local commands:
```bash
git lfs install
git lfs track "*.db"
git lfs track "*.pkl"
git add .gitattributes nutrinfo.db
git commit -m "chore: enable Git LFS for database tracking"
git push
```

#### [Manual Action] Cloud Deployment (Render Dashboard)
Once pushed to GitHub, you will manually:
1. Go to [Render.com](https://render.com/) and create a "Web Service".
2. Connect your GitHub repository.
3. Select "Docker" as the Runtime.
4. Select the Free tier.
5. Deploy.

---

### Phase 2: Frontend Production Configuration (Free APK Distribution)

Since the Google Play Store requires a $25 developer fee, we will build a universal **APK** file instead of an AAB. An APK can be shared directly (via WhatsApp, Google Drive, or email) or uploaded to free platforms like **GitHub Releases** or the **Amazon Appstore** for anyone to download and install.

#### [MODIFY] `lib/services/api_client.dart`
- Replace `http://10.254.246.227:8000` with the actual production URL of the backend.

#### [MODIFY] `pubspec.yaml`
- Add `flutter_launcher_icons` and `flutter_native_splash` under `dev_dependencies` to generate proper Google Play Store app icons and Android 12+ splash screens.

#### [NEW] Android Keystore Generation (Command)
We will execute a `keytool` command to generate your cryptographic key:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```
*Note: I will use a standard password like `nutrinfo` which you can change later or keep for simplicity.*

#### [NEW] `android/key.properties`
Create a reference file for Flutter's build system pointing to the new `.jks` file.

#### [MODIFY] `android/app/build.gradle`
Update the `signingConfigs` and `buildTypes` to use the `key.properties` variables for generating a signed production build. Fix any `namespace` warnings.

#### [NEW] Generate Assets (Commands)
We will use your Generate Image tool (if necessary) to create a clean `logo.png`, place it in `assets/images/`, and run:
- `flutter pub run flutter_launcher_icons`

## Open Questions

> [!IMPORTANT]
> 1. **Render Free Tier:** Are you okay using Render's Free Tier? It spins down after 15 minutes of inactivity, meaning the first user of the day will experience a ~30-second delay while the server boots up.
> 2. **GitHub Releases:** Are you okay with people downloading the `.apk` directly from your GitHub repository (or sharing the file directly) since we are skipping the Play Store?

## Verification Plan

### Automated Tests
- Build the final universal APK using `flutter build apk --release`.
- Verify the APK size.
- Test the Production API endpoint locally before triggering the backend deployment.

### Manual Verification
1. I will walk you through deploying via the Render Web UI.
2. We will generate the APK and I will show you how to create a free GitHub Release to share the download link with anyone.
