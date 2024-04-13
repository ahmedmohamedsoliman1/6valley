import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/services/review_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ReviewController extends ChangeNotifier {
  final ReviewServiceInterface reviewServiceInterface;
  ReviewController({required this.reviewServiceInterface});



  List<ReviewModel>? _reviewList;
  List<ReviewModel>? get reviewList => _reviewList;
  int _rating = 0;
  bool _isLoading = false;
  String? _errorText;
  bool _hasConnection = true;


  int get rating => _rating;
  bool get isLoading => _isLoading;
  String? get errorText => _errorText;
  bool get hasConnection => _hasConnection;


  Future<void> getReviewList(int? productId,String? productSlug, BuildContext context) async {
    _hasConnection = true;
    ApiResponse reviewResponse = await reviewServiceInterface.get(productId.toString());
    if (reviewResponse.response != null && reviewResponse.response!.statusCode == 200) {
      _reviewList = [];
      reviewResponse.response!.data.forEach((reviewModel) => _reviewList!.add(ReviewModel.fromJson(reviewModel)));
    } else {
      ApiChecker.checkApi( reviewResponse);
    }
    notifyListeners();
  }

  Future<ResponseModel> submitReview(ReviewBody reviewBody, List<File> files, bool update) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await reviewServiceInterface.submitReview(reviewBody, files, update);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      Provider.of<OrderDetailsController>(Get.context!, listen: false).reviewImages = [];
      _rating = 0;
      responseModel = ResponseModel('${getTranslated('Review submitted successfully', Get.context!)}', true);
      _errorText = null;
      notifyListeners();
    } else {
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }



  ReviewModel? orderWiseReview;
  Future<void> getOrderWiseReview(String productId, String orderId) async {
    ApiResponse reviewResponse = await reviewServiceInterface.getOrderWiseReview(productId, orderId);
    if (reviewResponse.response != null && reviewResponse.response!.statusCode == 200) {
      orderWiseReview = null;
      orderWiseReview = ReviewModel.fromJson(reviewResponse.response?.data);
    } else {
      ApiChecker.checkApi( reviewResponse);
    }
    notifyListeners();
  }

  Future<void> deleteOrderWiseReviewImage(String id, String name, String productId, String orderId) async {
    ApiResponse reviewResponse = await reviewServiceInterface.deleteOrderWiseReviewImage(id, name);
    if (reviewResponse.response != null && reviewResponse.response!.statusCode == 200) {
      getOrderWiseReview(productId, orderId);
    } else {
      ApiChecker.checkApi( reviewResponse);
    }
    notifyListeners();
  }


  void removePrevReview() {
    _reviewList = null;
  }
  void setErrorText(String? error) {
    _errorText = error;
    notifyListeners();
  }

  void removeData() {
    _errorText = null;
    _rating = 0;
    notifyListeners();
  }
  void setRating(int rate) {
    _rating = rate;
    notifyListeners();
  }


  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  List <XFile?>_refundImage = [];
  List<XFile?> get refundImage => _refundImage;
  List<File> reviewImages = [];
  void pickImage(bool isRemove, {bool fromReview = false}) async {
    if(isRemove) {
      _imageFile = null;
      _refundImage = [];
      reviewImages = [];
    }else {
      _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (_imageFile != null) {
        if(fromReview){
          reviewImages.add(File(_imageFile!.path));
        }else{
          _refundImage.add(_imageFile);
        }
      }
    }
    notifyListeners();
  }

  void initReviewImage(){
    reviewImages = [];
  }

  void removeImage(int index, {bool fromReview = false}){
    if(fromReview){
      reviewImages.removeAt(index);
    }else{
      _refundImage.removeAt(index);
    }
    notifyListeners();
  }
}