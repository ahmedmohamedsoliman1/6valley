import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';

class FeaturedDealWidget extends StatelessWidget {
  final Product product;
  final bool isHomePage;
  const FeaturedDealWidget({super.key, required this.product, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (context, anim1, anim2) => ProductDetails(productId: product.id,slug: product.slug))),

      child: Container(margin: const EdgeInsets.only(top: 5, bottom: 5),
        width: isHomePage ? 310 : null, height: 135,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).highlightColor,
            boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme ? null :
            [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))]),

        child: Stack(children: [
          Row( children: [

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Container(height: ResponsiveHelper.isTab(context)? 300 : 120, width: ResponsiveHelper.isTab(context)? 300 : 120, decoration: BoxDecoration(
                  color: ColorResources.getIconBg(context),
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: CustomImageWidget(image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.productThumbnailUrl}'
                      '/${product.thumbnail}',height: 120,width: 120)))),

            Expanded(flex: 6,
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start, children: [

                  if(product.currentStock! < product.minimumOrderQuantity! && product.productType == 'physical')
                    Text(getTranslated('out_of_stock', context)??'',
                        style: textRegular.copyWith(color: const Color(0xFFF36A6A))),

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(children: [

                      Icon(Icons.star_rate_rounded, color: Provider.of<ThemeController>(context).darkTheme ?
                      Colors.white : Colors.orange, size: 15),

                      Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(product.rating != null && product.rating!.isNotEmpty?
                        double.parse(product.rating![0].average!).toStringAsFixed(1) : '0.0',
                          style: textRegular.copyWith(color: Provider.of<ThemeController>(context).darkTheme ?
                          Colors.white : Colors.orange, fontSize: Dimensions.fontSizeSmall),),),

                      Text('(${product.reviewCount.toString()})', style: textRegular.copyWith(color: Theme.of(context).hintColor,
                            fontSize: Dimensions.fontSizeSmall))]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),


                    Text(product.name!, style: textRegular.copyWith(height: 1.3,fontSize: Dimensions.fontSizeSmall),
                      maxLines: 1, overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    FittedBox(child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(product.discount! > 0 ? PriceConverter.convertPrice(context, product.unitPrice!.toDouble()) : '',
                          style: textRegular.copyWith(color: Theme.of(context).hintColor,
                            decoration: TextDecoration.lineThrough, fontSize: Dimensions.fontSizeSmall)),

                        product.discount! > 0? const SizedBox(width: Dimensions.paddingSizeDefault): const SizedBox(),
                        Text(PriceConverter.convertPrice(context, product.unitPrice!.toDouble(),
                            discountType: product.discountType, discount: product.discount!.toDouble()),
                          style: textBold.copyWith(color: ColorResources.getPrimary(context),fontSize: Dimensions.fontSizeDefault),),
                          ]))])))]),


          product.discount! > 0 ? Positioned(top: 20, left: 10,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
              child: Directionality(textDirection: TextDirection.ltr,
                child: Text(PriceConverter.percentageCalculation(
                    context, product.unitPrice!.toDouble(), product.discount!.toDouble(), product.discountType),
                  style: textRegular.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.fontSizeSmall)),
              )),
          ) : const SizedBox.shrink(),

          Positioned(top: 10, right: 10, child: FavouriteButtonWidget(
            backgroundColor: ColorResources.getImageBg(context), productId: product.id)),
        ]),
      ),
    );
  }
}
