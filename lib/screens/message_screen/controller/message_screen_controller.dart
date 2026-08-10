import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/chat_model.dart';

class MessageScreenController extends GetxController{
  final RxList<ChatMessage> chats = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<String> filePaths = <String>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rxn<ChatConversation> selectedConversation = Rxn<ChatConversation>();
  String chatId ='';
  String userId='';
  final RxString message = ''.obs;
  TextEditingController? messageTextController;

  @override
  void onInit() {
    super.onInit();
    messageTextController = TextEditingController()
      ..addListener(() {
        message.value = messageTextController?.text ?? '';
      });
    
    if (Get.arguments is ChatConversation) {
      selectedConversation.value = Get.arguments as ChatConversation;
      chatId = selectedConversation.value?.id ?? '';
      // For now, let's keep userId as empty or set a dummy one if needed
      // but ideally it should come from an auth service.
      // In the mock, it was commented out: userId = Get.arguments['userId'] ?? '';
    }
    
    init();
  }

  @override
  void onClose() {
    messageTextController = null;
    super.onClose();
  }



  Future<void> init() async {
    await fetchMessages();
  }
  List<ChatMessage> _generateMockMessages(int page) {
    return List.generate(20, (index) {
      final id = (page - 1) * 20 + index;
      final isMe = id % 2 == 0;
      return ChatMessage(
        messageId: 'msg_$id',
        content: 'This is message number $id',
        userId: isMe ? userId : 'other_user',
        userName: isMe ? 'Me' : 'Other User',
        userImage: '',
        createdAt: DateTime.now().subtract(Duration(minutes: id)),
        updatedAt: DateTime.now().subtract(Duration(minutes: id)),
        isSending: false,
        isSendingFailed: false,
        files: [],
      );
    });
  }

  Future<void> fetchMessages({bool isLoadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      // TODO: Replace with actual API call
      // Example: final response = await chatRepository.getMessages(chatId, currentPage.value);

      await Future.delayed(const Duration(seconds: 1)); // Simulating API call

      if (isClosed) return;

      // Mock data - replace with actual API response
      final newMessages = _generateMockMessages(currentPage.value);

      if (isLoadMore) {
        chats.addAll(newMessages);
      } else {
        chats.value = newMessages;
      }

      hasMore.value = newMessages.length >= 20;

    } catch (e) {
      // AppSnackBar.error('Failed to load messages: $e');
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    currentPage.value++;
    await fetchMessages(isLoadMore: true);
  }




  Future<void> send() async {
    if (message.value.trim().isEmpty && filePaths.isEmpty) return;

    final newMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message.value,
      userId: userId,
      userName: 'Me',
      userImage: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSending: true,
      isSendingFailed: false,
      files: filePaths.toList(),
      // chatType: ChatType.text,
    );

    chats.insert(0, newMessage);
    filePaths.clear();
    message.value = '';
    messageTextController?.clear();

    try {
      // TODO: Replace with actual API call
      // await chatRepository.sendMessage(chatId, newMessage);

      await Future.delayed(const Duration(seconds: 1)); // Simulating API call

      if (isClosed) return;

      // Update message status
      final index = chats.indexWhere((m) => m.messageId == newMessage.messageId);
      if (index != -1) {
        chats[index] = newMessage.copyWith(isSending: false);
        chats.refresh();
      }
    } catch (e) {
      if (isClosed) return;
      final index = chats.indexWhere((m) => m.messageId == newMessage.messageId);
      if (index != -1) {
        chats[index] = newMessage.copyWith(isSending: false, isSendingFailed: true);
        chats.refresh();
      }
      // AppSnackBar.error('Failed to send message: $e');
    }
  }
}