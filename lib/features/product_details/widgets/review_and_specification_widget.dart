import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ReviewAndSpecificationSectionWidget extends StatelessWidget {
  const ReviewAndSpecificationSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsController>(
      builder: (context, productDetailsController, _) {
        return Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [



            InkWell(onTap: ()=> productDetailsController.selectReviewSection(false),
                child: Column(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        color: !productDetailsController.isReviewSelected? Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor.withOpacity(.25) :
                        Theme.of(context).primaryColor.withOpacity(.05):Colors.transparent),
                    child: Text('${getTranslated('specification', context)}',
                      style: textRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                      Theme.of(context).hintColor : Theme.of(context).primaryColor),),),
                  if(!productDetailsController.isReviewSelected)
                    Container(width: 60, height: 3,color: Theme.of(context).primaryColor,)])),
            const SizedBox(width: Dimensions.paddingSizeDefault),



            InkWell(onTap: ()=> productDetailsController.selectReviewSection(true),
              child: Stack(clipBehavior: Clip.none, children: [
                Column(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        color:  productDetailsController.isReviewSelected? Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor.withOpacity(.25) :
                        Theme.of(context).primaryColor.withOpacity(.05): Colors.transparent),
                    child: Text('${getTranslated('reviews', context)}', style: textRegular.copyWith(
                        color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                        Theme.of(context).hintColor : Theme.of(context).primaryColor),),),


                  if(productDetailsController.isReviewSelected)
                    Container(width: 60, height: 3,color: Theme.of(context).primaryColor)]),
                Positioned(top: -10,right: -10, child: Align(alignment: Alignment.topRight,
                    child: Consumer<ReviewController>(builder: (context, reviewController,_) {
                      return Center(child: Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                          color: Theme.of(context).primaryColor),
                          child: Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeExtraSmall,
                              horizontal: Dimensions.paddingSizeSmall),
                            child: Text('${reviewController.reviewList != null ? reviewController.reviewList!.length : 0}',
                              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white),),
                          )));})))
              ],
              ),
            )
          ],),
        );
      }
    );
  }
}
