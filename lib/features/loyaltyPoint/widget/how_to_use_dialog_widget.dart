import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class HowToUseDialogWidget extends StatefulWidget {
  const HowToUseDialogWidget({super.key});
  @override
  State<HowToUseDialogWidget> createState() => _HowToUseDialogWidgetState();
}
class _HowToUseDialogWidgetState extends State<HowToUseDialogWidget> {


  @override
  Widget build(BuildContext context) {
    var splashController = Provider.of<SplashController>(context, listen: false);
    return Container(decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeSmall)),
        color: Theme.of(context).cardColor),

      padding: const EdgeInsets.all(Dimensions.homePagePadding),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [

          Center(child: Container(width: 40,height: 5,decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(20)))),

        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
          Text('${getTranslated('how_to_use', context)}',
              style: textBold.copyWith(color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge)),
          const SizedBox(height: Dimensions.homePagePadding),

          PointWithTextWidget(pointColor: Colors.grey, textColor: Colors.grey,
              text: getTranslated('how_to_use_point_one', context)!),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          PointWithTextWidget(pointColor: Colors.grey, textColor: Colors.grey,
              text: '${getTranslated('minimum', context)} ${splashController.configModel?.loyaltyPointMinimumPoint} '
                  '${getTranslated('how_to_use_point_two', context)!}'),
        const SizedBox(height: Dimensions.paddingSizeDefault)
        ],
      ),
    );
  }
}

class PointWithTextWidget extends StatelessWidget {
  const PointWithTextWidget({super.key, required this.text, this.pointColor, this.textColor});
  final String text;
  final Color? pointColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
          child: Container(width: 5, height: 5, decoration:  BoxDecoration(shape: BoxShape.circle, color: pointColor))),
        const SizedBox(width: Dimensions.paddingSizeSmall),
        Expanded(child: Text(text, style: textRegular.copyWith(color: textColor, fontSize: Dimensions.fontSizeDefault)))]);
  }
}
