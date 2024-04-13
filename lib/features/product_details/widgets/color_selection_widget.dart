

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class ColorSelectionWidget extends StatefulWidget {
  final ProductDetailsModel product;
  final ProductDetailsController detailsController;
  const ColorSelectionWidget({super.key, required this.product, required this.detailsController});

  @override
  State<ColorSelectionWidget> createState() => _ColorSelectionWidgetState();
}

class _ColorSelectionWidgetState extends State<ColorSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
        child: Row( children: [
          Text('${getTranslated('select_variant', context)} : ',
              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Expanded(child: SizedBox(height: 40,
              child: ListView.builder(
                itemCount: widget.product.colors!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  String colorString = '0xff${widget.product.colors![index].code!.substring(1, 7)}';
                  return Padding(padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Center(child: InkWell(onTap: () {
                        widget.detailsController.setCartVariantIndex(widget.product.minimumOrderQty, index, context);},
                          child: Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight),
                              border: widget.detailsController.variantIndex == index ? Border.all(width: 2,
                                  color: Theme.of(context).primaryColor.withOpacity(.5)) : null),
                              child: Padding(padding: const EdgeInsets.all(2),
                                  child: Container(height: Dimensions.topSpace, width: Dimensions.topSpace,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(color: Color(int.parse(colorString)),
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall))))))
                      ));
                },)
          )
          )
        ])
    );
  }
}
