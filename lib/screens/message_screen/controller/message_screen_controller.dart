import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/screens/chat_list_screen/controller/chat_list_controller.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:carely_caregiver/utils/log/app_log.dart';
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
    _setPlaceholders();
    messageTextController = TextEditingController()
      ..addListener(() {
        onTextChanged(messageTextController?.text ?? '');
      });
    
    if (Get.arguments is ChatConversation) {
      selectedConversation.value = Get.arguments as ChatConversation;
      chatId = selectedConversation.value?.id ?? '';
      _initUserIdAndData();
    }
  }

  void _setPlaceholders() {
    chats.value = List.generate(10, (index) => ChatMessage(
      messageId: 'placeholder_$index',
      content: index % 2 == 0 
          ? '                   '
          : '                                            ',


      userId: index % 2 == 0 ? userId : 'other',
      userName: index % 2 == 0 ? 'Me' : 'Partner',
      userImage: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSending: false,
      isSendingFailed: false,
      files: [],
      status: 'SENT',
    ));
  }

  Future<void> _initUserIdAndData() async {
    userId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    _setPlaceholders();

    _setupSocketListeners();
    _joinConversation();

    await fetchConversationDetails();
    await fetchMessages();
    emitSeenStatus();
  }

  void _joinConversation() {
    if (chatId.isNotEmpty) {
      appLog("JOINING CONVERSATION ROOM: $chatId", source: "CHAT");
      SocketService.emit('conversation:join', chatId);
    }
  }

  void _leaveConversation() {
    if (chatId.isNotEmpty) {
      appLog("LEAVING CONVERSATION ROOM: $chatId", source: "CHAT");
      // Emitting as a direct string, matching Postman
      SocketService.emit('conversation:leave', chatId);
    }
  }

  final RxBool isPartnerTyping = false.obs;
  DateTime? _lastTypingTime;

  void _setupSocketListeners() {
    appLog("SETTING UP CHAT LISTENERS...", source: "CHAT");
    SocketService.on('message:new', _onNewMessage);
    SocketService.on('typing:start', _onPartnerTypingStart);
    SocketService.on('typing:stop', _onPartnerTypingStop);
    SocketService.on('message:delivered', _onMessageDelivered);
    SocketService.on('message:seen', _onMessageSeen);
  }

  void _onNewMessage(data) {
    appLog("SOCKET MESSAGE RECEIVED: $data", source: "CHAT");
    if (data != null) {
      final String incomingChatId = (data['conversationId'] ?? data['conversation'] ?? '').toString();
      if (incomingChatId == chatId) {
        final incomingMsg = ChatMessage.fromJson(data);
        
        if (incomingMsg.userId != userId) {
          if (!chats.any((m) => m.messageId == incomingMsg.messageId)) {
            chats.insert(0, incomingMsg);
            
            emitDeliveredStatus(incomingMsg.messageId, incomingMsg.userId);
            
            Future.delayed(const Duration(milliseconds: 300), () {
              emitSeenStatus();
            });
          }
        } else {
          final index = chats.indexWhere((m) => m.userId == userId && (m.isSending || m.messageId.contains('local') || m.messageId.length >= 13));
          if (index != -1) {
            appLog("SYNCING SENT MESSAGE DATA: $data", source: "CHAT");
            chats[index] = incomingMsg;
            chats.refresh();
            update();
          }
        }
      }
    }
  }

  void _onMessageDelivered(data) {
    appLog("📩 MESSAGE SCREEN: DELIVERY STATUS RECEIVED: $data", source: "SOCKET");
    if (data != null) {
      final String incomingChatId = (data['conversationId'] ?? data['conversation'] ?? '').toString();
      if (incomingChatId == chatId) {
        final String? msgId = data['messageId']?.toString();
        final bool isDelivered = data['deliveredAt'] != null;

        if (msgId != null && msgId.isNotEmpty && isDelivered) {
          final index = chats.indexWhere((m) => m.messageId == msgId);
          if (index != -1 && chats[index].status == 'SENT') {
            appLog("✅ TICK UPDATE: Message $msgId is now DELIVERED (Double Grey) via deliveredAt", source: "CHAT");
            chats[index] = chats[index].copyWith(status: 'DELIVERED');
            chats.refresh();
            update();
          }
        }
      }
    }
  }

  void _onMessageSeen(data) {
    appLog("📩 MESSAGE SCREEN: SEEN STATUS RECEIVED: $data", source: "SOCKET");
    if (data != null) {
      final String incomingChatId = (data['conversationId'] ?? data['conversation'] ?? '').toString();
      if (incomingChatId == chatId) {
        final String seenBy = (data['seenBy'] ?? data['senderId'] ?? '').toString();
        
        if (seenBy.isNotEmpty && seenBy != userId) {
          bool changed = false;
          final String? msgId = data['messageId']?.toString();
          
          if (msgId != null && msgId.isNotEmpty) {
            final index = chats.indexWhere((m) => m.messageId == msgId);
            if (index != -1 && chats[index].status != 'SEEN') {
              appLog("✅ TICK UPDATE: Message $msgId is now SEEN (Double Blue)", source: "CHAT");
              chats[index] = chats[index].copyWith(status: 'SEEN');
              changed = true;
            }
          } else {
            appLog("✅ TICK UPDATE: All my messages in room are now SEEN (Double Blue)", source: "CHAT");
            for (int i = 0; i < chats.length; i++) {
              if (chats[i].userId == userId && chats[i].status != 'SEEN') {
                chats[i] = chats[i].copyWith(status: 'SEEN');
                changed = true;
              }
            }
          }

          if (changed) {
            chats.refresh();
            update();
          }
        }
      }
    }
  }

  void _onPartnerTypingStart(data) {
    if (data != null && data['conversationId'] == chatId && data['senderId'] != userId) {
      isPartnerTyping.value = true;
    }
  }

  void _onPartnerTypingStop(data) {
    if (data != null && data['conversationId'] == chatId && data['senderId'] != userId) {
      isPartnerTyping.value = false;
    }
  }

  void emitTypingStatus(bool isTyping) {
    if (chatId.isEmpty) return;
    final event = isTyping ? 'typing:start' : 'typing:stop';
    SocketService.emit(event, {
      "conversationId": chatId,
      "senderId": userId,
    });
  }

  void emitSeenStatus() {
    if (chatId.isEmpty) return;
    final partnerId = selectedConversation.value?.partnerId ?? '';
    if (partnerId.isEmpty) return;

    SocketService.emit('message:seen', {
      "senderId": partnerId,
      "conversationId": chatId,
    });
  }

  void emitDeliveredStatus(String messageId, String messageSenderId) {
    if (chatId.isEmpty || messageId.isEmpty || messageSenderId.isEmpty) return;
    // Matching 1st screenshot: messageId, senderId, conversationId
    SocketService.emit('message:delivered', {
      "messageId": messageId,
      "senderId": messageSenderId,
      "conversationId": chatId,
    });
  }

  void onTextChanged(String val) {
    message.value = val;
    if (val.isNotEmpty) {
      if (_lastTypingTime == null || 
          DateTime.now().difference(_lastTypingTime!) > const Duration(seconds: 2)) {
        emitTypingStatus(true);
      }
      _lastTypingTime = DateTime.now();
      
      // Stop typing indicator after 3 seconds of inactivity
      Future.delayed(const Duration(seconds: 3), () {
        if (_lastTypingTime != null && 
            DateTime.now().difference(_lastTypingTime!) >= const Duration(seconds: 3)) {
          emitTypingStatus(false);
          _lastTypingTime = null;
        }
      });
    }
  }

  @override
  void onClose() {
    _leaveConversation();
    SocketService.off('message:new', _onNewMessage);
    SocketService.off('typing:start', _onPartnerTypingStart);
    SocketService.off('typing:stop', _onPartnerTypingStop);
    SocketService.off('message:delivered', _onMessageDelivered);
    SocketService.off('message:seen', _onMessageSeen);
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

        final pId = (partner['_id'] ?? partner['id'] ?? '').toString();

        selectedConversation.value = ChatConversation(
          id: data['_id'] ?? chatId,
          name: partner['name'] ?? 'Chat',
          role: partner['role'] ?? '',
          avatarUrl: AppApiEndPoint.imageUrl(partner['profileImage']),
          lastMessage: data['lastMessage'] ?? '',
          time: '',
          partnerId: pId,
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

          // Professional Upgrade: Confirm delivery for any offline messages received
          for (var m in newMessages) {
            if (m.userId != userId && m.status == 'SENT') {
              emitDeliveredStatus(m.messageId, m.userId);
            }
          }
        }

        hasMore.value = dataList.length >= 20;
      } else {
        chats.clear();
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
      chats.clear();
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
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    final newMessage = ChatMessage(
      messageId: "local_$timestamp", // Explicitly mark as local
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
