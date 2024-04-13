import 'package:flutter_sixvalley_ecommerce/features/brand/domain/repositories/brand_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/services/brand_service_interface.dart';

class BrandService implements BrandServiceInterface{
  BrandRepoInterface brandRepoInterface;
  BrandService({required this.brandRepoInterface});

  @override
  Future getList() {
    return brandRepoInterface.getList();
  }

  @override
  Future getSellerWiseBrandList(int sellerId) {
    return brandRepoInterface.getSellerWiseBrandList(sellerId);
  }

}