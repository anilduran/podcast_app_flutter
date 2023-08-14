import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../utils/constants.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import './auth_provider.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {

  Ref ref;

  CategoriesNotifier(this.ref): super([]);

  void fetchCategories() async {
    try {

      final dio = Dio();

      final token = ref.read(authProvider);

      final response = await dio.get('${Constants.BASE_URL}/api/categories', options: Options(
        headers: {
          'x-access-token': token
        }
      ));

      final List<Category> categories = [];
      for (final model in response.data) {
        categories.add(Category.fromJson(model));
      }
      state = [...categories];

    } catch(error) {
      print(error);
    }
  }

}


final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  
  return CategoriesNotifier(ref);
}); 
