class FaqModel {
  final String id;
  final String question;
  final String answer;
  final int order;
  final String? createdAt;
  final String? updatedAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    this.order = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      order: json['order'] ?? 0,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'order': order,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
