
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/repositories/search_product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchProductRepository implements SearchProductRepositoryInterface{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  SearchProductRepository({required this.dioClient, required this.sharedPreferences});

  @override
  Future<ApiResponse> getSearchProductList(String query, String? categoryIds, String? brandIds, String? sort, String? priceMin, String? priceMax, int offset) async {
    try {
      log("===limit==>" );
      final response = await dioClient!.post(AppConstants.searchUri,
          data: {'search' : base64.encode(utf8.encode(query)),
            'category': categoryIds??'[]',
            'brand' : brandIds??'[]',
            'sort_by': sort,
            'price_min' : priceMin,
            'price_max' : priceMax,
            'limit' : '20',
            'offset' : offset,
            'guest_id' : '1'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getSearchProductName(String name) async {
    try {
      final response = await dioClient!.get('${AppConstants.getSuggestionProductName}$name');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<void> saveSearchProductName(String searchAddress) async {
    try {
      List<String> searchKeywordList = sharedPreferences!.getStringList(AppConstants.searchProductName)??[];
      if (!searchKeywordList.contains(searchAddress)) {
        searchKeywordList.add(searchAddress);
      }
      await sharedPreferences!.setStringList(AppConstants.searchProductName, searchKeywordList);
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<String> getSavedSearchProductName() {
    return sharedPreferences!.getStringList(AppConstants.searchProductName) ?? [];
  }

  @override
  Future<bool> clearSavedSearchProductName() async {
    return sharedPreferences!.setStringList(AppConstants.searchProductName, []);
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
