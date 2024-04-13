import 'package:flutter_sixvalley_ecommerce/features/category/domain/repositories/category_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/services/category_service_interface.dart';

class CategoryService implements CategoryServiceInterface{
  CategoryRepoInterface categoryRepoInterface;
  CategoryService({required this.categoryRepoInterface});

  @override
  Future getList() async{
    return await categoryRepoInterface.getList();
  }

  @override
  Future getSellerWiseCategoryList(int sellerId) async{
    return await categoryRepoInterface.getSellerWiseCategoryList(sellerId);
  }

}