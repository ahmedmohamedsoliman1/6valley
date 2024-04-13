
abstract class WishlistServiceInterface {
  Future<dynamic> getList({int? offset = 1});
  Future<dynamic> add(int productID);
  Future<dynamic> delete(int productID);

}