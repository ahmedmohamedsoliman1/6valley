import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';



class SingleBannersWidget extends StatelessWidget {
  final BannerModel? bannerModel;
  final double? height;
  final bool noRadius;
  const SingleBannersWidget({super.key, this.bannerModel, this.height,  this.noRadius = false});


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<BannerController>(
        builder: (context, footerBannerProvider, child) {
          return InkWell(onTap: () {
              footerBannerProvider.clickBannerRedirect(context,
                  bannerModel?.resourceId,
                  bannerModel?.resourceType =='product'?
                  bannerModel?.product : null,
                  bannerModel?.resourceType);
            },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(width: MediaQuery.of(context).size.width,
                height: height?? MediaQuery.of(context).size.width/2.2,
                decoration:  BoxDecoration(borderRadius: BorderRadius.all(noRadius?
                const Radius.circular(0): const Radius.circular(5))),
                child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(noRadius?0:5)),
                  child: CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls?.bannerImageUrl}'
                      '/${bannerModel?.photo}')))));
    },
    ),],
    );
  }
}

