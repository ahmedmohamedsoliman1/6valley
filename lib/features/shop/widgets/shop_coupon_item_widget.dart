import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/domain/models/coupon_item_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class ShopCouponItem extends StatefulWidget {
  final Coupons coupons;
  const ShopCouponItem({super.key, required this.coupons});

  @override
  State<ShopCouponItem> createState() => _ShopCouponItemState();
}

class _ShopCouponItemState extends State<ShopCouponItem> {
  final tooltipController = JustTheController();
  @override
  Widget build(BuildContext context) {
    return Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall, Dimensions.fontSizeDefault,0),
      child: Stack(clipBehavior: Clip.none, children: [
          ClipRRect(clipBehavior: Clip.none,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme ? null :
                  [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.12), spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))],
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125))),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start, children: [
                    Expanded(flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(width: 30,child: Image.asset(widget.coupons.couponType == 'free_delivery'?
                          Images.freeCoupon :widget.coupons.discountType == 'percentage'? Images.offerIcon :Images.firstOrder)),

                          widget.coupons.couponType == 'free_delivery'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('free_delivery', context)}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),),
                          ):

                          widget.coupons.discountType == 'percentage'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${widget.coupons.discount} ${'% ${getTranslated('off', context)}'}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),)):
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${PriceConverter.convertPrice(context, widget.coupons.discount)} ${getTranslated('OFF', context)}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor),),
                          ),
                          Text(getTranslated(widget.coupons.couponType, context)??'',
                              style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall))
                        ]))),

                    Expanded(flex: 6,
                      child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [



                          Container(width: 200,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
                                  Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeExtraSmall),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  border: Border.all(color: Theme.of(context).primaryColor)),
                              child: Text(widget.coupons.code??'', style: titleRegular.copyWith(color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeLarge))),


                          Container(transform: Matrix4.translationValues(0, ResponsiveHelper.isTab(context)? -80 : -70, 0),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                color: Theme.of(context).primaryColor),
                            child: Text('${getTranslated('coupon_code', context)}', style: textMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),


                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('available_till', context)} '
                                '${DateConverter.estimatedDate(DateTime.parse(widget.coupons.expireDatePlanText!))}',
                                style: textRegular.copyWith())),

                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('minimum_purchase_amount', context)} ${PriceConverter.convertPrice(context, widget.coupons.minPurchase)}',
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          )])))])))),





        Positioned(top: 10,right: 10, child: JustTheTooltip(
          backgroundColor: Colors.black87,
          controller: tooltipController,
          preferredDirection: AxisDirection.down,
          tailLength: 10,
          tailBaseWidth: 20,
          content: Container(width: 90,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(getTranslated('copied', context)!,
                  style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
          child: InkWell(
              onTap: () async {
                tooltipController.showTooltip();
                await Clipboard.setData(ClipboardData(text: widget.coupons.code??''));
              },
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Icon(Icons.copy_rounded,
                      color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                      Theme.of(context).hintColor : Theme.of(context).primaryColor.withOpacity(.65)))),
        )),

          // Positioned(top: 10,right: 10, child: InkWell(
          //     onTap: () async {
          //       await Clipboard.setData(ClipboardData(text: widget.coupons.code??''));
          //       showCustomSnackBar(getTranslated('coupon_code_copied_successfully', Get.context!), Get.context!, isError: false);
          //     },
          //     child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          //         child: Icon(Icons.copy_rounded, color: Theme.of(context).primaryColor.withOpacity(.65)))))
        ],
      ),
    );
  }
}