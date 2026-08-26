class CMSModel {
  final String id;
  final String slug;
  final String content;
  final String title;
  final DateTime updatedAt;

  CMSModel({
    required this.id,
    required this.slug,
    required this.content,
    required this.title,
    required this.updatedAt,
  });

  factory CMSModel.fromJson(Map<String, dynamic> json) {
    return CMSModel(
      id: json['_id'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      title: json['title'] ?? '',
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
