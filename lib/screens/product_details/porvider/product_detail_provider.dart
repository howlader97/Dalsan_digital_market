import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/product_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';

/// Family provider to fetch a single product by ID
final productDetailProvider = FutureProvider.autoDispose.family<ProductModel?, String>((ref, productId) async {
  final response = await ApiServices.instance.getServices(
    '${AppApiUrl.instance.products}/$productId',
    queryParameters: {'viewerId': 'app-user-${DateTime.now().millisecondsSinceEpoch}'},
  );
  if (response == null) return null;
  final data = response['data'];
  if (data == null) return null;
  return ProductModel.fromJson(data);
});
