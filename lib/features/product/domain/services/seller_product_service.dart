import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/seller_product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/seller_product_service_interface.dart';

class SellerProductService implements SellerProductServiceInterface{
  SellerProductRepositoryInterface sellerProductRepositoryInterface;

  SellerProductService({required this.sellerProductRepositoryInterface});

  @override
  Future getSellerProductList(String sellerId, String offset, String productId, {String search = '', String? categoryIds, String? brandIds}) async{
    return await sellerProductRepositoryInterface.getSellerProductList(sellerId, offset, productId, search: search, categoryIds: categoryIds, brandIds: brandIds);
  }

  @override
  Future getSellerWiseBestSellingProductList(String sellerId, String offset) async{
    return await sellerProductRepositoryInterface.getSellerWiseBestSellingProductList(sellerId, offset);
  }

  @override
  Future getSellerWiseFeaturedProductList(String sellerId, String offset) async{
    return await sellerProductRepositoryInterface.getSellerWiseFeaturedProductList(sellerId, offset);
  }

  @override
  Future getSellerWiseRecomendedProductList(String sellerId, String offset) async{
   return await sellerProductRepositoryInterface.getSellerWiseRecomendedProductList(sellerId, offset);
  }

  @override
  Future getShopAgainFromRecentStoreList() async{
    return await sellerProductRepositoryInterface.getShopAgainFromRecentStoreList();
  }

}