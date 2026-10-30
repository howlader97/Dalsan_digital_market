class PageModel {
  final String id;
  final String type;
  final String title;
  final String content;
  final String? createdAt;
  final String? updatedAt;

  PageModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
