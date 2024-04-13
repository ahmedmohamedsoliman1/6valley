import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:provider/provider.dart';

class FindWhatYouNeedView extends StatelessWidget {
  const FindWhatYouNeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<ProductController>(
      builder: (context, productController, _) {
        return productController.findWhatYouNeedModel != null ? (productController.findWhatYouNeedModel!.findWhatYouNeed != null &&
            productController.findWhatYouNeedModel!.findWhatYouNeed!.isNotEmpty)?
        SizedBox(width : MediaQuery.of(context).size.width, height: 120,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              padEnds: false,
              viewportFraction: .80,
              autoPlay: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
              },
            ),
              itemCount: productController.findWhatYouNeedModel!.findWhatYouNeed!.length,

              itemBuilder: (context, index, _) {
                return InkWell(onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: productController.findWhatYouNeedModel!.findWhatYouNeed![index].id.toString(),
                      name: productController.findWhatYouNeedModel!.findWhatYouNeed![index].name,
                    )));
                  },
                  child: Padding(padding: EdgeInsets.only(left : Provider.of<LocalizationController>(context, listen: false).isLtr ?
                  Dimensions.paddingSizeDefault : 0,
                        right: index + 1 == productController.findWhatYouNeedModel!.findWhatYouNeed!.length?
                        Dimensions.paddingSizeDefault : Provider.of<LocalizationController>(context, listen: false).isLtr ?
                        0 : Dimensions.paddingSizeDefault),
                    child: Container(width: 305, height: 140,

                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.125),
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusDefault),
                          bottomLeft: Radius.circular(Dimensions.radiusDefault), bottomRight: Radius.circular(Dimensions.radiusDefault))),

                      child: Stack(children: [
                        Positioned(top: 0, right: 0,
                          child: Container(height: 23, width: 24,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(Dimensions.radiusSmall)),
                              gradient: LinearGradient(stops: const [.5, .5], begin: Alignment.bottomLeft, end: Alignment.topRight,
                                colors: [Theme.of(context).primaryColor, Provider.of<ThemeController>(context).darkTheme ?
                                Colors.black : Colors.white],
                              ),
                            ),
                          ),
                        ),

                         Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${productController.findWhatYouNeedModel!.findWhatYouNeed![index].name}',
                                style: textRegular.copyWith(color: Theme.of(context).primaryColor,
                                    fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600)),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text('${productController.findWhatYouNeedModel!.findWhatYouNeed![index].productCount} ${getTranslated('products', context)}',
                                  style: textRegular.copyWith(color:  Theme.of(context).hintColor)),
                              const SizedBox(height: Dimensions.paddingSizeSmall),


                              Row(children: [
                                  SizedBox(height: 70, width: 250,
                                    child: ListView.builder(
                                      itemCount: productController.findWhatYouNeedModel!.findWhatYouNeed![index].childes!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, subIndex) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                                              isBrand: false,
                                              id: productController.findWhatYouNeedModel!.findWhatYouNeed![index].childes![subIndex].id.toString(),
                                              name: productController.findWhatYouNeedModel!.findWhatYouNeed![index].childes![subIndex].name,
                                            )));
                                          },
                                          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                child: Container(width: ResponsiveHelper.isTab(context)? 50: MediaQuery.of(context).size.width/10,
                                                  height: ResponsiveHelper.isTab(context)? 40: MediaQuery.of(context).size.width/10,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                                    border: Border.all(width: 0.50, color: Theme.of(context).primaryColor.withOpacity(0.125)),),
                                                  child: CustomImageWidget(fit: BoxFit.cover,
                                                    image: '${Provider.of<SplashController>(context, listen: false).configModel?.baseUrls?.categoryImageUrl}/${productController.findWhatYouNeedModel!.findWhatYouNeed![index].childes?[subIndex].icon}',),),
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                               SizedBox(width: MediaQuery.of(context).size.width/7,
                                                child: Text('${productController.findWhatYouNeedModel!.findWhatYouNeed![index].childes?[subIndex].name}', maxLines: 1,overflow: TextOverflow.ellipsis,
                                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                                      color: Theme.of(context).hintColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),


                        Positioned(right: 10, top: 80, child: Icon(Icons.arrow_forward_outlined,
                            color: Theme.of(context).primaryColor, size: 26)),

                      ],
                      ),
                    ),
                  ),
                );

              },
          ),
        ):const SizedBox(): const FindWhatYouNeedShimmer();
      }
    );
  }
}
