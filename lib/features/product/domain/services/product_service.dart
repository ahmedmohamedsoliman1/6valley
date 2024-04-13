import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';

class ProductService implements ProductServiceInterface{
  ProductRepositoryInterface productRepositoryInterface;

  ProductService({required this.productRepositoryInterface});

  @override
  Future getBrandOrCategoryProductList(bool isBrand, String id) async{
    return await productRepositoryInterface.getBrandOrCategoryProductList(isBrand, id);
  }

  @override
  Future getFeaturedProductList(String offset) async{
   return await productRepositoryInterface.getFeaturedProductList(offset);
  }

  @override
  Future getFilteredProductList(BuildContext context, String offset, ProductType productType, String? title) async{
    return await productRepositoryInterface.getFilteredProductList(context, offset, productType, title);
  }

  @override
  Future getFindWhatYouNeed() async{
    return await productRepositoryInterface.getFindWhatYouNeed();
  }

  @override
  Future getHomeCategoryProductList() async{
    return await productRepositoryInterface.getHomeCategoryProductList();
  }

  @override
  Future getJustForYouProductList() async{
    return await productRepositoryInterface.getJustForYouProductList();
  }

  @override
  Future getLatestProductList(String offset) async{
    return await productRepositoryInterface.getLatestProductList(offset);
  }

  @override
  Future getMostDemandedProduct() async{
    return await productRepositoryInterface.getMostDemandedProduct();
  }

  @override
  Future getMostSearchingProductList(int offset) async{
    return await productRepositoryInterface.getMostSearchingProductList(offset);
  }

  @override
  Future getRecommendedProduct() async{
    return await productRepositoryInterface.getRecommendedProduct();
  }

  @override
  Future getRelatedProductList(String id) async{
    return await productRepositoryInterface.getRelatedProductList(id);
  }

}