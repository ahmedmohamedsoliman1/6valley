import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banner_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';



class FashionBannersWidget extends StatelessWidget {
  const FashionBannersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Consumer<BannerController>(
          builder: (context, bannerController, child) {

            double width = MediaQuery.of(context).size.width;
            return Stack(children: [
              bannerController.mainBannerList != null ? bannerController.mainBannerList!.isNotEmpty ?
              Column(children: [
                SizedBox(height: width * 0.40, width: width,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      aspectRatio: 2/1,
                      viewportFraction: 0.8,
                      autoPlay: true,
                      enlargeFactor: .2,
                      pauseAutoPlayOnTouch: true,
                      pauseAutoPlayOnManualNavigate: true,
                      pauseAutoPlayInFiniteScroll: true,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, reason) {
                        Provider.of<BannerController>(context, listen: false).setCurrentIndex(index);
                      },
                    ),
                    itemCount: bannerController.mainBannerList!.isEmpty ? 1 : bannerController.mainBannerList?.length,
                    itemBuilder: (context, index, _) {
                      String colorString = bannerController.mainBannerList![index].backgroundColor != null?
                      '0xff${ bannerController.mainBannerList![index].backgroundColor!.substring(1, 7)}'  : '0xFF424242';

                      return ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            color: Color(int.parse(colorString))),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(width : MediaQuery.of(context).size.width/2.5,height : MediaQuery.of(context).size.width/2.5,
                              child: CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls?.bannerImageUrl}'
                                  '/${bannerController.mainBannerList![index].photo}'),
                            ),
                            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(mainAxisSize: MainAxisSize.min,children: [
                                    Text(bannerController.mainBannerList![index].title??'',maxLines: 1, overflow: TextOverflow.ellipsis,
                                        style: textBold.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeLarge)),
                                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                      child: Text(bannerController.mainBannerList![index].subTitle??'',textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,style: textRegular.copyWith(color: ColorResources.white),),),
                                    SizedBox(height: 30, width: 100,child: CustomButton(backgroundColor: ColorResources.white,
                                            textColor: Colors.black45,
                                        onTap: () {
                                          bannerController.clickBannerRedirect(context,
                                              bannerController.mainBannerList![index].resourceId,
                                              bannerController.mainBannerList![index].resourceType =='product'?
                                              bannerController.mainBannerList![index].product : null,
                                              bannerController.mainBannerList![index].resourceType);
                                        },
                                        fontSize: Dimensions.fontSizeDefault,
                                        radius: 5,
                                        buttonText: bannerController.mainBannerList![index].buttonText??'Check Now'))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                        ),
                      );
                    },
                  ),
                ),
              ],
              ) : const SizedBox() : const BannerShimmer(),

              if( bannerController.mainBannerList != null &&  bannerController.mainBannerList!.isNotEmpty)
                Positioned(bottom: 20, left: 0, right: 0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: bannerController.mainBannerList!.map((banner) {
                      int index = bannerController.mainBannerList!.indexOf(banner);
                      return index == bannerController.currentIndex ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        decoration: BoxDecoration(color:  Theme.of(context).primaryColor ,
                          borderRadius: BorderRadius.circular(10)),
                        child:  Text("${bannerController.mainBannerList!.indexOf(banner) + 1}/ ${bannerController.mainBannerList!.length}",
                          style: const TextStyle(color: Colors.white,fontSize: 12))):Container(height: 7, width: 7,
                        margin:  const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration:  BoxDecoration(color:  Theme.of(context).primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle));
                    }).toList(),
                  ),
                ),

            ],
            );
          },
        ),

        const SizedBox(height: 5),
      ],
    );
  }


}

