import 'package:flutter/foundation.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/models/attribute_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/models/compare_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/services/compare_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';


class CompareController extends ChangeNotifier {
  final CompareServiceInterface compareServiceInterface;
  CompareController({required this.compareServiceInterface});



  void addCompareList(int productID) async {
    ApiResponse apiResponse = await compareServiceInterface.addCompareProductList(productID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getCompareList();
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: false);
    } else {
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }

  List<int> compIds = [];
  CompareModel? compareModel;
  void getCompareList() async {

    ApiResponse apiResponse = await compareServiceInterface.getList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      compIds = [];
      compareModel = null;
      compareModel = CompareModel.fromJson(apiResponse.response?.data);
      for(int i = 0; i< compareModel!.compareLists!.length; i++){
        compIds.add(compareModel!.compareLists![i].productId!);
      }
    } else {
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }

  void removeAllCompareList() async {
    ApiResponse apiResponse = await compareServiceInterface.removeAllCompareProductList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: false);
      getCompareList();
    } else {
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }

  void replaceCompareList(int compareId, int productId) async {
    ApiResponse apiResponse = await compareServiceInterface.replaceCompareProductList(compareId, productId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getCompareList();
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: false);
    } else {
      showCustomSnackBar(apiResponse.error.toString(), Get.context!);
    }
    notifyListeners();
  }


  List<AttributeModel>? attributeList = [];
  void getAttributeList() async {
    ApiResponse response = await compareServiceInterface.getAttributeList();
    if (response.response != null && response.response!.statusCode == 200) {
      attributeList = [];
      response.response!.data.forEach((attribute) {
        attributeList!.add(AttributeModel.fromJson(attribute));
      });
    } else {
      ApiChecker.checkApi( response);
    }
    notifyListeners();

  }





}
