import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShopInfoWidget extends StatefulWidget {
  final String sellerId;
  const ShopInfoWidget({super.key, required this.sellerId});

  @override
  State<ShopInfoWidget> createState() => _ShopInfoWidgetState();
}

class _ShopInfoWidgetState extends State<ShopInfoWidget> {
  @override
  void initState() {
    Provider.of<ShopController>(context, listen: false).getSellerInfo(widget.sellerId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double sellerIconSize = 50;
    var splashController = Provider.of<SplashController>(context,listen: false);


    return Consumer<ShopController>(
      builder: (context, seller, child) {
        return seller.sellerInfoModel != null ?
        Container(margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
              Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, 0),
          color: Theme.of(context).cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: sellerIconSize,height: sellerIconSize,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(sellerIconSize),
                      border: Border.all(width: .5,color: Theme.of(context).hintColor)),
                    child: ClipRRect(borderRadius: BorderRadius.circular(sellerIconSize),
                      child: CustomImageWidget(image: seller.sellerInfoModel?.seller != null? '${splashController.baseUrls?.shopImageUrl}/${seller.sellerInfoModel?.seller?.shop?.image}':
                      "${Provider.of<SplashController>(context, listen: false).configModel?.companyIcon}"))),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),


                  Expanded(child: Column(children: [
                      Row(children: [
                        Expanded(child: InkWell(
                            onTap: () {
                              log("==id11=>${seller.sellerInfoModel?.seller?.toJson()}");
                              if(seller.sellerInfoModel?.seller != null){
                                log("==id00=>${seller.sellerInfoModel?.seller?.toJson()}");
                                Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
                                    sellerId:  seller.sellerInfoModel?.seller?.id,
                                    temporaryClose: seller.sellerInfoModel?.seller?.shop?.temporaryClose??false,
                                    vacationStatus: seller.sellerInfoModel?.seller?.shop?.vacationStatus??false,
                                    vacationEndDate: seller.sellerInfoModel?.seller?.shop?.vacationEndDate,
                                    vacationStartDate: seller.sellerInfoModel?.seller?.shop?.vacationStartDate,
                                    name: seller.sellerInfoModel?.seller?.shop?.name,
                                    banner: seller.sellerInfoModel?.seller?.shop?.banner,
                                    image: seller.sellerInfoModel?.seller?.shop?.image)));
                              }else{
                                log("==id22=>${seller.sellerInfoModel?.seller?.toJson()}");
                              Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
                              sellerId: 0,
                              temporaryClose: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status == 1 ,
                              vacationStatus: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status == 1,
                              vacationEndDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate,
                              vacationStartDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate,
                              name: Provider.of<SplashController>(context, listen: false).configModel?.companyName,
                              banner: Provider.of<SplashController>(context, listen: false).configModel?.companyCoverImage,
                              image: Provider.of<SplashController>(context, listen: false).configModel?.companyIcon)));
                              }
                              },
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(seller.sellerInfoModel != null ? seller.sellerInfoModel?.seller?.shop?.name ?? '${Provider.of<SplashController>(context, listen: false).configModel?.companyName}'  : '${Provider.of<SplashController>(context, listen: false).configModel?.companyName}',
                                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                  child: Row(children: [
                                      RatingBar(rating: seller.sellerInfoModel != null ? double.parse(seller.sellerInfoModel!.avgRating!.toString()) : 0),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text(seller.sellerInfoModel != null ?
                                    '(${seller.sellerInfoModel?.totalReview})'  : '',
                                      style: titleRegular.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).hintColor)
                                    )]))]))),


                        InkWell(onTap: () {

                            if(!Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                              showModalBottomSheet(context: context, builder: (_) => const NotLoggedInBottomSheetWidget());
                            }else if(seller.sellerInfoModel != null && ((seller.sellerInfoModel?.seller?.shop?.temporaryClose??false) || (seller.sellerInfoModel?.seller?.shop?.vacationStatus??false))){
                              showCustomSnackBar("${getTranslated("this_shop_is_close_now", context)}", context);
                            }
                            else if(seller.sellerInfoModel != null) {
                              if(seller.sellerInfoModel?.seller != null){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                                    id: seller.sellerInfoModel!.seller!.id,
                                    name: seller.sellerInfoModel!.seller!.shop!.name)));
                              }else{
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                                    id: 0,
                                    name: Provider.of<SplashController>(context, listen: false).configModel?.companyName)));
                              }
                            }
                          },
                          child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),decoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)
                          ),
                              child: Image.asset(Images.chatImage, height: Dimensions.iconSizeDefault))),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),



                    ]),
                  ),
                ],
              ),

            seller.sellerInfoModel != null?
            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                Row(children: [
                  Text(seller.sellerInfoModel!.totalReview.toString(),
                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  Text(getTranslated('reviews', context)!,
                    style: titleRegular.copyWith(color: Theme.of(context).hintColor))]),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Container(width: 1, height: 10, color: ColorResources.visitShop(context))),


                Row(children: [
                  Text(NumberFormat.compact().format(seller.sellerInfoModel!.totalProduct),
                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                  Text(getTranslated('products', context)!,
                    style: titleRegular.copyWith(color: Theme.of(context).hintColor))])
              ]),
            ):const SizedBox(),

            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal:  Dimensions.paddingSizeLarge),
              child: InkWell(onTap: (){
                log("==id11=>${seller.sellerInfoModel?.seller?.toJson()}");
                if(seller.sellerInfoModel?.seller != null){
                  log("==id00=>${seller.sellerInfoModel?.seller?.toJson()}");
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
                      sellerId:  seller.sellerInfoModel?.seller?.id,
                      temporaryClose: seller.sellerInfoModel?.seller?.shop?.temporaryClose??false,
                      vacationStatus: seller.sellerInfoModel?.seller?.shop?.vacationStatus??false,
                      vacationEndDate: seller.sellerInfoModel?.seller?.shop?.vacationEndDate,
                      vacationStartDate: seller.sellerInfoModel?.seller?.shop?.vacationStartDate,
                      name: seller.sellerInfoModel?.seller?.shop?.name,
                      banner: seller.sellerInfoModel?.seller?.shop?.banner,
                      image: seller.sellerInfoModel?.seller?.shop?.image)));
                }else{
                  log("==id22=>${seller.sellerInfoModel?.seller?.toJson()}");
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
                      sellerId: 0,
                      temporaryClose: Provider.of<SplashController>(context, listen: false).configModel?.inhouseTemporaryClose?.status == 1 ,
                      vacationStatus: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.status == 1,
                      vacationEndDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationEndDate,
                      vacationStartDate: Provider.of<SplashController>(context, listen: false).configModel?.inhouseVacationAdd?.vacationStartDate,
                      name: Provider.of<SplashController>(context, listen: false).configModel?.companyName,
                      banner: Provider.of<SplashController>(context, listen: false).configModel?.companyCoverImage,
                      image: Provider.of<SplashController>(context, listen: false).configModel?.companyIcon)));
                }
              },
                child: Container(width: MediaQuery.of(context).size.width, height: 40,
                  decoration: BoxDecoration(color: ColorResources.visitShop(context),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                  child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: SizedBox(width: 20, child: Image.asset(Images.storeIcon, color: Theme.of(context).primaryColor))),
                      Text(getTranslated('visit_store', context)!,
                        style: titleRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor : Theme.of(context).primaryColor),),
                    ],
                  )),
                ),
              ),
            )
            ],
          ),
        ):const SizedBox();
      },
    );
  }
}
