import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/seller_product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

class SellerProductRepository implements SellerProductRepositoryInterface{
  final DioClient? dioClient;
  SellerProductRepository({required this.dioClient});


  @override
  Future<ApiResponse> getSellerProductList(String sellerId, String offset, String productId, {String search = '', String? categoryIds="[]", String? brandIds="[]"}) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.sellerProductUri}$sellerId/products?guest_id=1&limit=10&offset=$offset&search=$search&category=$categoryIds&brand_ids=$brandIds&product_id=$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSellerWiseBestSellingProductList(String sellerId, String offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.sellerWiseBestSellingProduct}$sellerId/seller-best-selling-products?guest_id=1&limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSellerWiseFeaturedProductList(String sellerId, String offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.sellerWiseBestSellingProduct}$sellerId/seller-featured-product?guest_id=1&limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getSellerWiseRecomendedProductList(String sellerId, String offset) async {
    try {
      final response = await dioClient!.get(
          '${AppConstants.sellerWiseBestSellingProduct}$sellerId/seller-recommended-products?guest_id=1&limit=10&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getShopAgainFromRecentStoreList() async {
    try {
      final response = await dioClient!.get(AppConstants.shopAgainFromRecentStore);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
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