# Walkthrough - Profile Setup Redesign & API Integration

I have implemented the role-based profile setup flow and integrated the `care-recipient` API for clients. The screens now match your provided designs exactly.

## Changes Made

### 1. Role-Based Navigation
- **BasicInfoController:** Updated to intelligently route users after a successful profile update.
    - **Clients** go to the "Who are you seeking care for?" screen (`NewRecipientProfileScreen`).
    - **Caregivers** go to the "Professional Details" screen (`ProfileSetupScreen`).

### 2. Caregiver Flow (Screenshot 1)
- **ProfileSetupScreen:** Updated the UI to include both "Back" and "Continue" buttons at the bottom, matching the professional details design.

### 3. Client Flow (Screenshot 2 & API)
- **NewRecipientProfileScreen:** Redesigned the entire screen:
    - **Header:** Centered "Who are you seeking care for?".
    - **Fields:** Added `Recipient Full Name`, `Your Relationship` dropdown, and a multiline `Health Considerations` field.
    - **Styling:** All fields now use the consistent lavender background (`textFiledBg`).
    - **Buttons:** Added side-by-side "Back" and "Continue" buttons.
- **API Integration:**
    - Added the `POST /care-recipient` endpoint.
    - Created `ClientRepository` to handle the data transmission.
    - Updated `HealthProfileController` to gather UI data and send it to the server via the repository.
    - **Success Handling:** Navigates to the home screen after successfully creating a care recipient.

## Verification

### UI Matches
- **Caregiver Screen:** Matches Screenshot 1 with the added Back button and centered header.
- **Client Screen:** Matches Screenshot 2 perfectly (minus the photo picker as requested earlier).

### API Data Flow
- The `saveRecipient` method correctly sends:
    - `fullName` -> From "Recipient Full Name" field.
    - `relationship` -> From "Your Relationship" selection.
    - `medicalConditions` -> From "Health Considerations" text.

This completes the multi-role onboarding experience with live API integration.
