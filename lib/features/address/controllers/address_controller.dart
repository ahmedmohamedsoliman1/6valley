import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/label_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/models/restricted_zip_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/domain/services/address_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class AddressController with ChangeNotifier {
  final AddressServiceInterface addressServiceInterface;
  AddressController({required this.addressServiceInterface});

  List<String> _restrictedCountryList = [];
  List<String> get restrictedCountryList =>_restrictedCountryList;
  List<RestrictedZipModel> _restrictedZipList =[];
  List<RestrictedZipModel> get restrictedZipList => _restrictedZipList;
  final List<String> _zipNameList = [];
  List<String> get zipNameList => _zipNameList;
  final TextEditingController _searchZipController = TextEditingController();
  TextEditingController get searchZipController => _searchZipController;
  final TextEditingController _searchCountryController = TextEditingController();
  TextEditingController get searchCountryController => _searchCountryController;
  List<AddressModel>? _addressList;
  List<AddressModel>? get addressList => _addressList;
  

  Future<void> getRestrictedDeliveryCountryList() async {
    ApiResponse apiResponse = await addressServiceInterface.getDeliveryRestrictedCountryList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _restrictedCountryList = [];
      apiResponse.response!.data.forEach((address) => _restrictedCountryList.add(address));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  Future<void> getRestrictedDeliveryZipList() async {
    ApiResponse apiResponse = await addressServiceInterface.getDeliveryRestrictedZipList();
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
      _restrictedZipList = [];
      apiResponse.response!.data.forEach((address) => _restrictedZipList.add(RestrictedZipModel.fromJson(address)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  
  Future<void> getDeliveryRestrictedZipBySearch(String searchName) async {
    _restrictedZipList = [];
    ApiResponse response = await addressServiceInterface.getDeliveryRestrictedZipBySearch(searchName);
    if(response.response!.statusCode == 200) {
      _restrictedZipList = [];
      response.response!.data.forEach((address) {
        _restrictedZipList.add(RestrictedZipModel.fromJson(address));
      });
    }else {
      ApiChecker.checkApi(response);
    }
   notifyListeners();
  }


  Future<void> getDeliveryRestrictedCountryBySearch( String searchName) async {
    _restrictedCountryList = [];
    ApiResponse response = await addressServiceInterface.getDeliveryRestrictedCountryBySearch(searchName);
    if(response.response!.statusCode == 200) {
      _restrictedCountryList = [];
      response.response!.data.forEach((address) => _restrictedCountryList.add(address));
    }else {
      ApiChecker.checkApi(response);
    }
    notifyListeners();
  }


  bool _isLoading = false;
  bool get isLoading => _isLoading;



  Future<List<AddressModel>?> getAddressList({bool fromRemove = false, bool isShipping = false, bool isBilling = false, bool all = false }) async {
    _addressList = await addressServiceInterface.getList(isShipping: isShipping, isBilling: isBilling, fromRemove: fromRemove, all: all);
    notifyListeners();
    return _addressList;
  }




  Future<void> deleteAddress(int id) async {
    ApiResponse apiResponse = await addressServiceInterface.delete(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: false);
      getAddressList(fromRemove: true);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await addressServiceInterface.add(addressModel);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response!.data["message"], Get.context!, isError: false);
      getAddressList();
    }
    notifyListeners();
    return apiResponse;
  }


  Future<void> updateAddress(BuildContext context, {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await addressServiceInterface.update(addressModel.toJson(), addressId!);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Navigator.pop(Get.context!);
      getAddressList();
      showCustomSnackBar(apiResponse.response!.data['message'], Get.context!, isError: false);
    }
    notifyListeners();
  }

  void setZip(String zip){
    _searchZipController.text = zip;
    notifyListeners();
  }
  
  void setCountry(String country){
    _searchCountryController.text = country;
    notifyListeners();
  }

  


  List<LabelAsModel> addressTypeList = [];
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  Future<List<LabelAsModel>> getAddressType() async {
    if (addressTypeList.isEmpty) {
      addressTypeList = [];
      addressTypeList = addressServiceInterface.getAddressType();
    }
    return addressTypeList;
  }
  
}
