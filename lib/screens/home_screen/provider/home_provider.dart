import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/category_model.dart';
import 'package:flutter_riverpod_template/models/product_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';

/// Provider to fetch featured categories from API
final categoriesProvider = FutureProvider.autoDispose<List<CategoryModel>>((ref) async {
  final response = await ApiServices.instance.getServices(
    AppApiUrl.instance.categoriesFeatured,
  );
  if (response == null) return [];
  final List data = response['data'] ?? [];
  return data.map((e) => CategoryModel.fromJson(e)).toList();
});

/// Provider for the selected category ID (null = "For you" / all products)
final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);

/// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider to fetch products based on selected category and search query
final productsProvider = FutureProvider.autoDispose<List<ProductModel>>((ref) async {
  final categoryId = ref.watch(selectedCategoryIdProvider);
  final searchQuery = ref.watch(searchQueryProvider).trim();

  final queryParams = <String, dynamic>{
    'limit': '100',
  };

  if (searchQuery.isNotEmpty) {
    queryParams['search'] = searchQuery;
  }

  // If a specific category is selected, filter by that category
  // If categoryId is null ("For you"), no category filter is applied, showing all products
  if (categoryId != null) {
    queryParams['categoryId'] = categoryId;
  }

  final response = await ApiServices.instance.getServices(
    AppApiUrl.instance.products,
    queryParameters: queryParams,
  );
  if (response == null) return [];
  final data = response['data'];
  if (data is Map) {
    final List result = data['result'] ?? [];
    return result.map((e) => ProductModel.fromJson(e)).toList();
  }
  return [];
});

