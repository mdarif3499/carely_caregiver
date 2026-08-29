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
  final String lastMessageStatus;
  final String lastMessageSenderId;

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
    this.lastMessageStatus = 'SENT',
    this.lastMessageSenderId = '',
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
    String? lastMessageStatus,
    String? lastMessageSenderId,
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
      lastMessageStatus: lastMessageStatus ?? this.lastMessageStatus,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
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
    String status = 'SENT';
    String senderId = '';

    if (lastMsgObj != null) {
      if (lastMsgObj['contentType'] == "IMAGE") {
        displayMsg = "📷 Photo";
      } else {
        displayMsg = lastMsgObj['content'] ?? "";
      }

      // ── Strict Status Logic based on API fields ──
      final readAt = lastMsgObj['readAt'];
      final deliveredAt = lastMsgObj['deliveredAt'];
      final isRead = lastMsgObj['isRead'];

      if (readAt != null && readAt.toString().isNotEmpty || isRead == true) {
        status = 'SEEN';
      } else if (deliveredAt != null && deliveredAt.toString().isNotEmpty) {
        status = 'DELIVERED';
      } else {
        status = (lastMsgObj['status'] ?? 'SENT').toString().toUpperCase();
      }

      senderId = (lastMsgObj['sender'] is Map) 
          ? (lastMsgObj['sender']['_id'] ?? lastMsgObj['sender']['id'] ?? '').toString()
          : (lastMsgObj['sender'] ?? '').toString();
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
      lastMessageStatus: status,
      lastMessageSenderId: senderId,
    );
  }
}

