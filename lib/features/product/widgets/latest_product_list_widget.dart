import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product/latest_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/latest_product_shimmer.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

// import 'latest_product/stacked_swiper/swiper.dart' as ss;
import 'latest_product/stacked_swiper/card_swiper.dart';



class LatestProductListWidget extends StatelessWidget {
  const LatestProductListWidget({super.key});




  @override
  Widget build(BuildContext context) {
    SwiperController controller = SwiperController();
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.lProductList;
        var splashController = Provider.of<SplashController>(context, listen: false);

        return productList != null? productList.isNotEmpty ?
          Column(children: [
              TitleRowWidget(title: getTranslated('latest_products', context),
                  onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.latestProduct)))),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                        child: Swiper(
                            controller: controller,
                            outer: true,
                            autoplay: false,
                            allowImplicitScrolling: true,
                            autoplayDisableOnInteraction: true,
                            autoplayDelay: Duration.minutesPerHour,
                            layout: SwiperLayout.STACK,
                            itemWidth: MediaQuery.of(context).size.width * .75,
                            itemHeight: MediaQuery.of(context).size.width * 1.2,
                            itemBuilder: (BuildContext context,int index)=> LatestProductWidget(productModel :productList![index]),
                            itemCount: productList.length),
                      )
                  ),

                  Positioned.fill(
                    child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Align(alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            controller.previous();
                          },
                          child: Container(
                            height: 30, width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: GradientBoxBorder(
                                gradient: LinearGradient(colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.onPrimary]),
                                width: 2,
                              ),
                            ),
                            child: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),



              // Stack(children: [
                  // Padding(padding: EdgeInsets.only(right: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .18 : 0),
                  //   child: SizedBox(height: MediaQuery.of(context).size.width * 1,
                  //       width: MediaQuery.of(context).size.width * .85,
                  //       child: Image.asset(Images.bgLatest))),

                  // Positioned(
                  //   left: MediaQuery.of(context).size.width -390, top: MediaQuery.of(context).size.width -350,
                  //   child: Container(clipBehavior: Clip.none, width: 236, height: 293,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  //         //color: Theme.of(context).cardColor,
                  //         color: Theme.of(context).primaryColor,
                  //         boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))]),
                  //     transform: Matrix4.rotationZ(-11.1 * 3.14159 / 180),
                  //     child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  //         child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  //           borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  //               topRight: Radius.circular(10)),),
                  //             child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  //                 topRight: Radius.circular(10)),
                  //                 child: CustomImageWidget(image: '${splashController.baseUrls!.productThumbnailUrl}/${'asddfsdfsdsdfas'}')
                  //             ))),
                  //   ),
                  // ),

                  // Positioned(
                  //   left: MediaQuery.of(context).size.width -383, top: MediaQuery.of(context).size.width -350,
                  //   child: Container(clipBehavior: Clip.none, width: 236, height: 293,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  //         //color: Theme.of(context).cardColor,
                  //       color: Theme.of(context).primaryColor,
                  //     boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))]),
                  //     transform: Matrix4.rotationZ(-5.66 * 3.14159 / 180),
                  //     child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  //         child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
                  //           borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  //               topRight: Radius.circular(10)),),
                  //             child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.paddingSizeSmall),
                  //                 topRight: Radius.circular(10)),
                  //                 child: CustomImageWidget(image: '${splashController.baseUrls!.productThumbnailUrl}/${'asddfsdfsdsdfas'}')
                  //             ))),
                  //   ),
                  // ),

                  // SizedBox(height: MediaQuery.of(context).size.width,
                  //   child: Swiper(autoplay: false,
                  //     allowImplicitScrolling: true,
                  //     autoplayDisableOnInteraction: true,
                  //     autoplayDelay: Duration.minutesPerHour,
                  //     layout: SwiperLayout.TINDER,
                  //     itemWidth: MediaQuery.of(context).size.width * .75,
                  //     itemHeight: MediaQuery.of(context).size.width * 1.2,
                  //     itemBuilder: (BuildContext context,int index)=> LatestProductWidget(productModel :productList![index] ),
                  //     itemCount: productList.length)),
                  //   ],
                  // ),

            ],
          ): const SizedBox.shrink() : const LatestProductShimmer();
      },
    );
  }
}

