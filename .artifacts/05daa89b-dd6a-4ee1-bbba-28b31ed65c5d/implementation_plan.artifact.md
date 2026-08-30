# Professional Registration UI & API Alignment

Refactor the registration screen to align with the backend API requirements (Role: CLIENT/CAREGIVER) and remove unnecessary fields like Location.

## User Review Required

> [!IMPORTANT]
> - Role selection will now be **Client** or **Caregiver** (instead of User/Agency).
> - The **Location** field will be removed from the registration screen as it is not required for account creation.

## Proposed Changes

### [Auth]

#### [MODIFY] [sign_up_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/sign_up_screen/controller/sign_up_controller.dart)
- Remove `locationTextEditingController`.
- Update `signUpUser()` logic:
    - Map `role` to `CLIENT` or `CAREGIVER`.
    - Ensure the request body strictly contains: `name`, `email`, `password`, `role`, `phone`.

#### [MODIFY] [sign_up_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/auth_all_screens/sign_up_screen/sign_up_screen.dart)
- Update radio button labels to **Client** and **Caregiver**.
- Remove the **Location** `CommonTextField`.
- Refine layout spacing for a more modern, professional look.

## Verification Plan

### Manual Verification
1.  Navigate to the Sign Up screen.
2.  Verify the role options are now "Client" and "Caregiver".
3.  Verify the "Location" field is gone.
4.  Fill in all fields and register.
5.  Check the console log (`SIGN_UP_API`) to verify the request body matches:
    ```json
    {
      "name": "...",
      "email": "...",
      "password": "...",
      "role": "CLIENT",
      "phone": "..."
    }
    ```
