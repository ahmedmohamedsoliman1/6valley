import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';

class JustForYouProductCard extends StatelessWidget {
  final Product product;
  final int index;

  const JustForYouProductCard(this.product, {super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var splashController = Provider.of<SplashController>(context, listen: false);
    return Consumer<ProductController>(
      builder: (context, productController,_) {
        return InkWell(onTap: () {
            Navigator.push(context, PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, anim1, anim2) => ProductDetails(productId: product.id,slug: product.slug)));
          },
          child: Container(margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).highlightColor,
              boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme?
              [BoxShadow(color: Theme.of(context).canvasColor.withOpacity(0.2), spreadRadius: 1, blurRadius: 1)] :
              [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],),
            child: Stack(children: [

              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(height:  279,
                  decoration: BoxDecoration(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Theme.of(context).primaryColor.withOpacity(.05) :ColorResources.getIconBg(context),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),),
                  child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: CustomImageWidget(image: '${splashController.baseUrls!.productThumbnailUrl}/${product.thumbnail}',),),),


                Padding(padding: const EdgeInsets.only(top :Dimensions.paddingSizeSmall,bottom: 5, left: 5,right: 5),
                  child: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center, children: [


                        if(product.currentStock! < product.minimumOrderQuantity! && product.productType == 'physical')
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                              child: Text(getTranslated('out_of_stock', context)??'',
                                  style: textRegular.copyWith(color: const Color(0xFFF36A6A),
                                      fontSize: Dimensions.fontSizeDefault))),



                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          product.discount!= null && product.discount! > 0 ?
                          Text(PriceConverter.convertPrice(context, product.unitPrice),
                              style: titleRegular.copyWith(color: Theme.of(context).hintColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: Dimensions.fontSizeExtraSmall)) : const SizedBox.shrink(),
                          const SizedBox(width: 5),


                          Flexible(child: Text(PriceConverter.convertPrice(context,
                              product.unitPrice, discountType: product.discountType, discount: product.discount),
                                style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))))]),



                        Padding(padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(product.name ?? '', textAlign: TextAlign.center,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 2,
                                overflow: TextOverflow.ellipsis))])))]),



              product.discount! > 0 ?
              Positioned(top: 10, left: 0, child: Container(height: 20,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(color: ColorResources.getPrimary(context),
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                      bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall)),),

                child: Center(child: Text(PriceConverter.percentageCalculation(context, product.unitPrice,
                      product.discount, product.discountType),
                      style: textRegular.copyWith(color: Theme.of(context).highlightColor,
                          fontSize: Dimensions.fontSizeSmall))))) : const SizedBox.shrink(),

              Positioned(top: 10, right: 10, child: FavouriteButtonWidget(
                backgroundColor: ColorResources.getImageBg(context),
                productId: product.id,
              )),

            ]),
          ),
        );
      }
    );
  }
}
