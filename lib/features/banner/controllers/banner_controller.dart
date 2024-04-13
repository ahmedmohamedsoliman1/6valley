import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/services/banner_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:provider/provider.dart';

class BannerController extends ChangeNotifier {
  final BannerServiceInterface? bannerServiceInterface;
  BannerController({required this.bannerServiceInterface});

  List<BannerModel>? _mainBannerList;
  List<BannerModel>? _footerBannerList;
  BannerModel? mainSectionBanner;
  BannerModel? sideBarBanner;
  Product? _product;
  int? _currentIndex;
  List<BannerModel>? get mainBannerList => _mainBannerList;
  List<BannerModel>? get footerBannerList => _footerBannerList;

  Product? get product => _product;
  int? get currentIndex => _currentIndex;
  BannerModel? promoBannerMiddleTop;
  BannerModel? promoBannerRight;
  BannerModel? promoBannerMiddleBottom;
  BannerModel? promoBannerLeft;
  BannerModel? promoBannerBottom;
  BannerModel? sideBarBannerBottom;
  BannerModel? topSideBarBannerBottom;

  Future<void> getBannerList(bool reload) async {
      ApiResponse apiResponse = await bannerServiceInterface!.getList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _mainBannerList = [];
        _footerBannerList = [];

        apiResponse.response!.data.forEach((bannerModel) {
          if(bannerModel['banner_type'] == 'Main Banner'){
            _mainBannerList!.add(BannerModel.fromJson(bannerModel));
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Middle Top'){
            promoBannerMiddleTop = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Right'){
            promoBannerRight = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Promo Banner Middle Bottom'){
            promoBannerMiddleBottom = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Bottom'){
            promoBannerBottom = BannerModel.fromJson(bannerModel);
          }
          else if(bannerModel['banner_type'] == 'Promo Banner Left'){
            promoBannerLeft = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Sidebar Banner'){
            sideBarBanner = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Top Side Banner'){
            topSideBarBannerBottom = BannerModel.fromJson(bannerModel);
          }else if(bannerModel['banner_type'] == 'Footer Banner'){
            _footerBannerList?.add(BannerModel.fromJson(bannerModel));
          }else if(bannerModel['banner_type'] == 'Main Section Banner'){
            mainSectionBanner = BannerModel.fromJson(bannerModel);
          }
        });

        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi( apiResponse);
      }

  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }


  void clickBannerRedirect(BuildContext context, int? id, Product? product,  String? type){
    final cIndex =  Provider.of<CategoryController>(context, listen: false).categoryList.indexWhere((element) => element.id == id);
    final bIndex =  Provider.of<BrandController>(context, listen: false).brandList.indexWhere((element) => element.id == id);
    final tIndex =  Provider.of<ShopController>(context, listen: false).sellerModel!.sellers!.indexWhere((element) => element.id == id);


    if(type == 'category'){
      if(Provider.of<CategoryController>(context, listen: false).categoryList[cIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: false,
          id: id.toString(),
          name: '${Provider.of<CategoryController>(context, listen: false).categoryList[cIndex].name}')));
      }

    }else if(type == 'product'){
      if(product != null) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(
          productId: product.id,slug: product.slug)));
      }

    }else if(type == 'brand'){
      if(Provider.of<BrandController>(context, listen: false).brandList[bIndex].name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
          isBrand: true,
          id: id.toString(),
          name: '${Provider.of<BrandController>(context, listen: false).brandList[bIndex].name}')));
      }

    }else if( type == 'shop'){
      if(Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?[tIndex].shop?.name != null){
        Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
          sellerId: id,
          temporaryClose: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.temporaryClose,
          vacationStatus: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.vacationStatus,
          vacationEndDate: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.vacationEndDate,
          vacationStartDate: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.vacationStartDate,
          name: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.name,
          banner: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.banner,
          image: Provider.of<ShopController>(context,listen: false).sellerModel?.sellers?[tIndex].shop?.image)));
      }

    }
  }

}
