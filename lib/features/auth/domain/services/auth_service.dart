import 'package:flutter_sixvalley_ecommerce/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface{
  AuthRepoInterface authRepoInterface;
  AuthService({required this.authRepoInterface});

  @override
  Future<bool> clearGuestId() {
    return authRepoInterface.clearGuestId();
  }

  @override
  Future<bool> clearSharedData() {
    return authRepoInterface.clearSharedData();
  }

  @override
  Future<bool> clearUserEmailAndPassword() {
    return authRepoInterface.clearUserEmailAndPassword();
  }

  @override
  Future forgetPassword(String identity) {
    return authRepoInterface.forgetPassword(identity);
  }

  @override
  Future getGuestId() {
    return authRepoInterface.getGuestId();
  }

  @override
  String? getGuestIdToken() {
    return authRepoInterface.getGuestIdToken();
  }

  @override
  String getUserEmail() {
    return authRepoInterface.getUserEmail();
  }

  @override
  String getUserPassword() {
    return authRepoInterface.getUserPassword();
  }

  @override
  String getUserToken() {
    return authRepoInterface.getUserToken();
  }

  @override
  bool isGuestIdExist() {
    return authRepoInterface.isGuestIdExist();
  }

  @override
  bool isLoggedIn() {
    return authRepoInterface.isLoggedIn();
  }

  @override
  Future login(Map<String, dynamic> body) {
    return authRepoInterface.login(body);
  }

  @override
  Future logout() {
    return authRepoInterface.logout();
  }

  @override
  Future registration(Map<String, dynamic> body) {
    return authRepoInterface.registration(body);
  }

  @override
  Future resendEmailOtp(String email, String token) {
    return authRepoInterface.resendEmailOtp(email, token);
  }

  @override
  Future resendPhoneOtp(String phone, String token) {
    return authRepoInterface.resendPhoneOtp(phone, token);
  }

  @override
  Future resetPassword(String otp, String identity, String password, String confirmPassword) {
    return authRepoInterface.resetPassword(otp, identity, password, confirmPassword);
  }

  @override
  Future<void> saveGuestId(String id) {
    return authRepoInterface.saveGuestId(id);
  }

  @override
  Future<void> saveUserEmailAndPassword(String email, String password) {
    return authRepoInterface.saveUserEmailAndPassword(email, password);
  }

  @override
  Future<void> saveUserToken(String token) {
    return authRepoInterface.saveUserToken(token);
  }

  @override
  Future sendOtpToEmail(String email, String token) {
    return authRepoInterface.sendOtpToEmail(email, token);
  }

  @override
  Future sendOtpToPhone(String phone, String token) {
    return authRepoInterface.sendOtpToPhone(phone, token);
  }

  @override
  Future setLanguageCode(String code) {
    return authRepoInterface.setLanguageCode(code);
  }

  @override
  Future socialLogin(Map<String, dynamic> body) {
    return authRepoInterface.socialLogin(body);
  }

  @override
  Future updateDeviceToken() {
    return authRepoInterface.updateDeviceToken();
  }

  @override
  Future verifyEmail(String email, String code, String token) {
    return authRepoInterface.verifyEmail(email, code, token);
  }

  @override
  Future verifyOtp(String otp, String identity) {
    return authRepoInterface.verifyOtp(otp, identity);
  }

  @override
  Future verifyPhone(String phone, String otp, String token) {
    return authRepoInterface.verifyPhone(phone, otp, token);
  }

}