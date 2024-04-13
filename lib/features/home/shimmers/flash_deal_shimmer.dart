import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class FlashDealShimmer extends StatelessWidget {
  const FlashDealShimmer({super.key, });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Column(children: [


        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: Container(height: ResponsiveHelper.isTab(context)? 100 : 70,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                color: ColorResources.iconBg(),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).cardColor,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                Padding(padding: const EdgeInsets.all(10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(height:  ResponsiveHelper.isTab(context)? 70 : 50,width: MediaQuery.of(context).size.width/5,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            decoration:  BoxDecoration(color: ColorResources.iconBg(),
                                borderRadius: BorderRadius.circular(10))),
                      ),

                      const SizedBox(width: 20),
                      Container(height:  ResponsiveHelper.isTab(context)? 70 : 50, width: ResponsiveHelper.isTab(context)? 70 : 50,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration:  BoxDecoration(color: ColorResources.iconBg(),
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 20),
                      Container(height:  ResponsiveHelper.isTab(context)? 70 : 50, width: ResponsiveHelper.isTab(context)? 70 : 50,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration:  BoxDecoration(color: ColorResources.iconBg(),
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 20),
                      Container(height:  ResponsiveHelper.isTab(context)? 70 : 50, width: ResponsiveHelper.isTab(context)? 70 : 50,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration:  BoxDecoration(color: ColorResources.iconBg(),
                              borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 20),
                      Container(height:  ResponsiveHelper.isTab(context)? 70 : 50, width: ResponsiveHelper.isTab(context)? 70 : 50,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration:  BoxDecoration(color: ColorResources.iconBg(),
                              borderRadius: BorderRadius.circular(10))),

                      const SizedBox(width: 20),
                      Expanded(
                        child: Container(height:  ResponsiveHelper.isTab(context)? 70 : 50,width: MediaQuery.of(context).size.width/5,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            decoration:  BoxDecoration(color: ColorResources.iconBg(),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),

        Padding(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: Dimensions.paddingSizeSmall),
          child: Container(height: ResponsiveHelper.isTab(context)? 30 : 10,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                color: ColorResources.iconBg()),
            child: Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(height: ResponsiveHelper.isTab(context)? 30 :10, padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration:  BoxDecoration(color: ColorResources.iconBg(),
                        borderRadius: BorderRadius.circular(2)))])))),

        CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: ResponsiveHelper.isTab(context)? .5 :.7,
            autoPlay: false,
            scrollPhysics: const NeverScrollableScrollPhysics(),
            enlargeFactor: 0.4,
            enlargeCenterPage: true,
            disableCenter: true,
            onPageChanged: (index, reason) {

            },
          ),
          itemCount: 2,
          itemBuilder: (context, index, _) {

            return SizedBox(height: ResponsiveHelper.isTab(context)? 350 : 500,
              child: Container(margin: const EdgeInsets.all(5),
                width: 300,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: ColorResources.iconBg(),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                child: Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
                  highlightColor: Colors.grey[100]!,
                  enabled: true,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                    Container(height: ResponsiveHelper.isTab(context)? 300 : 120, padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(color: ColorResources.iconBg(), borderRadius: BorderRadius.circular(10))),

                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(height: 10, width: 50, color: ColorResources.white),
                              const Icon(Icons.star, color: Colors.orange, size: 15)]),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            Container(height: Dimensions.paddingSizeLarge, color: Theme.of(context).cardColor),
                            const SizedBox(height: Dimensions.paddingSizeEight),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Container(height: Dimensions.paddingSizeLarge, color: Theme.of(context).cardColor),
                            ),
                          ]),
                    ),
                  ]),
                ),
              ),
            );
          },
        ),
        ],
      ),
    );
  }
}

