import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class AuthRepoInterface<T> implements RepositoryInterface{

  Future<ApiResponse> socialLogin(Map<String, dynamic> body);

  Future<ApiResponse> registration(Map<String, dynamic> body);

  Future<ApiResponse> login(Map<String, dynamic> body);

  Future<ApiResponse> logout();

  Future<ApiResponse> getGuestId();

  Future<ApiResponse> updateDeviceToken();
  
  String getUserToken();
  
  String? getGuestIdToken();
  
  bool isGuestIdExist();
  
  bool isLoggedIn();
  
  Future<bool> clearSharedData();
  
  Future<bool> clearGuestId();
  
  String getUserEmail();
  
  String getUserPassword();
  
  Future<bool> clearUserEmailAndPassword();

  Future<void> saveUserToken(String token);

  Future<ApiResponse> setLanguageCode(String code);

  Future<ApiResponse> forgetPassword(String identity);

  Future<void> saveGuestId(String id);

  Future<ApiResponse> sendOtpToEmail(String email, String token);

  Future<ApiResponse> resendEmailOtp(String email, String token);

  Future<ApiResponse> verifyEmail(String email, String code, String token);

  Future<ApiResponse> sendOtpToPhone(String phone,  String token);

  Future<ApiResponse> resendPhoneOtp(String phone,  String token);

  Future<ApiResponse> verifyPhone(String phone,  String otp, String token);

  Future<ApiResponse> verifyOtp(String otp,  String identity);
  
  Future<void> saveUserEmailAndPassword(String email,  String password);

  Future<ApiResponse> resetPassword(String otp,  String identity, String password, String confirmPassword);

}