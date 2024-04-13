import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:provider/provider.dart';


class ProductTitleWidget extends StatelessWidget {
  final ProductDetailsModel? productModel;
  final String? averageRatting;
  const ProductTitleWidget({super.key, required this.productModel, this.averageRatting});

  @override
  Widget build(BuildContext context) {

    double? startingPrice = 0;
    double? endingPrice;
    if(productModel != null && productModel!.variation != null && productModel!.variation!.isNotEmpty) {
      List<double?> priceList = [];
      for (var variation in productModel!.variation!) {
        priceList.add(variation.price);
      }
      priceList.sort((a, b) => a!.compareTo(b!));
      startingPrice = priceList[0];
      if(priceList[0]! < priceList[priceList.length-1]!) {
        endingPrice = priceList[priceList.length-1];
      }
    }else {
      startingPrice = productModel!.unitPrice;
    }

    return productModel != null? Container(
      padding: const EdgeInsets.symmetric(horizontal : Dimensions.homePagePadding),
      child: Consumer<ProductDetailsController>(
        builder: (context, details, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(productModel!.name ?? '',
                style: titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 2),
            const SizedBox(height: Dimensions.paddingSizeDefault),


            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Row(children: [


                Text('${startingPrice != null ?PriceConverter.convertPrice(context, startingPrice,
                    discount: productModel!.discount, discountType: productModel!.discountType):''}'
                    '${endingPrice !=null ? ' - ${PriceConverter.convertPrice(context, endingPrice,
                    discount: productModel!.discount, discountType: productModel!.discountType)}' : ''}',
                  style: titilliumBold.copyWith(color: ColorResources.getPrimary(context),
                      fontSize: Dimensions.fontSizeLarge)),

                productModel!.discount != null && productModel!.discount! > 0 ?
                Flexible(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: Text('${PriceConverter.convertPrice(context, startingPrice)}'
                        '${endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, endingPrice)}' : ''}',
                      style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                          decoration: TextDecoration.lineThrough)))):const SizedBox(),

                  if(productModel != null && productModel!.discount != null && productModel!.discount! > 0)
                  Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(.20),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                    child: Text(PriceConverter.percentageCalculation(context, productModel!.unitPrice,
                        productModel!.discount, productModel!.discountType),
                      style: textRegular.copyWith(color:Theme.of(context).colorScheme.error,
                          fontSize: Dimensions.fontSizeLarge)))])),


            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Row(children: [
                 RatingBar(rating: productModel!.reviews != null ? productModel!.reviews!.isNotEmpty ?
                 double.parse(averageRatting!) : 0.0 : 0.0),
                Text('(${productModel?.reviewsCount})')])),


            Consumer<ReviewController>(
              builder: (context, reviewController, _) {
                return Row(children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${reviewController.reviewList != null ? reviewController.reviewList!.length : 0} ',
                        style: textMedium.copyWith(
                        color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor : Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeDefault)),
                TextSpan(text: '${getTranslated('reviews', context)} | ',
                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,))])),


                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${details.orderCount} ', style: textMedium.copyWith(
                        color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor : Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeDefault)),
                    TextSpan(text: '${getTranslated('orders', context)} | ',
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,))])),

                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${details.wishCount} ', style: textMedium.copyWith(
                        color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor : Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeDefault)),
                    TextSpan(text: '${getTranslated('wish_listed', context)}',
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,))])),
                ]);}),
            const SizedBox(height: Dimensions.paddingSizeSmall),



            productModel!.colors != null && productModel!.colors!.isNotEmpty ?
            Row( children: [
              Text('${getTranslated('select_variant', context)} : ',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              Expanded(child: SizedBox(height: 40,
                  child: ListView.builder(
                    itemCount: productModel!.colors!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context, index) {
                      String colorString = '0xff${productModel!.colors![index].code!.substring(1, 7)}';
                      return Center(child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: Container(height: 20, width: 20,
                              padding: const EdgeInsets.all( Dimensions.paddingSizeExtraSmall),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Color(int.parse(colorString)),
                                borderRadius: BorderRadius.circular(30))))));
                      },))),
            ]) : const SizedBox(),
          productModel!.colors != null &&  productModel!.colors!.isNotEmpty ?
          const SizedBox(height: Dimensions.paddingSizeSmall) : const SizedBox(),




            productModel!.choiceOptions!=null && productModel!.choiceOptions!.isNotEmpty?
            ListView.builder(
              shrinkWrap: true,
              itemCount: productModel!.choiceOptions!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${getTranslated('available', context)} ${productModel!.choiceOptions![index].title} :',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(child: Padding(padding: const EdgeInsets.all(2.0),
                      child: SizedBox(height: 40,
                        child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: productModel!.choiceOptions![index].options!.length,
                          itemBuilder: (context, i) {
                            return Center(child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                child: Text(productModel!.choiceOptions![index].options![i].trim(), maxLines: 1,
                                    overflow: TextOverflow.ellipsis, style: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                        color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                        const Color(0xFFFFFFFF) : Theme.of(context).primaryColor))));
                          })))),
                ]);
              },
            ):const SizedBox(),
          ]);
        },
      ),
    ):const SizedBox();
  }
}
