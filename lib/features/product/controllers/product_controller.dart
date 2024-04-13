import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/find_what_you_need.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/home_category_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/most_demanded_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class ProductController extends ChangeNotifier {
  final ProductServiceInterface? productServiceInterface;
  ProductController({required this.productServiceInterface});

  List<Product>? _latestProductList = [];
  List<Product>? _lProductList;
  List<Product>? get lProductList=> _lProductList;
  List<Product>? _featuredProductList;



  ProductType _productType = ProductType.newArrival;
  String? _title = '${getTranslated('best_selling', Get.context!)}';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstLoading = true;
  int? _latestPageSize = 1;
  int _lOffset = 1;
  int? _lPageSize;
  int? get lPageSize=> _lPageSize;
  int? _featuredPageSize;

  ProductType get productType => _productType;
  String? get title => _title;
  int get lOffset => _lOffset;


  List<int> _offsetList = [];
  List<String> _lOffsetList = [];
  List<String> get lOffsetList=>_lOffsetList;
  List<String> _featuredOffsetList = [];

  List<Product>? get latestProductList => _latestProductList;
  List<Product>? get featuredProductList => _featuredProductList;

  Product? _recommendedProduct;
  Product? get recommendedProduct=> _recommendedProduct;

  bool get filterIsLoading => _filterIsLoading;
  bool get filterFirstLoading => _filterFirstLoading;
  bool get isLoading => _isLoading;
  bool get firstFeaturedLoading => _firstFeaturedLoading;
  bool get firstLoading => _firstLoading;
  int? get latestPageSize => _latestPageSize;
  int? get featuredPageSize => _featuredPageSize;


  bool filterApply = false;

  void isFilterApply (bool apply, {bool reload = false}){
    filterApply = apply;
    if(reload){
      notifyListeners();
    }

  }


  Future<void> getLatestProductList(int offset, {bool reload = false}) async {
    if(reload || offset == 1) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if(!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getFilteredProductList(Get.context!, offset.toString(), _productType, title);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset==1){
          _latestProductList = [];
        }
          if(ProductModel.fromJson(apiResponse.response!.data).products != null){
            _latestProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
            _latestPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
          }

          _filterFirstLoading = false;
          _filterIsLoading = false;
          _filterIsLoading = false;
          removeFirstLoading();
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }

  }

  //latest product
  Future<void> getLProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if(!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getLatestProductList(offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _lProductList = [];
        _lProductList?.addAll(ProductModel.fromJson(apiResponse.response!.data).products??[]);
        _lPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }

  }


  List<ProductTypeModel> productTypeList = [
    ProductTypeModel('new_arrival', ProductType.newArrival),
    ProductTypeModel('top_product', ProductType.topProduct),
    ProductTypeModel('best_selling', ProductType.bestSelling),
    ProductTypeModel('discounted_product', ProductType.discountedProduct),
  ];

  
