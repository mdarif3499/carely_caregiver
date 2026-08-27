import '../../../constant/app_api_end_point.dart';

class ChatMessage {
  final String messageId;
  final String content;
  final String userId;
  final String userName;
  final String userImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSending;
  final bool isSendingFailed;
  final List<String> files;
  final String status; // SENT, DELIVERED, SEEN

  ChatMessage({
    required this.messageId,
    required this.content,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.createdAt,
    required this.updatedAt,
    required this.isSending,
    required this.isSendingFailed,
    required this.files,
    this.status = 'SENT',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] ?? {};
    
    String status = 'SENT';
    if (json['readAt'] != null) {
      status = 'SEEN';
    } else if (json['deliveredAt'] != null) {
      status = 'DELIVERED';
    } else if (json['isRead'] == true) {
      status = 'SEEN';
    }

    return ChatMessage(
      messageId: json['_id'] ?? '',
      content: json['content'] ?? '',
      userId: sender['_id'] ?? sender['id'] ?? '',
      userName: sender['name'] ?? '',
      userImage: AppApiEndPoint.imageUrl(sender['profileImage']),
      createdAt: (DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now()).toLocal(),
      updatedAt: (DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now()).toLocal(),
      isSending: false,
      isSendingFailed: false,
      files: _parseAttachments(json),
      status: status,
    );
  }

  static List<String> _parseAttachments(Map<String, dynamic> json) {
    final List<String> files = [];
    
    // Check singular 'attachment' field (String)
    if (json['attachment'] != null && json['attachment'].toString().isNotEmpty) {
      files.add(AppApiEndPoint.imageUrl(json['attachment'].toString()));
    }
    
    // Check plural 'attachments' field (List)
    if (json['attachments'] is List) {
      files.addAll((json['attachments'] as List)
          .map((e) => AppApiEndPoint.imageUrl(e.toString())));
    }
    
    return files;
  }

  ChatMessage copyWith({
    String? messageId,
    String? content,
    String? userId,
    String? userName,
    String? userImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSending,
    bool? isSendingFailed,
    List<String>? files,
    String? status,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSending: isSending ?? this.isSending,
      isSendingFailed: isSendingFailed ?? this.isSendingFailed,
      files: files ?? this.files,
      status: status ?? this.status,
    );
  }
}
