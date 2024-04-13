import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deal_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';


class FlashDealsListWidget extends StatelessWidget {
  final bool isHomeScreen;
  const FlashDealsListWidget({super.key, this.isHomeScreen = true});

  @override
  Widget build(BuildContext context) {

    return isHomeScreen?
    Consumer<FlashDealController>(
      builder: (context, flashDealController, child) {
        return flashDealController.flashDeal != null ? flashDealController.flashDealList.isNotEmpty ?
        CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: ResponsiveHelper.isTab(context)? .5 :.7,
            autoPlay: true,
              pauseAutoPlayOnTouch: true,
              pauseAutoPlayOnManualNavigate: true,
            enlargeFactor: 0.4,
            enlargeCenterPage: true,
            pauseAutoPlayInFiniteScroll: true,
            disableCenter: true,
            onPageChanged: (index, reason) => flashDealController.setCurrentIndex(index)),
          itemCount: flashDealController.flashDealList.isEmpty ? 1 : flashDealController.flashDealList.length,
          itemBuilder: (context, index, _) => FlashDealWidget(product: flashDealController.flashDealList[index], index: index),
        ) : const SizedBox() : const FlashDealShimmer();
      }):

    Consumer<FlashDealController>(
      builder: (context, flashDealController, child) {
        return flashDealController.flashDealList.isNotEmpty ?
        ListView.builder(
          padding: const EdgeInsets.all(0),
          scrollDirection:  Axis.vertical,
          itemCount: flashDealController.flashDealList.length,
          itemBuilder: (context, index) {

            return InkWell(onTap: () {
                Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),
                  pageBuilder: (context, anim1, anim2) => ProductDetails(productId: flashDealController.flashDealList[index].id,
                    slug: flashDealController.flashDealList[index].slug)));
              },
              child: Container(margin: const EdgeInsets.all(5),
                width: isHomeScreen ? 300 : null, height: 150,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).highlightColor,
                    boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme?null :
                    [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                child: Stack(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                    Expanded(flex: 4,
                      child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(color: ColorResources.getIconBg(context),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                        child: CustomImageWidget(image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.productThumbnailUrl}'
                            '/${flashDealController.flashDealList[index].thumbnail}'))),

                    Expanded(flex: 6,
                      child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Row(children: [
                                Text(flashDealController.flashDealList[index].rating!.isNotEmpty ?
                                double.parse(flashDealController.flashDealList[index].rating![0].average!).toStringAsFixed(1) : '0.0',
                                  style: textRegular.copyWith( fontSize: Dimensions.fontSizeSmall),
                                ),
                                Icon(Icons.star, color: Provider.of<ThemeController>(context).darkTheme ?
                                Colors.white : Colors.orange, size: 15),

                                Text('(${flashDealController.flashDealList[index].reviewCount.toString()})',
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,)),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeDefault,),
                            Row(children: [
                                Expanded(child: Text(flashDealController.flashDealList[index].name!,
                                  style: textRegular, maxLines: 2, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 50)]),

                            const SizedBox(height: Dimensions.paddingSizeDefault,),





                            Row(children: [
                                Text(flashDealController.flashDealList[index].discount! > 0 ?
                                  PriceConverter.convertPrice(context, flashDealController.flashDealList[index].unitPrice) : '',
                                  style: textRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),


                                Text(PriceConverter.convertPrice(context, flashDealController.flashDealList[index].unitPrice,
                                    discountType: flashDealController.flashDealList[index].discountType,
                                    discount: flashDealController.flashDealList[index].discount),
                                  style: titleRegular.copyWith(color: ColorResources.getPrimary(context),
                                      fontSize: Dimensions.fontSizeLarge))]),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall)])))]),


                  flashDealController.flashDealList[index].discount! >= 1 ?
                  Positioned(top: 15, left: 10,
                    child: Container(height: 20, alignment: Alignment.center,
                      decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5))),


                      child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Directionality(textDirection: TextDirection.ltr,
                          child: Text(PriceConverter.percentageCalculation(context,
                            flashDealController.flashDealList[index].unitPrice,
                            flashDealController.flashDealList[index].discount,
                            flashDealController.flashDealList[index].discountType,),
                            style: textRegular.copyWith(color: Theme.of(context).highlightColor,
                                fontSize: Dimensions.fontSizeSmall)),
                        )))) : const SizedBox.shrink(),

                  Positioned(top: 10, right: 15, child: FavouriteButtonWidget(backgroundColor: ColorResources.getImageBg(context),
                    productId: flashDealController.flashDealList[index].id))])));
          },
        ) : const FlashDealShimmer();
      },
    );
  }
}



