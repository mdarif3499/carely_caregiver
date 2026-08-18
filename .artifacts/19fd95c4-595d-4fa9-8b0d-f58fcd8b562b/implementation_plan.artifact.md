# Implementation Plan - Bump Android SDK to 36

The goal is to resolve dependency conflicts where libraries (activity-ktx, core-ktx, etc.) require Android SDK 36, but the project is currently set to SDK 34.

## Proposed Changes

### [Component] Android Build Configuration

#### [MODIFY] [build.gradle.kts (App)](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/android/app/build.gradle.kts)
- Set `compileSdk = 36` in the `android` block.
- Set `targetSdk = 36` in the `defaultConfig` block.

#### [MODIFY] [build.gradle.kts (Root)](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/android/build.gradle.kts)
- (Optional but recommended) Add a `subprojects` block to force all subprojects to use `compileSdk = 36` and `targetSdk = 36`. This ensures that all plugins are compiled against the same version and resolves potential conflicts where a plugin might still be pointing to an older (or newer) version.

## Verification Plan

### Manual Verification
1.  Run `fvm flutter clean`.
2.  Run `fvm flutter pub get`.
3.  Run `fvm flutter build apk --debug`.
4.  Verify that the build completes successfully and the SDK 36 requirement errors are gone.
