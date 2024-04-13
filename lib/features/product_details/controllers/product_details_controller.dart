import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/services/product_details_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductDetailsServiceInterface productDetailsServiceInterface;
  ProductDetailsController({required this.productDetailsServiceInterface});


  int? _imageSliderIndex;
  int? _quantity = 0;
  int? _variantIndex;
  List<int>? _variationIndex;
  int? _orderCount;
  int? _wishCount;
  String? _sharableLink;

  bool _isDetails = false;
  bool get isDetails =>_isDetails;
  int? get imageSliderIndex => _imageSliderIndex;
  int? get quantity => _quantity;
  int? get variantIndex => _variantIndex;
  List<int>? get variationIndex => _variationIndex;
  int? get orderCount => _orderCount;
  int? get wishCount => _wishCount;
  String? get sharableLink => _sharableLink;
  ProductDetailsModel? _productDetailsModel;
  ProductDetailsModel? get productDetailsModel => _productDetailsModel;



  Future<void> getProductDetails(BuildContext context, String productId, String slug) async {
    _isDetails = true;
    log("=====slug===>$slug/ $productId");
    ApiResponse apiResponse = await productDetailsServiceInterface.get(slug);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isDetails = false;
      _productDetailsModel = ProductDetailsModel.fromJson(apiResponse.response!.data);
      if(_productDetailsModel != null){
        log("=====slug===>$slug/ $productId");
        Provider.of<SellerProductController>(Get.context!, listen: false).
        getSellerProductList(productDetailsModel!.userId.toString(), 1, productId);
      }

    } else {
      _isDetails = false;
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    _isDetails = false;
    notifyListeners();
  }




  void initData(ProductDetailsModel product, int? minimumOrderQuantity, BuildContext context) {
    _variantIndex = 0;
    _quantity = minimumOrderQuantity;
    _variationIndex = [];
    for (int i=0; i<= product.choiceOptions!.length; i++) {
      _variationIndex!.add(0);
    }
  }

  bool isReviewSelected = false;
  void selectReviewSection(bool review){
    isReviewSelected = review;
    notifyListeners();
  }



  void getCount(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsServiceInterface.getCount(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderCount = apiResponse.response!.data['order_count'];
      _wishCount = apiResponse.response!.data['wishlist_count'];
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  void getSharableLink(String productID, BuildContext context) async {
    ApiResponse apiResponse = await productDetailsServiceInterface.getSharableLink(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _sharableLink = apiResponse.response!.data;
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }



  void setImageSliderSelectedIndex(int selectedIndex) {
    _imageSliderIndex = selectedIndex;
    notifyListeners();
  }


  void setQuantity(int value) {
    _quantity = value;
    notifyListeners();
  }

  void setCartVariantIndex(int? minimumOrderQuantity,int index, BuildContext context) {
    _variantIndex = index;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }

  void setCartVariationIndex(int? minimumOrderQuantity, int index, int i, BuildContext context) {
    _variationIndex![index] = i;
    _quantity = minimumOrderQuantity;
    notifyListeners();
  }


  void removePrevLink() {
    _sharableLink = null;
  }
}
