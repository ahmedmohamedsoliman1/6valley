abstract class AuthServiceInterface{

  Future<dynamic> socialLogin(Map<String, dynamic> body);

  Future<dynamic> registration(Map<String, dynamic> body, );

  Future<dynamic> login(Map<String, dynamic> body);

  Future<dynamic> logout();

  Future<dynamic> getGuestId();

  Future<dynamic> updateDeviceToken();

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

  Future<dynamic> setLanguageCode(String token);

  Future<dynamic> forgetPassword(String identity);

  Future<void> saveGuestId(String id);

  Future<dynamic> sendOtpToEmail(String email, String token);

  Future<dynamic> resendEmailOtp(String email, String token);

  Future<dynamic> verifyEmail(String email, String code, String token);

  Future<dynamic> sendOtpToPhone(String phone,  String token);

  Future<dynamic> resendPhoneOtp(String phone,  String token);

  Future<dynamic> verifyPhone(String phone,  String otp, String token);

  Future<dynamic> verifyOtp(String otp,  String identity);

  Future<void> saveUserEmailAndPassword(String email,  String password);

  Future<dynamic> resetPassword(String otp,  String identity, String password, String confirmPassword);
}