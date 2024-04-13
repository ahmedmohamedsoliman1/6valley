abstract class CheckoutServiceInterface{

  Future<dynamic> cashOnDeliveryPlaceOrder(String? addressID, String? couponCode,String? couponDiscountAmount, String? billingAddressId, String? orderNote);

  Future<dynamic> offlinePaymentPlaceOrder(String? addressID, String? couponCode, String? couponDiscountAmount, String? billingAddressId, String? orderNote, List <String?> typeKey, List<String> typeValue, int? id, String name, String? paymentNote);

  Future<dynamic> walletPaymentPlaceOrder(String? addressID, String? couponCode,String? couponDiscountAmount, String? billingAddressId, String? orderNote);

  Future<dynamic> digitalPaymentPlaceOrder(String? orderNote, String? customerId, String? addressId, String? billingAddressId, String? couponCode, String? couponDiscount, String? paymentMethod);

  Future<dynamic> offlinePaymentList();
}