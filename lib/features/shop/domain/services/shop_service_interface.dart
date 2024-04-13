abstract class ShopServiceInterface{
  Future<dynamic> getMoreStore();
  Future<dynamic> getSellerList(String type, int offset);
  Future<dynamic> get(String id);
}