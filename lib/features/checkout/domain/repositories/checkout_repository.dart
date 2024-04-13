
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/domain/repositories/checkout_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class CheckoutRepository implements CheckoutRepositoryInterface{
  final DioClient? dioClient;
  CheckoutRepository({required this.dioClient});


  @override
  Future<ApiResponse> cashOnDeliveryPlaceOrder(String? addressID, String? couponCode,String? couponDiscountAmount, String? billingAddressId, String? orderNote) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderPlaceUri}?address_id=$addressID&coupon_code=$couponCode&coupon_discount=$couponDiscountAmount&billing_address_id=$billingAddressId&order_note=$orderNote&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()? 0 :1 }');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> offlinePaymentPlaceOrder(String? addressID, String? couponCode, String? couponDiscountAmount, String? billingAddressId, String? orderNote, List <String?> typeKey, List<String> typeValue, int? id, String name, String? paymentNote) async {
    try {
      Map<String?, String> fields = {};
      Map<String?, String> info = {};
      for(var i = 0; i < typeKey.length; i++){
        info.addAll(<String?, String>{
          typeKey[i] : typeValue[i]
        });
      }

      fields.addAll(<String, String>{
        "method_informations" : base64.encode(utf8.encode(jsonEncode(info))),
        'method_name': name,
        'method_id': id.toString(),
        'payment_note' : paymentNote??'',
        'address_id': addressID??'',
        'coupon_code' : couponCode??"",
        'coupon_discount' : couponDiscountAmount??'',
        'billing_address_id' : billingAddressId??'',
        'order_note' : orderNote??'',
        'guest_id': Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()??'',
        'is_guest' : Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()? '0':'1'

      });
      Response response = await dioClient!.post(AppConstants.offlinePayment, data: fields);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> walletPaymentPlaceOrder(String? addressID, String? couponCode,String? couponDiscountAmount, String? billingAddressId, String? orderNote) async {
    try {
      final response = await dioClient!.get('${AppConstants.walletPayment}?address_id=$addressID&coupon_code=$couponCode&coupon_discount=$couponDiscountAmount&billing_address_id=$billingAddressId&order_note=$orderNote&guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()? 0 :1}',);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> offlinePaymentList() async {
    try {
      final response = await dioClient!.get('${AppConstants.offlinePaymentList}?guest_id=${Provider.of<AuthController>(Get.context!, listen: false).getGuestToken()}&is_guest=${!Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> digitalPaymentPlaceOrder(
      String? orderNote,
      String? customerId,
      String? addressId,
      String? billingAddressId,
      String? couponCode,
      String? couponDiscount,
      String? paymentMethod,
      ) async {

    try {
      final response = await dioClient!.post(AppConstants.digitalPayment, data: {
        "order_note": orderNote,
        "customer_id":  customerId,
        "address_id": addressId,
        "billing_address_id": billingAddressId,
        "coupon_code": couponCode,
        "coupon_discount": couponDiscount,
        "payment_platform" : "app",
        "payment_method" : paymentMethod,
        "callback" : null,
        "payment_request_from" : "app",
        'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
        'is_guest': !Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn(),
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
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
