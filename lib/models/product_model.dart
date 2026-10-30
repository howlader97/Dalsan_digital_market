import 'package:flutter_riverpod_template/models/category_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? thumbnail;
  final List<String> images;
  final double price;
  final String status;
  final double? discount;
  final String? discountType;
  final int? stock;
  final bool isFeatured;
  final String categoryId;
  final String? createdAt;
  final String? updatedAt;
  final CategoryModel? category;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.thumbnail,
    this.images = const [],
    required this.price,
    this.status = 'ACTIVE',
    this.discount,
    this.discountType,
    this.stock,
    this.isFeatured = false,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  /// Calculates the final price after applying discount
  double get effectivePrice {
    if (discount == null || discount == 0) return price;
    if (discountType == 'PERCENTAGE') return price * (1 - discount! / 100);
    if (discountType == 'FIXED_AMOUNT') return price - discount!;
    return price - discount!;
  }

  /// Returns the best available image URL
  String get displayImage {
    if (thumbnail != null && thumbnail!.isNotEmpty) return thumbnail!;
    if (images.isNotEmpty) return images.first;
    return '';
  }

  /// Whether this product has a discount
  bool get hasDiscount => discount != null && discount! > 0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'ACTIVE',
      discount: json['discount']?.toDouble(),
      discountType: json['discountType'],
      stock: json['stock'],
      isFeatured: json['isFeatured'] ?? false,
      categoryId: json['categoryId'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'thumbnail': thumbnail,
      'images': images,
      'price': price,
      'status': status,
      'discount': discount,
      'discountType': discountType,
      'stock': stock,
      'isFeatured': isFeatured,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category?.toJson(),
    };
  }
}
