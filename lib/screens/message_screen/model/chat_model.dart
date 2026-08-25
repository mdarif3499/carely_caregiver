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
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] ?? {};
    return ChatMessage(
      messageId: json['_id'] ?? '',
      content: json['content'] ?? '',
      userId: sender['_id'] ?? sender['id'] ?? '',
      userName: sender['name'] ?? '',
      userImage: sender['profileImage'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isSending: false,
      isSendingFailed: false,
      files: List<String>.from(json['attachments'] ?? []),
    );
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
    );
  }
}