import 'dart:developer';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/domain/repositories/shipping_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';

class ShippingRepository implements ShippingRepositoryInterface{
  final DioClient? dioClient;
  ShippingRepository({required this.dioClient});



  @override
  Future<ApiResponse> getShippingMethod(int? sellerId, String? type) async {
    try {
      final response = await dioClient!.get('${AppConstants.getShippingMethod}/$sellerId/$type');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> addShippingMethod(int? id, String? cartGroupId) async {
    log('===>${{"id":id, "cart_group_id": cartGroupId}}');
    try {
      final response = await dioClient!.post(AppConstants.chooseShippingMethod,
          data: {"id":id, 'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
            "cart_group_id": cartGroupId});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getChosenShippingMethod() async {
    try {
      final response =await dioClient!.get('${AppConstants.chosenShippingMethod}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}');
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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }


  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}