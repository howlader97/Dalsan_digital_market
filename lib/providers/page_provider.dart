import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/faq_model.dart';
import 'package:flutter_riverpod_template/models/page_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';

/// Provider to fetch Privacy Policy page
final privacyPolicyProvider = FutureProvider.autoDispose<PageModel?>((ref) async {
  final response = await ApiServices.instance.getServices(
    '${AppApiUrl.instance.pageByType}/privacy-policy',
  );
  if (response == null) return null;
  final data = response['data'];
  if (data is Map<String, dynamic>) {
    return PageModel.fromJson(data);
  }
  return null;
});

/// Provider to fetch Terms & Conditions page
final termsConditionsProvider = FutureProvider.autoDispose<PageModel?>((ref) async {
  final response = await ApiServices.instance.getServices(
    '${AppApiUrl.instance.pageByType}/terms-conditions',
  );
  if (response == null) return null;
  final data = response['data'];
  if (data is Map<String, dynamic>) {
    return PageModel.fromJson(data);
  }
  return null;
});

/// Provider to fetch About page
final aboutProvider = FutureProvider.autoDispose<PageModel?>((ref) async {
  final response = await ApiServices.instance.getServices(
    '${AppApiUrl.instance.pageByType}/about',
  );
  if (response == null) return null;
  final data = response['data'];
  if (data is Map<String, dynamic>) {
    return PageModel.fromJson(data);
  }
  return null;
});

/// Provider to fetch FAQs list
final faqsProvider = FutureProvider.autoDispose<List<FaqModel>>((ref) async {
  final response = await ApiServices.instance.getServices(
    AppApiUrl.instance.faqs,
  );
  if (response == null) return [];
  final List data = response['data'] ?? [];
  return data.map((e) => FaqModel.fromJson(e as Map<String, dynamic>)).toList();
});
