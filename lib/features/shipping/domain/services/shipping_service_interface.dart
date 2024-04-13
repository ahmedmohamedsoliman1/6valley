abstract class ShippingServiceInterface{
  Future<dynamic> getShippingMethod(int? sellerId, String? type);

  Future<dynamic> addShippingMethod(int? id, String? cartGroupId);

  Future<dynamic> getChosenShippingMethod();


}