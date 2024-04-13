import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/domain/models/coupon_item_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class CouponItemWidget extends StatefulWidget {
  final Coupons coupons;
  final bool fromCheckout;
  const CouponItemWidget({super.key, required this.coupons,  this.fromCheckout = false});

  @override
  State<CouponItemWidget> createState() => _CouponItemWidgetState();
}

class _CouponItemWidgetState extends State<CouponItemWidget> {
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {

    return Padding(padding: widget.fromCheckout? const EdgeInsets.fromLTRB(0,Dimensions.paddingSizeSmall, 0,0):
     EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall, Dimensions.fontSizeDefault,0),
      child: Stack(clipBehavior: Clip.none, children: [
          ClipRRect(clipBehavior: Clip.none,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  boxShadow:  [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.12),
                      spreadRadius: 1,blurRadius: 1, offset: const Offset(1,1))],
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeSmall),
                child: Row(children: [
                    Expanded(flex: 4, child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                          SizedBox(width: 30,child: Image.asset(color : widget.coupons.discountType == 'percentage'?
                          Theme.of(context).primaryColor: null,
                              widget.coupons.couponType == 'free_delivery'?
                              Images.freeCoupon :widget.coupons.discountType == 'percentage'?
                              Images.offerIcon :Images.firstOrder)),

                          widget.coupons.couponType == 'free_delivery'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('free_delivery', context)}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                  Theme.of(context).hintColor : Theme.of(context).primaryColor),),):

                          widget.coupons.discountType == 'percentage'?
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${widget.coupons.discount} ${'% ${getTranslated('off', context)}'}',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                  Theme.of(context).hintColor : Theme.of(context).primaryColor),),):

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text(PriceConverter.convertPrice(context, widget.coupons.discount),
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                  Theme.of(context).hintColor : Theme.of(context).primaryColor),),),
                          Text(widget.coupons.seller != null? widget.coupons.seller?.shop?.name??'' : widget.coupons.sellerId == 0?
                          '${getTranslated('on_all_shop', context)}': AppConstants.appName,
                            style: textRegular.copyWith(color: Theme.of(context).hintColor))]))),

                    Expanded(flex: 6,
                      child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                        child: Column(children: [
                         DottedBorder(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                         Theme.of(context).hintColor.withOpacity(.75) : Theme.of(context).primaryColor,
                             borderType: BorderType.RRect,
                             radius: const Radius.circular(5),
                             child: Container(width: 120,
                                 alignment: Alignment.center,
                                 padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                 decoration: BoxDecoration(
                                 color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                 Theme.of(context).hintColor.withOpacity(.15) :
                                 Theme.of(context).primaryColor.withOpacity(.1)),
                                 child: Text(widget.coupons.code??'',
                                     style: titleRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                     Theme.of(context).hintColor :Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)))),


                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('valid_till', context)}'
                                ' ${DateConverter.estimatedDateYear(DateTime.parse(widget.coupons.planExpireDate!))}',
                              style: textRegular.copyWith())),

                          Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeSmall),
                            child: Text('${getTranslated('available_from', context)} '
                                '${PriceConverter.convertPrice(context, widget.coupons.minPurchase)}',
                                textAlign: TextAlign.center,
                                style: titleRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).hintColor)),)
                        ],),
                      ),
                    ),
                  ],
                ),
              ),),
          ),

           Positioned(top: 0,right: 0, child: JustTheTooltip(
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


          Positioned(top: 0,left: MediaQuery.of(context).size.width/2.68, bottom: 0,
              child: DottedLine(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                lineLength: double.infinity,
                lineThickness: 2.0,
                dashLength: 4.0,
                dashColor: Theme.of(context).hintColor,
                dashRadius: 0.0,
                dashGapLength: 6.0,
                dashGapColor: Colors.transparent,
                dashGapRadius: 0.0)),

          Positioned(top: -20,left: MediaQuery.of(context).size.width/3,
              child: Container(width: 35, height : 35,decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(100)),)),



          Positioned(bottom: -20,left: MediaQuery.of(context).size.width/3,
              child: Container(width: 35, height : 35,decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(100))))]),
    );
  }
}