// ── Controller ────────────────────────────────────────
class ChatListController extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<ChatConversation> conversations = <ChatConversation>[].obs;
  final RxBool isLoading = false.obs;

  String currentUserId = '';
  String currentUserRole = '';

  @override
  void onInit() async {
    super.onInit();
    _setPlaceholders();
    
    // Professional: Initialize identity BEFORE starting listeners
    currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
    
    appLog("🚀 CHAT LIST: Initialized for $currentUserRole ($currentUserId)", source: "CHAT");
    
    _setupGlobalSocketListeners();
    fetchConversations();
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
    SocketService.on('message:delivered', _onMessageDeliveredList);
    SocketService.on('message:seen', _onMessageSeenList);
    SocketService.on('conversation:updated', _onConversationUpdated);
  }

  void _onConversationUpdated(data) async {
    if (data == null) return;
    appLog("CONVERSATION UPDATED RECEIVED: $data", source: "CHAT");
    
    // Ensure identity is known
    if (currentUserId.isEmpty) {
      currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
      currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
    }
    
    final updatedConv = ChatConversation.fromJson(data, currentUserId, currentUserRole);
    
    final index = conversations.indexWhere((c) => c.id == updatedConv.id);
    if (index != -1) {
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
    } else {
      conversations.insert(0, updatedConv);
    }
    conversations.refresh();

    // ── Professional Delivery Confirmation ──
    final lastMsg = data['lastMessage'];
    if (lastMsg != null) {
      final senderId = (lastMsg['sender'] is Map) 
          ? (lastMsg['sender']['_id'] ?? lastMsg['sender']['id']) 
          : lastMsg['sender'] ?? '';
      
      final String msgStatus = (lastMsg['status'] ?? 'SENT').toString().toUpperCase();
      final String msgId = (lastMsg['_id'] ?? lastMsg['id'] ?? '').toString();

      // Professional logic: Only confirm if partner sent it and it's strictly not delivered yet
      final bool alreadyDelivered = lastMsg['deliveredAt'] != null || lastMsg['readAt'] != null || lastMsg['isRead'] == true || msgStatus == 'DELIVERED' || msgStatus == 'SEEN';

      if (senderId != currentUserId && !alreadyDelivered && msgId.isNotEmpty) {
        appLog("📤 CHAT LIST: Confirming delivery via UPDATE for message $msgId", source: "CHAT");
        _emitDeliveredStatus(updatedConv.id, msgId, senderId);
      }
    }
  }

  void _onMessageDeliveredList(data) => _updateConversationStatus(data, 'DELIVERED');
  void _onMessageSeenList(data) => _updateConversationStatus(data, 'SEEN');

  void _updateConversationStatus(data, String fallbackStatus) {
    if (data == null) return;
    appLog("📩 CHAT LIST: Status update received: $data", source: "SOCKET");
    
    final String conversationId = data['conversationId'] ?? '';
    
    // Determine status strictly from API fields
    String finalStatus = (data['status'] ?? fallbackStatus).toString().toUpperCase();
    final readAt = data['readAt'];
    final deliveredAt = data['deliveredAt'];
    final isRead = data['isRead'];

    if (readAt != null && readAt.toString().isNotEmpty || isRead == true) {
      finalStatus = 'SEEN';
    } else if (deliveredAt != null && deliveredAt.toString().isNotEmpty) {
      finalStatus = 'DELIVERED';
    }

    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final conv = conversations[index];
      // Only update if it's our message being confirmed
      if (conv.lastMessageSenderId == currentUserId) {
        appLog("✅ CHAT LIST: Updating status to $finalStatus for conversation $conversationId", source: "CHAT");
        conversations[index] = conv.copyWith(lastMessageStatus: finalStatus);
        conversations.refresh();
      }
    }
  }

  @override
  void onClose() {
    SocketService.off('message:new', _onNewMessageList);
    SocketService.off('typing:start', _onPartnerTypingStartList);
    SocketService.off('typing:stop', _onPartnerTypingStopList);
    SocketService.off('message:delivered', _onMessageDeliveredList);
    SocketService.off('message:seen', _onMessageSeenList);
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

    if (currentUserId.isEmpty) {
      currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
    }

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
      final senderId = (data['sender'] is Map) 
          ? (data['sender']['_id'] ?? data['sender']['id'] ?? '').toString()
          : (data['sender'] ?? '').toString();
      
      int newUnread = oldConv.unreadCount;
      if (senderId != currentUserId) {
        newUnread++;
      }

      // Determine status strictly from API fields
      String msgStatus = (data['status'] ?? 'SENT').toString().toUpperCase();
      final readAt = data['readAt'];
      final deliveredAt = data['deliveredAt'];
      final isRead = data['isRead'];

      if (readAt != null && readAt.toString().isNotEmpty || isRead == true) {
        msgStatus = 'SEEN';
      } else if (deliveredAt != null && deliveredAt.toString().isNotEmpty) {
        msgStatus = 'DELIVERED';
      }

      final updatedConv = oldConv.copyWith(
        lastMessage: displayMsg,
        time: DateFormat('hh:mm a').format(DateTime.now()),
        unreadCount: newUnread,
        lastMessageStatus: msgStatus,
        lastMessageSenderId: senderId,
      );

      // Move to top
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);
      conversations.refresh();

      // Emit Delivered Status globally if message is not from us
      if (senderId != currentUserId) {
        final messageId = (data['_id'] ?? data['id'] ?? '').toString();
        if (messageId.isNotEmpty) {
          appLog("📤 CHAT LIST: Confirming delivery via NEW MESSAGE event: $messageId", source: "CHAT");
          _emitDeliveredStatus(conversationId, messageId, senderId);
        }
      }
    } else {
      // It's a new conversation we don't have yet - Refresh list to be safe
      fetchConversations();
    }
  }

  void _emitDeliveredStatus(String convId, String msgId, String messageSenderId) {
    if (convId.isEmpty || msgId.isEmpty || messageSenderId.isEmpty) return;
    SocketService.emit('message:delivered', {
      "messageId": msgId,
      "senderId": messageSenderId,
      "conversationId": convId,
    });
  }



  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;
      update();

      if (currentUserId.isEmpty) {
        currentUserId = await SharePrefsHelper.getString(SharedPreferenceValue.userId);
        currentUserRole = await SharePrefsHelper.getString(SharedPreferenceValue.role);
      }
      
      final response = await ChatRepository.instance.getConversations();

      if (response.isSuccess) {
        final List dataList = response.data['data']?['conversations'] ?? [];
        conversations.value = dataList.map((e) => ChatConversation.fromJson(e, currentUserId, currentUserRole)).toList();

        // Mark as delivered for all unread messages in the list
        for (var convJson in dataList) {
          final lastMsg = convJson['lastMessage'];
          if (lastMsg != null) {
            final senderId = ((lastMsg['sender'] is Map) 
                ? (lastMsg['sender']['_id'] ?? lastMsg['sender']['id']) 
                : lastMsg['sender'] ?? '').toString();
            
            final String msgStatus = (lastMsg['status'] ?? '').toString().toUpperCase();
            final String msgId = (lastMsg['_id'] ?? lastMsg['id'] ?? '').toString();

            // Professional: Only confirm if partner sent it and it's strictly not delivered yet
            final bool alreadyDelivered = lastMsg['deliveredAt'] != null || lastMsg['readAt'] != null || lastMsg['isRead'] == true || msgStatus == 'DELIVERED' || msgStatus == 'SEEN';

            if (senderId.isNotEmpty && senderId != currentUserId && !alreadyDelivered && msgId.isNotEmpty) {
              // Tiny delay to ensure socket is ready for this room/auth
              Future.delayed(const Duration(milliseconds: 500), () {
                appLog("📤 CHAT LIST: Confirming delivery for offline message: $msgId", source: "CHAT");
                _emitDeliveredStatus(convJson['_id'].toString(), msgId, senderId);
              });
            }
          }
        }
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

  void onConversationTap(ChatConversation conversation) async {
    await Get.toNamed(AppRoutes.instance.messageScreen, arguments: conversation);
    fetchConversations();
  }
}
