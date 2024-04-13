import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/services/category_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:provider/provider.dart';

class CategoryController extends ChangeNotifier {
  final CategoryServiceInterface? categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});


  final List<CategoryModel> _categoryList = [];
  int? _categorySelectedIndex;

  List<CategoryModel> get categoryList => _categoryList;
  int? get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList.isEmpty || reload) {
      ApiResponse apiResponse = await categoryServiceInterface!.getList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response!.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }

  Future<void> getSellerWiseCategoryList(int sellerId) async {
      ApiResponse apiResponse = await categoryServiceInterface!.getSellerWiseCategoryList(sellerId);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response!.data.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();

  }

  List<int> selectedCategoryIds = [];
  void checkedToggleCategory(int index){
    _categoryList[index].isSelected = !_categoryList[index].isSelected!;
    notifyListeners();
  }

  void checkedToggleSubCategory(int index, int subCategoryIndex){
    _categoryList[index].subCategories![subCategoryIndex].isSelected = !_categoryList[index].subCategories![subCategoryIndex].isSelected!;
    notifyListeners();
  }

  void resetChecked(int? id, bool fromShop){
    if(fromShop){
      getSellerWiseCategoryList(id!);
      Provider.of<BrandController>(Get.context!, listen: false).getSellerWiseBrandList(id);
      Provider.of<SellerProductController>(Get.context!, listen: false).getSellerProductList(id.toString(), 1, "");
    }else{
      getCategoryList(true);
      Provider.of<BrandController>(Get.context!, listen: false).getBrandList(true);
    }


  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
