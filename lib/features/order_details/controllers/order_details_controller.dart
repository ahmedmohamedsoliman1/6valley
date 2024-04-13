import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/services/order_details_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';



class OrderDetailsController with ChangeNotifier {
  final OrderDetailsServiceInterface orderDetailsServiceInterface;
  OrderDetailsController({required this.orderDetailsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  List <XFile?>_refundImage = [];
  List<XFile?> get refundImage => _refundImage;
  List<File> reviewImages = [];




  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;

  void digitalOnly(bool value, {bool isUpdate = false}){
    _onlyDigital = value;
    if(isUpdate){
      notifyListeners();
    }
  }



  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  Future <ApiResponse> getOrderDetails(String orderID) async {
    _orderDetails = null;
    ApiResponse apiResponse = await orderDetailsServiceInterface.getOrderDetails(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = null;
      _orderDetails = [];
      apiResponse.response!.data.forEach((order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    }
    notifyListeners();
    return apiResponse;
  }




  Orders? orders;
  Future <void> getOrderFromOrderId(String orderID) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.getOrderFromOrderId(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      orders = Orders.fromJson(apiResponse.response!.data);
    }
    notifyListeners();
  }



  void pickImage(bool isRemove, {bool fromReview = false}) async {
    if(isRemove) {
      _imageFile = null;
      _refundImage = [];
      reviewImages = [];
    }else {
      _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (_imageFile != null) {
        if(fromReview){
          reviewImages.add(File(_imageFile!.path));
        }else{
          _refundImage.add(_imageFile);
        }
      }
    }
    notifyListeners();
  }


  void removeImage(int index, {bool fromReview = false}){
    if(fromReview){
      reviewImages.removeAt(index);
    }else{
      _refundImage.removeAt(index);
    }

    notifyListeners();
  }



  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }



  bool searching = false;
  Future<ApiResponse> trackOrder({String? orderId, String? phoneNumber}) async {
    searching = true;
    ApiResponse apiResponse = await orderDetailsServiceInterface.trackOrder(orderId!, phoneNumber!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      searching = false;
      _orderDetails = [];
      apiResponse.response!.data.forEach((order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      searching = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> downloadDigitalProduct({int? orderDetailsId}) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.downloadDigitalProduct(orderDetailsId!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Provider.of<AuthController>(Get.context!, listen: false).resendTime = (apiResponse.response!.data["time_count_in_second"]);
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> resentDigitalProductOtp({int? orderId}) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.resentDigitalProductOtp(orderId!);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> verifyDigitalProductOtp({required int orderId, required String otp}) async {
    ApiResponse apiResponse = await orderDetailsServiceInterface.verifyDigitalProductOtp(orderId, otp);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.of(Get.context!).pop();
      _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.otpVerificationForDigitalProduct}?order_details_id=$orderId&otp=$otp&guest_id=1&action=download'));

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


}
Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}