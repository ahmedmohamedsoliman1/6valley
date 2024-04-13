abstract class OrderDetailsServiceInterface {

  Future<dynamic> getOrderFromOrderId(String orderID);

  Future <dynamic> getOrderDetails(String orderID);

  Future<dynamic> downloadDigitalProduct(int orderDetailsId);

  Future<dynamic> resentDigitalProductOtp(int orderId);

  Future<dynamic> verifyDigitalProductOtp(int orderId, String otp);

  Future<dynamic> trackOrder(String orderId, String phoneNumber);

}