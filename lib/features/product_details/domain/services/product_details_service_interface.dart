abstract class ProductDetailsServiceInterface{
  Future<dynamic> get(String productID);
  Future<dynamic> getCount(String productID);
  Future<dynamic> getSharableLink(String productID);
}