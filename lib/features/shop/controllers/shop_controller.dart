import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/more_store_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/services/shop_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class ShopController extends ChangeNotifier {
  final ShopServiceInterface? shopServiceInterface;
  ShopController({required this.shopServiceInterface});


  int shopMenuIndex = 0;
  void setMenuItemIndex(int index, {bool notify = true}){
    shopMenuIndex = index;
    if(notify){
      notifyListeners();
    }
  }


  SellerInfoModel? sellerInfoModel ;
  Future<void> getSellerInfo(String sellerId) async {
    ApiResponse apiResponse = await shopServiceInterface!.get(sellerId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      sellerInfoModel = SellerInfoModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }



  bool isLoading = false;
  List<MoreStoreModel> moreStoreList =[];
  Future<ApiResponse> getMoreStore() async {
    moreStoreList = [];
    isLoading = true;
    ApiResponse apiResponse = await shopServiceInterface!.getMoreStore();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response?.data.forEach((store)=> moreStoreList.add(MoreStoreModel.fromJson(store)));
    } else {
      isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }
  String sellerType = "top";
  String sellerTypeTitle = "top_seller";
  void setSellerType(String type, {bool notify = true}){
    sellerType = type;
    sellerModel = null;
    if(sellerType == "top"){
      sellerTypeTitle = "top_seller";
    }
    else if(sellerType == "new"){
      sellerTypeTitle = "new_seller";
    }else{
      sellerTypeTitle = "all_seller";
    }
    getTopSellerList(true, 1,type: sellerType);
    if(notify){
      notifyListeners();
    }
  }

  SellerModel? sellerModel;
  Future<void> getTopSellerList(bool reload, int offset, {required String type}) async {
      ApiResponse apiResponse = await shopServiceInterface!.getSellerList(type, offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1){
          sellerModel = null;
          sellerModel = SellerModel.fromJson(apiResponse.response?.data);
        }else{
          sellerModel?.sellers?.addAll(SellerModel.fromJson(apiResponse.response!.data).sellers??[]);
          sellerModel?.offset  = (SellerModel.fromJson(apiResponse.response!.data).offset!);
          sellerModel?.totalSize  = (SellerModel.fromJson(apiResponse.response!.data).totalSize!);
        }

      }
      notifyListeners();

  }

}
