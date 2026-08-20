class CategoryModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      isActive: json['isActive'] ?? true,
    );
  }
}
