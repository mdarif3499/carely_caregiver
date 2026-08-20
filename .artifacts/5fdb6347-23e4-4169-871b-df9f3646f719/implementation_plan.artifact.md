# Implementation Plan - Dynamic Specialties from API

This plan outlines the steps to fetch "Expertise & Specialties" categories from the backend and use them in the caregiver professional profile sections.

## Proposed Changes

### 1. API Configuration
#### [MODIFY] [app_api_end_point.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/constant/app_api_end_point.dart)
- Add `static const String categories = "/categories";` to the `AppApiEndPoint` class.

### 2. Data Model
#### [NEW] [category_model.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/models/category_model.dart)
- Create a `CategoryModel` class to parse the category response containing `_id` and `name`.

### 3. Repository Layer
#### [MODIFY] [caregiver_repository.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/repositories/caregiver_repository.dart)
- Add a `getCategories()` method to fetch the list of categories from the `/categories` endpoint.

### 4. Controller Layer
#### [MODIFY] [profle_setup_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart)
- Remove the hardcoded `allSpecialties` list.
- Add `RxList<CategoryModel> categories = <CategoryModel>[].obs`.
- Implement `fetchCategories()` to load data on `onInit`.
- Update `toggleSpecialty(String id)` and `selectedSpecialties` to work with category IDs.
- Ensure `updateProfile()` sends the selected IDs.

#### [MODIFY] [edit_professional_profile_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/edit_professional_profile_screen/controller/edit_professional_profile_controller.dart)
- Similar changes as above: fetch dynamic categories and handle selection by ID.
- Ensure `fetchProfileData()` correctly maps the saved specialties (IDs) from the user profile.

### 5. UI Layer
#### [MODIFY] [profile_setup_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_setup_screen/profile_setup_screen.dart)
- Update `_buildSpecialtiesGrid` to iterate over `controller.categories`.
- Pass `category.name` to `SkillChip`'s `label` and `category.id` to the toggle method.

#### [MODIFY] [edit_professional_profile_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/edit_professional_profile_screen/edit_professional_profile_screen.dart)
- Update `_buildSpecialtiesGrid` to use the dynamic categories from the controller.

## Verification Plan

### Automated Tests
- I will verify that the request body for `updateProfile` contains a list of IDs for the `specialties` field.

### Manual Verification
1.  **Onboarding**: Open the `ProfileSetupScreen`, verify that "Expertise & Specialties" are loaded from the API. Select some and proceed.
2.  **Profile Edit**: Open the `EditProfessionalProfileScreen`, verify that specialties are loaded and previously selected ones are highlighted.
3.  **Data Persistence**: Change specialties, save, and reopen the screen to verify they are persisted correctly (fetched as IDs from the backend).
