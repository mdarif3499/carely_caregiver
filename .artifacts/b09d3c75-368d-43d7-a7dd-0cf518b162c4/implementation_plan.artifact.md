# Implementation Plan - Logical Chat Navigation

Implement the logic to navigate from the message list (`ChatListScreen`) to the chat details (`MessageScreen`) while passing and displaying the correct conversation data.

## Proposed Changes

### [Component] Chat List
Handle the navigation and argument passing from the list to the details.

#### [MODIFY] [chat_list_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/chat_list_screen/controller/chat_list_controller.dart)
- Update `onConversationTap` to pass the `ChatConversation` object as an argument using `Get.toNamed`.

### [Component] Message Screen (Chat Details)
Retrieve and display the passed conversation data.

#### [MODIFY] [message_screen_controller.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/message_screen/controller/message_screen_controller.dart)
- Add a reactive property to store the selected conversation.
- In `onInit`, retrieve the conversation from `Get.arguments`.
- Update `userId` and `chatId` based on the passed data.

#### [MODIFY] [message_screen.dart](file:///C:/Users/mdyou/StudioProjects/carely_caregiver/lib/screens/message_screen/message_screen.dart)
- Wrap the `titleWidget` content with `Obx` to reactively display the conversation's name, role, and avatar.
- Replace hardcoded "Sarah Jenkins, RN" with data from the controller.

## Verification Plan

### Manual Verification
- Run the app and navigate to the "Message" tab.
- Click on different conversations in the list.
- Verify that the `MessageScreen` opens with the correct name, role, and avatar of the clicked person.
