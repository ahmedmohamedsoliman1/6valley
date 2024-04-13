import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_coupon_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_featured_product_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/shop_recommanded_product_list.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShopOverviewScreen extends StatefulWidget {
  final int sellerId;
  final ScrollController scrollController;
  const ShopOverviewScreen({super.key, required this.sellerId, required this.scrollController});

  @override
  State<ShopOverviewScreen> createState() => _ShopOverviewScreenState();
}

class _ShopOverviewScreenState extends State<ShopOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<CouponController>(
      builder: (context, couponProvider, _) {
        return  ListView(physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true, children: [

            couponProvider.couponItemModel != null? (couponProvider.couponItemModel!.coupons != null &&
                couponProvider.couponItemModel!.coupons!.isNotEmpty)?
            SizedBox(width: width, height: 280,
              child: couponProvider.couponItemModel != null? (couponProvider.couponItemModel!.coupons != null &&
                  couponProvider.couponItemModel!.coupons!.isNotEmpty)?
              Stack(fit: StackFit.expand, children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      autoPlay: couponProvider.couponItemModel!.coupons!.length > 1? true : false,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, reason) {
                        couponProvider.setCurrentIndex(index);}),
                    itemCount: couponProvider.couponItemModel!.coupons!.length,
                    itemBuilder: (context, index, _)=> SizedBox(child: ShopCouponItem(coupons: couponProvider.couponItemModel!.coupons![index],)),),

                  Positioned(bottom: 10, left: 0, right: 0,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: couponProvider.couponItemModel!.coupons!.map((banner) {
                        int index = couponProvider.couponItemModel!.coupons!.indexOf(banner);
                        return TabPageSelectorIndicator(backgroundColor: index == couponProvider.couponCurrentIndex ?
                          Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.25),
                          borderColor: index == couponProvider.couponCurrentIndex ?
                          Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.25), size: ResponsiveHelper.isTab(context) ? 7 : 5);
                      }).toList())),
                  Positioned(bottom: 10, right: 30,
                    child: Row(children: [
                        Text('${couponProvider.couponCurrentIndex+1}',
                          style: textMedium.copyWith(color: Theme.of(context).primaryColor),),
                        Text('/${couponProvider.couponItemModel!.coupons!.length}',
                          style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                      ]))]) :

              Center(child: Text('${getTranslated('no_coupon_available', context)}')) :
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                enabled: couponProvider.couponItemModel!.coupons == null,
                child: Container(margin: const EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: ColorResources.white))),
            ): const SizedBox() : const Center(child: SizedBox()),


          Consumer<SellerProductController>(
            builder: (context, productController, _) {
              return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, 0),
                child: TitleRowWidget(title: productController.sellerWiseFeaturedProduct != null ?
                (productController.sellerWiseFeaturedProduct!.products != null &&
                    productController.sellerWiseFeaturedProduct!.products!.isNotEmpty)?
                getTranslated('featured_products', context) : getTranslated('recommanded_products', context) : ''));
            }),


            Consumer<SellerProductController>(
              builder: (context, productController, _) {
                return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, 0),
                  child: ShopFeaturedProductViewList(scrollController: widget.scrollController, sellerId: widget.sellerId));
              }
            ),


            Consumer<SellerProductController>(
              builder: (context, productController, _) {
                return (productController.sellerWiseFeaturedProduct != null &&
                    productController.sellerWiseFeaturedProduct!.products != null &&
                    productController.sellerWiseFeaturedProduct!.products!.isEmpty)?
                Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, 0),
                  child: ShopRecommandedProductViewList(scrollController: widget.scrollController,
                      sellerId: widget.sellerId),): const SizedBox();
              })]);
      }
    );
  }
}
