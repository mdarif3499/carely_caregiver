import 'package:carely_caregiver/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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
}

// ── Controller ────────────────────────────────────────
class ChatListController extends GetxController {
  // Search query
  final RxString searchQuery = ''.obs;

  // Full dummy list
  final List<ChatConversation> _allConversations = const [
    ChatConversation(
      id: '1',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage:
          "I'll be there at 9:00 AM for the medication review. Please have...",
      time: '10:45 AM',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatConversation(
      id: '2',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage: 'The lab results came back normal...',
      time: 'Yesterday',
      isOnline: false,
    ),
    ChatConversation(
      id: '3',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage: 'How is the knee feeling after ...',
      time: '10:45 AM',
      unreadCount: 1,
      isOnline: true,
    ),
    ChatConversation(
      id: '4',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage: 'Thank you so much for the help today...',
      time: 'Yesterday',
      unreadCount: 2,
      isOnline: false,
    ),
    ChatConversation(
      id: '5',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage:
          "I'll be there at 9:00 AM for the medication review. Please have...",
      time: 'Mon',
      isOnline: false,
    ),
    ChatConversation(
      id: '6',
      name: 'Sarah Jenkins',
      role: 'RN',
      avatarUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
      lastMessage:
          "I'll be there at 9:00 AM for the medication review. Please have...",
      time: 'Oct 12',
      isOnline: false,
    ),
  ];

  // Filtered list (reactive)
  List<ChatConversation> get filteredConversations {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return _allConversations;
    return _allConversations.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.lastMessage.toLowerCase().contains(q);
    }).toList();
  }

  void onSearchChanged(value) => searchQuery.value = value;

  void onConversationTap(ChatConversation conversation) {
   Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
  }
}
