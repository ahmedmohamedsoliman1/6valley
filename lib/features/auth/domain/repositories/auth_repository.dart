import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthRepository implements AuthRepoInterface{
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  AuthRepository({required this.dioClient, required this.sharedPreferences});


  @override
  Future<ApiResponse> socialLogin(Map<String, dynamic>  socialLogin) async {
    try {
      Response response = await dioClient!.post(AppConstants.socialLoginUri, data: socialLogin);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> registration(Map<String, dynamic> register) async {
    try {
      Response response = await dioClient!.post(AppConstants.registrationUri, data: register);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> login(Map<String, dynamic> loginBody) async {
    try {Response response = await dioClient!.post(AppConstants.loginUri, data: loginBody,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> logout() async {
    try {Response response = await dioClient!.get(AppConstants.logOut);
    return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> updateDeviceToken() async {
    try {
      String? deviceToken = await _getDeviceToken();
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
      Response response = await dioClient!.post(
        AppConstants.tokenUri,
        data: {"_method": "put", 'guest_id' : Provider.of<AuthController>(Get.context!, listen: false).getGuestToken(),
          "cm_firebase_token": deviceToken},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> _getDeviceToken() async {
    String? deviceToken;
    if(Platform.isIOS) {
      deviceToken = await FirebaseMessaging.instance.getAPNSToken();
    }else {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }
    if (deviceToken != null) {
      log('--------Device Token---------- $deviceToken--');
    }
    return deviceToken;
  }


  @override
  Future<void> saveUserToken(String token) async {
    dioClient!.updateHeader(token, null);
    try {
      await sharedPreferences!.setString(AppConstants.userLoginToken, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse> setLanguageCode(String languageCode) async {
    try {
      final response = await dioClient!.post(AppConstants.setCurrentLanguage,
          data: {'current_language' : languageCode, '_method' : 'put'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  String getUserToken() {
    return sharedPreferences!.getString(AppConstants.userLoginToken) ?? "";
  }

  @override
  Future<void> saveGuestId(String guestId) async {
    try {
      await sharedPreferences!.setString(AppConstants.guestId, guestId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String? getGuestIdToken() {
    return sharedPreferences!.getString(AppConstants.guestId) ?? "1";
  }

  @override
  bool isGuestIdExist() {
    return sharedPreferences!.containsKey(AppConstants.guestId);
  }

  @override
  Future<bool> clearGuestId() async {
    sharedPreferences!.remove(AppConstants.guestId);
    return true;
  }



  @override
  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.userLoginToken);
  }

  @override
  Future<bool> clearSharedData() async {
    sharedPreferences?.remove(AppConstants.userLoginToken);
    sharedPreferences?.remove(AppConstants.guestId);
    return true;
  }


  @override
  Future<ApiResponse> sendOtpToEmail(String email, String temporaryToken) async {
    try {
      Response response = await dioClient!.post(AppConstants.sendOtpToEmail,
          data: {"email": email, "temporary_token" : temporaryToken});
        return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resendEmailOtp(String email, String temporaryToken) async {
    try {
      Response response = await dioClient!.post(AppConstants.resendEmailOtpUri,
          data: {"email": email, "temporary_token" : temporaryToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> verifyEmail(String email, String token, String tempToken) async {
    try {
      Response response = await dioClient!.post(AppConstants.verifyEmailUri, data: {"email": email, "token": token, 'temporary_token': tempToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> sendOtpToPhone(String phone, String temporaryToken) async {
    try {
      Response response = await dioClient!.post(AppConstants.sendOtpToPhone,
          data: {"phone": phone, "temporary_token" :temporaryToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resendPhoneOtp(String phone, String temporaryToken) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.resendPhoneOtpUri,
          data: {"phone": phone, "temporary_token" :temporaryToken});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> verifyPhone(String phone, String token, String otp) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyPhoneUri, data: {"phone": phone.trim(), "temporary_token": token,"otp": otp});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> verifyOtp(String identity, String otp) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.verifyOtpUri, data: {"identity": identity.trim(), "otp": otp});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> resetPassword(String identity, String otp ,String password, String confirmPassword) async {
    try {
      Response response = await dioClient!.post(
          AppConstants.resetPasswordUri, data: {"_method" : "put", "identity": identity.trim(), "otp": otp,"password": password, "confirm_password":confirmPassword});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }




  @override
  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try {
      await sharedPreferences!.setString(AppConstants.userPassword, password);
      await sharedPreferences!.setString(AppConstants.userEmail, email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String getUserEmail() {
    return sharedPreferences!.getString(AppConstants.userEmail) ?? "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences!.getString(AppConstants.userPassword) ?? "";
  }

  @override
  Future<bool> clearUserEmailAndPassword() async {
    await sharedPreferences!.remove(AppConstants.userPassword);
    return await sharedPreferences!.remove(AppConstants.userEmail);
  }

  @override
  Future<ApiResponse> forgetPassword(String identity) async {
    try {
      Response response = await dioClient!.post(AppConstants.forgetPasswordUri, data: {"identity": identity});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getGuestId() async {
    try {
      final response = await dioClient!.get(AppConstants.getGuestIdUri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future getList({int? offset}) {
    // TODO: implement getList
    throw UnimplementedError();
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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}
