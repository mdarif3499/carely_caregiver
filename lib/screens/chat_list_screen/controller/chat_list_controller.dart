import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/socket/socket_service.dart';
import '../../../utils/log/app_log.dart';

// ── Model ─────────────────────────────────────────────
class ChatConversation {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;
  final String partnerId;

  const ChatConversation({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.partnerId,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isTyping = false,
  });

  ChatConversation copyWith({
    String? id,
    String? name,
    String? role,
    String? avatarUrl,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? isOnline,
    bool? isTyping,
    String? partnerId,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      isTyping: isTyping ?? this.isTyping,
      partnerId: partnerId ?? this.partnerId,
    );
  }

  factory ChatConversation.fromJson(Map<String, dynamic> json, String currentUserId, String currentUserRole) {
    final List participants = json['participants'] ?? [];
    
    // Find the partner (the user who isn't the logged-in user)
    final partner = participants.firstWhere(
      (p) => p['_id'] != currentUserId,
      orElse: () => participants.isNotEmpty ? participants.first : {},
    );

    String lastTime = "";
    try {
      if (json['lastMessageAt'] != null) {
        final dt = DateTime.parse(json['lastMessageAt']).toLocal();
        lastTime = DateFormat('hh:mm a').format(dt);
      }
    } catch (_) {}

    // Handle last message display text
    final lastMsgObj = json['lastMessage'];
    String displayMsg = "No messages yet";
    if (lastMsgObj != null) {
      if (lastMsgObj['contentType'] == "IMAGE") {
        displayMsg = "📷 Photo";
      } else {
        displayMsg = lastMsgObj['content'] ?? "";
      }
    }

    // Dynamic unread count based on role
    int unread = 0;
    if (currentUserRole == "CLIENT") {
      unread = json['clientUnreadCount'] ?? 0;
    } else if (currentUserRole == "CAREGIVER") {
      unread = json['caregiverUnreadCount'] ?? 0;
    }

    return ChatConversation(
      id: json['_id'] ?? '',
      name: partner['name'] ?? 'Chat',
      role: partner['role'] ?? '',
      avatarUrl: AppApiEndPoint.imageUrl(partner['profileImage']),
      lastMessage: displayMsg,
      time: lastTime,
      unreadCount: unread,
      partnerId: partner['_id'] ?? partner['id'] ?? '',
      isOnline: json['isActive'] ?? false,
    );
  }
}

// ── Controller ────────────────────────────────────────
class ChatListController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ChatConversation> conversations = <ChatConversation>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setPlaceholders();
    fetchConversations();
    _setupGlobalSocketListeners();
  }

  void _setPlaceholders() {
    conversations.value = List.generate(5, (index) => ChatConversation(
      id: 'placeholder_$index',
      name: 'User Name',
      role: 'Role',
      avatarUrl: '',
      lastMessage: 'This is a long placeholder message for shimmering...',
      time: '12:00 PM',
      partnerId: '',
    ));
  }

  void _setupGlobalSocketListeners() {
    SocketService.on('message:new', _onNewMessageList);
    SocketService.on('typing:start', _onPartnerTypingStartList);
    SocketService.on('typing:stop', _onPartnerTypingStopList);
    SocketService.on('message:delivered', _onMessageStatusUpdateList);
    SocketService.on('message:seen', _onMessageStatusUpdateList);
    SocketService.on('conversation:updated', _onConversationUpdated);
  }

  void _onConversationUpdated(data) async {
    if (data == null) return;
    appLog("CONVERSATION UPDATED RECEIVED: $data", source: "CHAT");
    
    final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    final currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
    
    final updatedConv = ChatConversation.fromJson(data, currentUserId, currentUserRole);
    
    final index = conversations.indexWhere((c) => c.id == updatedConv.id);
    if (index != -1) {
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
    } else {
      conversations.insert(0, updatedConv);
    }
    conversations.refresh();
  }

  void _onMessageStatusUpdateList(data) {
    // When a message is seen or delivered, we should refresh the inbox to update indicators if needed
    // or just fetch conversations again for absolute accuracy.
    fetchConversations();
  }

  @override
  void onClose() {
    SocketService.off('message:new', _onNewMessageList);
    SocketService.off('typing:start', _onPartnerTypingStartList);
    SocketService.off('typing:stop', _onPartnerTypingStopList);
    SocketService.off('message:delivered', _onMessageStatusUpdateList);
    SocketService.off('message:seen', _onMessageStatusUpdateList);
    SocketService.off('conversation:updated', _onConversationUpdated);
    super.onClose();
  }

  void _onPartnerTypingStartList(data) {
    if (data == null) return;
    final String conversationId = data['conversationId'] ?? '';
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(isTyping: true);
      conversations.refresh();
    }
  }

  void _onPartnerTypingStopList(data) {
    if (data == null) return;
    final String conversationId = data['conversationId'] ?? '';
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      conversations[index] = conversations[index].copyWith(isTyping: false);
      conversations.refresh();
    }
  }

  void _onNewMessageList(data) {
    if (data == null) return;
    _handleIncomingMessage(data);
  }

  Future<void> _handleIncomingMessage(Map<String, dynamic> data) async {
    final String conversationId = data['conversationId'] ?? data['conversation'] ?? '';
    if (conversationId.isEmpty) return;

    final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);

    // Find the conversation in our list
    final index = conversations.indexWhere((c) => c.id == conversationId);

    if (index != -1) {
      // Update existing conversation
      final oldConv = conversations[index];
      
      // Update last message text
      String displayMsg = data['content'] ?? "";
      if (data['contentType'] == "IMAGE") {
        displayMsg = "📷 Photo";
      }

      // Update unread count if it's not from us
      final senderId = data['sender']?['_id'] ?? data['sender']?['id'] ?? '';
      int newUnread = oldConv.unreadCount;
      if (senderId != currentUserId) {
        newUnread++;
      }

      final updatedConv = ChatConversation(
        id: oldConv.id,
        name: oldConv.name,
        role: oldConv.role,
        avatarUrl: oldConv.avatarUrl,
        lastMessage: displayMsg,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        unreadCount: newUnread,
        isOnline: oldConv.isOnline,
        partnerId: oldConv.partnerId,
      );

      // Move to top
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
      conversations.refresh();

      // Emit Delivered Status globally if message is not from us
      if (senderId != currentUserId) {
        final messageId = data['_id'] ?? data['id'] ?? '';
        _emitDeliveredStatus(conversationId, messageId, currentUserId);
      }
    } else {
      // It's a new conversation we don't have yet - Refresh list to be safe
      fetchConversations();
    }
  }

  void _emitDeliveredStatus(String convId, String msgId, String userId) {
    if (convId.isEmpty || msgId.isEmpty) return;
    SocketService.emit('message:delivered', {
      "messageId": msgId,
      "senderId": userId,
      "conversationId": convId,
    });
  }



  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      update();

      final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
      final currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
      final response = await ChatRepository.instance.getConversations();

      if (response.isSuccess) {
        final List dataList = response.data['data']?['conversations'] ?? [];
        conversations.value = dataList.map((e) => ChatConversation.fromJson(e, currentUserId, currentUserRole)).toList();
      } else {
        conversations.clear();
      }
    } catch (e) {
      debugPrint("Error fetching conversations: $e");
      conversations.clear();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Filtered list (reactive)
  List<ChatConversation> get filteredConversations {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return conversations;
    return conversations.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.lastMessage.toLowerCase().contains(q);
    }).toList();
  }

  void onSearchChanged(value) => searchQuery.value = value;

  void onConversationTap(ChatConversation conversation) {
   Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
  }
}
