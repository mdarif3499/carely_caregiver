import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/socket/socket_service.dart';

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

  const ChatConversation({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });

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
        final dt = DateTime.parse(json['lastMessageAt']);
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
    fetchConversations();
    _setupGlobalSocketListeners();
  }

  void _setupGlobalSocketListeners() {
    SocketService.on('message:new', (data) {
      if (data == null) return;
      _handleIncomingMessage(data);
    });
  }

  Future<void> _handleIncomingMessage(Map<String, dynamic> data) async {
    final String conversationId = data['conversation'] ?? '';
    if (conversationId.isEmpty) return;

    final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    final currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);

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
      );

      // Move to top
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
      conversations.refresh();
    } else {
      // It's a new conversation we don't have yet - Refresh list to be safe
      fetchConversations();
    }
  }

  @override
  void onClose() {
    SocketService.off('message:new', (data) {});
    super.onClose();
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
      }
    } catch (e) {
      debugPrint("Error fetching conversations: $e");
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
