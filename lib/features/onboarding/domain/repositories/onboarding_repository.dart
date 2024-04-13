import 'package:dio/dio.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/domain/models/onboarding_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/domain/repositories/onboarding_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class OnBoardingRepository implements OnBoardingRepositoryInterface{
  final DioClient? dioClient;
  OnBoardingRepository({required this.dioClient});

  @override
  Future<ApiResponse> getList({int? offset}) async {
    try {
      List<OnboardingModel> onBoardingList = [
        OnboardingModel(Images.onBoarding1,
          '${getTranslated('on_boarding_title_one', Get.context!)} ${AppConstants.appName}',
          getTranslated('on_boarding_description_one', Get.context!)),
        OnboardingModel(Images.onBoarding2,
          getTranslated('on_boarding_title_two', Get.context!),
          getTranslated('on_boarding_description_two', Get.context!)),
        OnboardingModel(Images.onBoarding3,
          getTranslated('on_boarding_title_three', Get.context!),
          getTranslated('on_boarding_description_three', Get.context!)),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList,statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }
}