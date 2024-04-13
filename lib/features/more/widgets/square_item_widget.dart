import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SquareButtonWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;
  final bool isWallet;
  final double? balance;
  final bool isLoyalty;
  final String? subTitle;

  const SquareButtonWidget({super.key, required this.image,
    required this.title, required this.navigateTo, required this.count,
    required this.hasCount, this.isWallet = false, this.balance, this.subTitle,
    this.isLoyalty = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(8.0),
          child: Container(width: 120, height: 90,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: Provider.of<ThemeController>(context).darkTheme ?
                Theme.of(context).primaryColor.withOpacity(.30) : Theme.of(context).primaryColor),
            child: Stack(children: [
              Positioned(top: -80,left: -10,right: -10,
                  child: Container(height: 120, decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withOpacity(.07), width: 15),
                      borderRadius: BorderRadius.circular(100)))),


              isWallet?
              Padding(padding: const EdgeInsets.all(8.0),
                child: SizedBox(width: 30, height: 30,child: Image.asset(image, color: Colors.white)),
              ):

              Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Image.asset(image, color: ColorResources.white))),

              if(isWallet)
                Positioned(right: 10,bottom: 10,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(getTranslated(subTitle, context)??'', style: textRegular.copyWith(color: Colors.white),),
                      isLoyalty? Text(balance != null? balance!.toStringAsFixed(0) : '0',
                          style: textMedium.copyWith(color: Colors.white)):
                      Text(balance != null? PriceConverter.convertPrice(context, balance):'0',
                          style: textMedium.copyWith(color: Colors.white))])),

              hasCount?
              Positioned(top: 5, right: 5,
                child: Consumer<CartController>(builder: (context, cart, child) {
                  return CircleAvatar(radius: 10, backgroundColor: ColorResources.red,
                      child: Text(count.toString(), style: titilliumSemiBold.copyWith(color: Theme.of(context).cardColor,
                          fontSize: Dimensions.fontSizeExtraSmall)));
                })):const SizedBox(),
            ])),
        ),
        Text(title??'', maxLines: 1,overflow: TextOverflow.clip,
            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                color: Theme.of(context).textTheme.bodyLarge?.color)),
      ]),
    );
  }
}