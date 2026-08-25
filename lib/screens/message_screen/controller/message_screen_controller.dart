import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/socket/socket_service.dart';
import '../model/chat_model.dart';

class MessageScreenController extends GetxController{
  final RxList<ChatMessage> chats = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMetadataLoading = false.obs;
  final RxList<String> filePaths = <String>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final Rxn<ChatConversation> selectedConversation = Rxn<ChatConversation>();
  String chatId ='';
  String userId='';
  final RxString message = ''.obs;
  TextEditingController? messageTextController;
  
  final Rxn<XFile> selectedImage = Rxn<XFile>();

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
      _initUserIdAndData();
    }
  }

  Future<void> _initUserIdAndData() async {
    userId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    await fetchConversationDetails();
    await fetchMessages();
    _setupSocketListener();
  }

  void _setupSocketListener() {
    SocketService.on('message', (data) {
      if (data != null && data['conversation'] == chatId) {
        final incomingMsg = ChatMessage.fromJson(data);
        if (incomingMsg.userId != userId) {
          chats.insert(0, incomingMsg);
        }
      }
    });
  }

  @override
  void onClose() {
    SocketService.off('message', (data) {});
    messageTextController = null;
    super.onClose();
  }

  Future<void> fetchConversationDetails() async {
    if (chatId.isEmpty) return;
    try {
      isMetadataLoading.value = true;
      update();

      final response = await ChatRepository.instance.getConversationDetails(chatId);

      if (response.isSuccess) {
        final data = response.data['data'] ?? {};
        final List participants = data['participants'] ?? [];
        
        // Find the other participant
        final partner = participants.firstWhere(
          (p) => p['_id'] != userId, 
          orElse: () => participants.isNotEmpty ? participants.first : {}
        );

        selectedConversation.value = ChatConversation(
          id: data['_id'] ?? chatId,
          name: partner['name'] ?? 'Chat',
          role: partner['role'] ?? '',
          avatarUrl: AppApiEndPoint.imageUrl(partner['profileImage']),
          lastMessage: data['lastMessage'] ?? '',
          time: '',
        );
      }
    } catch (e) {
      debugPrint("Error fetching conversation details: $e");
    } finally {
      isMetadataLoading.value = false;
      update();
    }
  }

  Future<void> fetchMessages({bool isLoadMore = false}) async {
    if (chatId.isEmpty || isLoading.value) return;

    try {
      isLoading.value = true;
      update();

      final response = await ChatRepository.instance.getMessages(chatId, currentPage.value);

      if (response.isSuccess) {
        final List dataList = response.data['data']?['messages'] ?? [];
        final List<ChatMessage> newMessages = dataList.map((e) => ChatMessage.fromJson(e)).toList();

        if (isLoadMore) {
          chats.addAll(newMessages);
        } else {
          chats.assignAll(newMessages);
        }

        hasMore.value = dataList.length >= 20;
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    currentPage.value++;
    await fetchMessages(isLoadMore: true);
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  Future<void> send() async {
    if (message.value.trim().isEmpty && selectedImage.value == null) return;

    final content = message.value.trim();
    final pickedFile = selectedImage.value;

    final newMessage = ChatMessage(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      userId: userId,
      userName: 'Me',
      userImage: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSending: true,
      isSendingFailed: false,
      files: pickedFile != null ? [pickedFile.path] : [],
    );

    chats.insert(0, newMessage);
    message.value = '';
    messageTextController?.clear();
    selectedImage.value = null;

    try {
      dynamic attachment;
      if (pickedFile != null) {
        attachment = await dio.MultipartFile.fromFile(
          pickedFile.path,
          filename: pickedFile.name,
        );
      }

      final response = await ChatRepository.instance.sendMessage(
        conversationId: chatId,
        content: content,
        contentType: pickedFile != null ? "IMAGE" : "TEXT",
        attachment: attachment,
      );

      if (response.isSuccess) {
        final index = chats.indexWhere((m) => m.messageId == newMessage.messageId);
        if (index != -1) {
          final serverMsg = ChatMessage.fromJson(response.data['data']);
          chats[index] = serverMsg;
          chats.refresh();
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      final index = chats.indexWhere((m) => m.messageId == newMessage.messageId);
      if (index != -1) {
        chats[index] = newMessage.copyWith(isSending: false, isSendingFailed: true);
        chats.refresh();
      }
      showCustomSnackbar(message: "Failed to send message", isError: true);
    }
  }
}
