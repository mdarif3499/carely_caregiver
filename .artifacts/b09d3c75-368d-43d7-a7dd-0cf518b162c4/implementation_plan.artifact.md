# Implementation Plan - Beautiful API & App Logging

Improve the logging system to match the "umodzi" project style, making API requests and responses more readable and professional.

## Proposed Changes

### [Component] Dependencies
Add the logger package.

#### [MODIFY] [pubspec.yaml](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/pubspec.yaml)
- Add `pretty_dio_logger: ^1.3.1` to `dependencies`.

### [Component] Utilities - Logging
Create and refine loggers.

#### [NEW] [app_log.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/utils/log/app_log.dart)
- Implement `appLog` with decorative borders and source tags, similar to `umodzi`.

#### [MODIFY] [error_log.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/utils/error_log.dart)
- Update or wrap with the new logging style.

### [Component] API Service Integration
Inject the pretty logger into the network layer.

#### [MODIFY] [api_service.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/services/api/api_service.dart)
- Import `pretty_dio_logger`.
- Add `PrettyDioLogger` to the `Dio` instance interceptors.

## Verification Plan

### Manual Verification
- Run the app and trigger an API call (e.g., Registration).
- Check the debug console.
- **Expected:** API requests (URL, Headers, Body) and responses (Status, Data) should be formatted nicely with box borders.
- Check general app logs.
- **Expected:** Non-API logs should appear with the decorative "umodzi" style borders.
