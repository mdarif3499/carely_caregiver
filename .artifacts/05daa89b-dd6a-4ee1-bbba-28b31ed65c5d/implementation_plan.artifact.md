# Handling Checkout URL on Document Upload

The goal is to automatically dismiss the upload popup and navigate the user to a WebView if the document upload response contains a `checkoutUrl`.

## Proposed Changes

### [Caregiver Documents]

#### [MODIFY] [caregiver_documents_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/caregiver_documents_screen/controller/caregiver_documents_controller.dart)
- Update `uploadDocument()` to:
    - Extract `checkoutUrl` from `response.data['data']`.
    - If `checkoutUrl` is present:
        - Call `Get.back()` to dismiss the bottom sheet.
        - Use `Get.toNamed(AppRoutes.instance.stripePaymentWebView, arguments: checkoutUrl)` to open the WebView.
    - If `checkoutUrl` is NOT present, proceed with the existing logic (dismiss and refresh).

### [Profile Setup]

#### [MODIFY] [profle_setup_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/profile_screens/profile_setup_screen/controller/profle_setup_screen_controller.dart)
- Update `uploadFile()` to handle the `checkoutUrl` in the same way, ensuring consistency across all document upload points.

## Verification Plan

### Manual Verification
1.  Upload a document from the "Documents & Verification" screen.
2.  If the backend returns a `checkoutUrl`, verify that the upload popup closes and the Stripe WebView opens automatically.
3.  Upload a document during the "Profile Setup" flow.
4.  Verify the same behavior.
