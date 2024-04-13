import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/models/profile_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/services/profile_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:http/http.dart' as http;


class ProfileController extends ChangeNotifier {
  final ProfileServiceInterface? profileServiceInterface;
  ProfileController({required this.profileServiceInterface});


  ProfileModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  double? _balance;
  double? get balance =>_balance;
  ProfileModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;
  double? loyaltyPoint = 0;
  String userID = '-1';

  Future<String> getUserInfo(BuildContext context) async {
    ApiResponse apiResponse = await profileServiceInterface!.getProfileInfo();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = ProfileModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      _balance = _userInfoModel?.walletBalance?? 0;
      loyaltyPoint = _userInfoModel?.loyaltyPoint?? 0;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return userID;
  }


  Future<ApiResponse> deleteCustomerAccount(BuildContext context, int customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileServiceInterface!.delete(customerId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String message = map ['message'];
      showCustomSnackBar(message, Get.context!, isError: false);

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }



  Future<ResponseModel> updateUserInfo(ProfileModel updateUserModel, String pass, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileServiceInterface!.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      Navigator.of(Get.context!).pop();
    } else {
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }


  void clearProfileData() {
    _userInfoModel = null;
    notifyListeners();
  }

}
