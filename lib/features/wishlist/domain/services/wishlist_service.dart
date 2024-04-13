import 'package:flutter_sixvalley_ecommerce/features/wishlist/domain/repositories/wishlist_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/domain/services/wishlist_service_interface.dart';

class WishListService implements WishlistServiceInterface{
  WishListRepositoryInterface wishListRepositoryInterface;

  WishListService({required this.wishListRepositoryInterface});

  @override
  Future add(int productID) async{
    return await wishListRepositoryInterface.add(productID);
  }

  @override
  Future delete(int productID) async{
    return await wishListRepositoryInterface.delete(productID);
  }

  @override
  Future getList({int? offset = 1}) async{
    return await wishListRepositoryInterface.getList(offset: offset);
  }

}