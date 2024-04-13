import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/screens/review_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/widgets/review_widget.dart';
import 'package:provider/provider.dart';

class ReviewSection extends StatelessWidget {
  final ProductDetailsController details;
  const ReviewSection({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewController>(
      builder: (context, reviewController, _) {
        return Container(width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          color:  Theme.of(context).cardColor,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

            Text(getTranslated('customer_reviews', context)!,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
            const SizedBox(height: Dimensions.paddingSizeDefault,),
            Container(width: 230,height: 30,
              decoration: BoxDecoration(color: ColorResources.visitShop(context),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),),


              child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center, children: [
                  RatingBar(rating: double.parse(details.productDetailsModel!.averageReview!), size: 18,),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Text('${double.parse(details.productDetailsModel!.averageReview!).toStringAsFixed(1)} ${getTranslated('out_of_5', context)}',
                      style: textRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                      Theme.of(context).hintColor : Colors.black)),])),

            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text('${getTranslated('total', context)} ${reviewController.reviewList != null ?
            reviewController.reviewList!.length : 0} ${getTranslated('reviews', context)}'),



            reviewController.reviewList != null ? reviewController.reviewList!.isNotEmpty ?
            ReviewWidget(reviewModel: reviewController.reviewList![0])
                : const SizedBox() : const ReviewShimmer(),
            reviewController.reviewList != null ? reviewController.reviewList!.length > 1 ?
            ReviewWidget(reviewModel: reviewController.reviewList![1])
                : const SizedBox() : const ReviewShimmer(),
            reviewController.reviewList != null ? reviewController.reviewList!.length > 2 ?
            ReviewWidget(reviewModel: reviewController.reviewList![2])
                : const SizedBox() : const ReviewShimmer(),

            InkWell(onTap: () {
              if(reviewController.reviewList != null)
              {Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  ReviewScreen(reviewList: reviewController.reviewList)));}},
                child: reviewController.reviewList != null && reviewController.reviewList!.length > 3?
                Text(getTranslated('view_more', context)!, style: titilliumRegular.copyWith(color: Theme.of(context).primaryColor)):
                const SizedBox())
          ]),
        );
      }
    );
  }
}
