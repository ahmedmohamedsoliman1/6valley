import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/controllers/compare_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/models/suggestion_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/domain/services/search_product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';

class SearchProductController with ChangeNotifier {
  final SearchProductServiceInterface? searchProductServiceInterface;
  SearchProductController({required this.searchProductServiceInterface});

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  double minPriceForFilter = AppConstants.minFilter;
  double maxPriceForFilter = AppConstants.maxFilter;

  void setMinMaxPriceForFilter(RangeValues currentRangeValues){
    minPriceForFilter = currentRangeValues.start;
    maxPriceForFilter = currentRangeValues.end;
    notifyListeners();
  }

  bool filterApply = false;
  void setFilterApply(){
    filterApply = true;
    notifyListeners();
  }

  String sortText = 'low-high';
  void setFilterIndex(int index) {
    _filterIndex = index;
    if(index == 0){
      sortText = 'latest';
    }else if(index == 1){
      sortText = 'a-z';
    }else if(index == 2){
      sortText = 'z-a';
    }
    else if(index == 3){
      sortText = 'low-high';
    }else if(index ==4){
      sortText = 'high-low';
    }
    notifyListeners();
  }

  double minFilterValue = 0;
  double maxFilterValue = 0;
  void setFilterValue(double min, double max){
  minFilterValue = min;
  maxFilterValue = max;
  }



  bool _isClear = true;
  bool get isClear => _isClear;

  void cleanSearchProduct({bool notify = false}) {
    searchedProduct = null;
    _isClear = true;
    if(notify){
      notifyListeners();
    }
  }






  ProductModel? searchedProduct;
  Future searchProduct({required String query, String? categoryIds, String? brandIds, String? sort, String? priceMin, String? priceMax, required int offset}) async {
    searchController.text = query;
    ApiResponse apiResponse = await searchProductServiceInterface!.getSearchProductList(query, categoryIds, brandIds, sort, priceMin, priceMax, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        searchedProduct = null;
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          searchedProduct = ProductModel.fromJson(apiResponse.response!.data);
        }
      }else{
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          searchedProduct?.products?.addAll(ProductModel.fromJson(apiResponse.response!.data).products!) ;
          searchedProduct?.offset = (ProductModel.fromJson(apiResponse.response!.data).offset) ;
          searchedProduct?.totalSize = (ProductModel.fromJson(apiResponse.response!.data).totalSize) ;
        }
      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  TextEditingController searchController = TextEditingController();
  SuggestionModel? suggestionModel;
  List<String> nameList = [];
  List<int> idList = [];
  Future<void> getSuggestionProductName(String name) async {

    ApiResponse apiResponse = await searchProductServiceInterface!.getSearchProductName(name);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      nameList = [];
      idList = [];
      suggestionModel = SuggestionModel.fromJson(apiResponse.response?.data);
      for(int i=0; i< suggestionModel!.products!.length; i++){
        nameList.add(suggestionModel!.products![i].name!);
        idList.add(suggestionModel!.products![i].id!);
      }
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchProductServiceInterface!.getSavedSearchProductName());

  }

  int selectedSearchedProductId = 0;
  void setSelectedProductId(int index, int? compareId){
    if(suggestionModel!.products!.isNotEmpty){
      selectedSearchedProductId = suggestionModel!.products![index].id!;
    }
    if(compareId != null){
      Provider.of<CompareController>(Get.context!, listen: false).replaceCompareList(compareId ,selectedSearchedProductId);
    }else{
      Provider.of<CompareController>(Get.context!, listen: false).addCompareList(selectedSearchedProductId);
    }
    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchProductServiceInterface!.saveSearchProductName(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchProductServiceInterface!.clearSavedSearchProductName();
    _historyList = [];
    notifyListeners();
  }

}
