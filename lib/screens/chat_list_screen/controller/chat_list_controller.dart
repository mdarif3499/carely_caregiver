import 'package:carely_caregiver/constant/app_api_end_point.dart';
import 'package:carely_caregiver/repositories/chat_repository.dart';
import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:carely_caregiver/services/share_pref_helper/share_pref_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  factory ChatConversation.fromJson(Map<String, dynamic> json, String currentUserId) {
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

    return ChatConversation(
      id: json['_id'] ?? '',
      name: partner['name'] ?? 'Chat',
      role: partner['role'] ?? '',
      avatarUrl: AppApiEndPoint.imageUrl(partner['profileImage']),
      lastMessage: json['lastMessage']?['content'] ?? 'No messages yet',
      time: lastTime,
      unreadCount: 0, // Logic for unread count can be added later
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
  }

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      update();

      final currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
      final response = await ChatRepository.instance.getConversations();

      if (response.isSuccess) {
        final List dataList = response.data['data']?['data'] ?? [];
        conversations.value = dataList.map((e) => ChatConversation.fromJson(e, currentUserId)).toList();
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
