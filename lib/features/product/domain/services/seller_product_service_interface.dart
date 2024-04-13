abstract class SellerProductServiceInterface{
  Future<dynamic> getSellerProductList(String sellerId, String offset, String productId, {String search = '', String? categoryIds, String? brandIds, });

  Future<dynamic> getSellerWiseBestSellingProductList(String sellerId, String offset);

  Future<dynamic> getSellerWiseFeaturedProductList(String sellerId, String offset);

  Future<dynamic> getSellerWiseRecomendedProductList(String sellerId, String offset);

  Future<dynamic> getShopAgainFromRecentStoreList();
}