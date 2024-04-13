import 'dart:developer';

import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'dart:io';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/repositories/review_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReviewRepository implements ReviewRepositoryInterface{
  final DioClient dioClient;
  ReviewRepository({required this.dioClient});

  @override
  Future<ApiResponse> get(String productID) async {
    try {
      final response = await dioClient.get(AppConstants.productReviewUri+productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<http.StreamedResponse> submitReview(ReviewBody reviewBody, List<File> files,  bool update) async {
    log("----repo===>${reviewBody.orderId}");
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(update?'${AppConstants.baseUrl}${AppConstants.updateOrderWiseReview}':'${AppConstants.baseUrl}${AppConstants.submitReviewUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer ${Provider.of<AuthController>(Get.context!, listen: false).getUserToken()}'});
    for(int index=0; index <files.length ; index++) {
      if(files[index].path.isNotEmpty) {
        request.files.add(http.MultipartFile(
          'fileUpload[$index]',
          files[index].readAsBytes().asStream(),
          files[index].lengthSync(),
          filename: files[index].path.split('/').last,
        ));
      }
    }
    if(update){
      request.fields.addAll(<String, String>{
        "id" : reviewBody.id!,
        "order_id" : reviewBody.orderId!,
        'product_id': reviewBody.productId!,
        'comment': reviewBody.comment!,
        '_method' : "put",
        'rating': reviewBody.rating!});
    }else{
      log("----repo===>${reviewBody.orderId}");
      request.fields.addAll(<String, String>{
        "order_id" : reviewBody.orderId?? "100264",
        'product_id': reviewBody.productId!,
        'comment': reviewBody.comment!,
        'rating': reviewBody.rating!});
    }

    log("Here is Body==> ${request.fields.toString()}===>");
    http.StreamedResponse response = await request.send();
    log("Here is Body==> ${request.fields.toString()}===> ${response.statusCode}/${response.stream.asBroadcastStream()}");
    return response;
  }



  @override
  Future<ApiResponse> getOrderWiseReview(String productID, String orderId) async {
    try {
      final response = await dioClient.get("${AppConstants.getOrderWiseReview}$productID/$orderId");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> deleteOrderWiseReviewImage(String id, String name) async {
    try {
      final response = await dioClient.post(AppConstants.deleteOrderWiseReviewImage, data: {
        "id" : id,
        "name" : name,
        "_method" : "delete"
      });
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