int selectedProductTypeIndex = 0;
 void changeTypeOfProduct(ProductType type, String? title, {int index = 0}){
    _productType = type;
    _title = title;
    _latestProductList = null;
    _latestPageSize = 1;
    _filterFirstLoading = true;
    _filterIsLoading = true;
    selectedProductTypeIndex = index;
    getLatestProductList(1, reload: true);
    notifyListeners();
 }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }


  TextEditingController sellerProductSearch = TextEditingController();
  void clearSearchField( String id){
    sellerProductSearch.clear();
    notifyListeners();
  }




  final List<Product> _brandOrCategoryProductList = [];
  bool? _hasData;

  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;
  bool? get hasData => _hasData;

  void initBrandOrCategoryProductList(bool isBrand, String id, BuildContext context) async {
    _brandOrCategoryProductList.clear();
    _hasData = true;
    ApiResponse apiResponse = await productServiceInterface!.getBrandOrCategoryProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response!.data.forEach((product) => _brandOrCategoryProductList.add(Product.fromJson(product)));
      _hasData = _brandOrCategoryProductList.length > 1;
      List<Product> products = [];
      products.addAll(_brandOrCategoryProductList);
      _brandOrCategoryProductList.clear();
      _brandOrCategoryProductList.addAll(products);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  List<Product>? _relatedProductList;
  List<Product>? get relatedProductList => _relatedProductList;

  void initRelatedProductList(String id, BuildContext context) async {
    ApiResponse apiResponse = await productServiceInterface!.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response!.data.forEach((product) => _relatedProductList!.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  List<Product>? _moreProductList;
  List<Product>? get moreProductList => _moreProductList;

  void getMoreProductList(String id) async {
    ApiResponse apiResponse = await productServiceInterface!.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response!.data.forEach((product) => _relatedProductList!.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
  }


  double featuredIndex = 0.7;
  void setFeaturedIndex(double index){
    featuredIndex = index;
    notifyListeners();
  }



  Future<void> getFeaturedProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if(!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse = await productServiceInterface!.getFeaturedProductList(offset);
      if (apiResponse.response != null  && apiResponse.response!.statusCode == 200) {
        _featuredProductList = [];
        if(apiResponse.response!.data['products'] != null){
          _featuredProductList?.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
          _featuredPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        }

        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }

  }


  bool recommendedProductLoading = false;
  Future<void> getRecommendedProduct() async {
    ApiResponse apiResponse = await productServiceInterface!.getRecommendedProduct();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _recommendedProduct = Product.fromJson(apiResponse.response!.data);
      }
      notifyListeners();
  }


  final List<HomeCategoryProduct> _homeCategoryProductList = [];
  List<HomeCategoryProduct> get homeCategoryProductList => _homeCategoryProductList;

  Future<void> getHomeCategoryProductList(bool reload) async {
    if (_homeCategoryProductList.isEmpty || reload) {
      ApiResponse apiResponse = await productServiceInterface!.getHomeCategoryProductList();
      if (apiResponse.response != null  && apiResponse.response!.statusCode == 200) {
        if(apiResponse.response!.data.toString() != '{}'){
          _homeCategoryProductList.clear();
          apiResponse.response!.data.forEach((homeCategoryProduct) =>
              _homeCategoryProductList.add(HomeCategoryProduct.fromJson(homeCategoryProduct)));
        }
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }

  MostDemandedProductModel? mostDemandedProductModel;
  Future<void> getMostDemandedProduct() async {
    ApiResponse apiResponse = await productServiceInterface!.getMostDemandedProduct();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(apiResponse.response?.data != null && apiResponse.response?.data.isNotEmpty && apiResponse.response?.data != '[]'){
        mostDemandedProductModel = MostDemandedProductModel.fromJson(apiResponse.response!.data);
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }



  FindWhatYouNeedModel? findWhatYouNeedModel;
  Future<void> findWhatYouNeed() async {
    ApiResponse apiResponse = await productServiceInterface!.getFindWhatYouNeed();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      findWhatYouNeedModel = FindWhatYouNeedModel.fromJson(apiResponse.response?.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  List<Product>? justForYouProduct;
  Future<void> getJustForYouProduct() async {
    justForYouProduct = [];
    ApiResponse apiResponse = await productServiceInterface!.getJustForYouProductList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
    apiResponse.response?.data.forEach((justForYou)=> justForYouProduct?.add(Product.fromJson(justForYou)));
    }
    notifyListeners();
  }

  ProductModel? mostSearchingProduct;
  Future<void> getMostSearchingProduct(int offset, {bool reload = false}) async {
    ApiResponse apiResponse = await productServiceInterface!.getMostSearchingProductList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(apiResponse.response?.data['products'] != null && apiResponse.response?.data['products'] != 'null'){
        if(offset == 1) {
          mostSearchingProduct = ProductModel.fromJson(apiResponse.response?.data);
        }else {
          mostSearchingProduct!.products!.addAll(ProductModel.fromJson(apiResponse.response?.data).products!);
          mostSearchingProduct!.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          mostSearchingProduct!.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
        }
      }


    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();


  }

  int currentJustForYouIndex = 0;
  void setCurrentJustForYourIndex(int index){
    currentJustForYouIndex = index;
    notifyListeners();
  }

}


class ProductTypeModel{
  String? title;
  ProductType productType;

  ProductTypeModel(this.title, this.productType);
}