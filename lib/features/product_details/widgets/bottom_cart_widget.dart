import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/cart_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class BottomCartWidget extends StatefulWidget {
  final ProductDetailsModel? product;
  const BottomCartWidget({super.key, required this.product});

  @override
  State<BottomCartWidget> createState() => _BottomCartWidgetState();
}

class _BottomCartWidgetState extends State<BottomCartWidget> {
  bool vacationIsOn = false;
  bool temporaryClose = false;

  @override
  void initState() {

    super.initState();

    if(widget.product != null && widget.product!.seller != null && widget.product!.seller!.shop!.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.product!.seller!.shop!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.product!.seller!.shop!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && widget.product!.seller!.shop!.vacationStatus! && startDate <= 0){
        vacationIsOn = true;
      }

      else{
        vacationIsOn = false;
      }
    }

    if(widget.product != null && widget.product!.seller != null && widget.product!.seller!.shop!.temporaryClose!){
      temporaryClose = true;
    }else{
      temporaryClose = false;
    }


  }


  @override
  Widget build(BuildContext context) {




    return Container(height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: .5, spreadRadius: .1)]),
      child: Row(children: [
        Expanded(flex: 3, child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Stack(children: [
            GestureDetector(onTap: ()  =>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const CartScreen())),
                child: Image.asset(Images.cartArrowDownImage, color: ColorResources.getPrimary(context))),
            Positioned(top: 0, right: 10,
              child: Consumer<CartController>(builder: (context, cart, child) {
                return Container(height: ResponsiveHelper.isTab(context)? 25 : 17, width: ResponsiveHelper.isTab(context)? 25 :17,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorResources.getPrimary(context)),
                  child: Center(
                    child: Text(cart.cartList.length.toString(),
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                          color:Theme.of(context).highlightColor)),
                  ),
                );}))]))),

        Expanded(flex: 11, child: InkWell(onTap: () {
            if(vacationIsOn || temporaryClose ){
              showCustomSnackBar(getTranslated('this_shop_is_close_now', context), context, isToaster: true);
            }else{
              showModalBottomSheet(context: context, isScrollControlled: true,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0),
                  builder: (con) => CartBottomSheetWidget(product: widget.product, callback: (){
                    showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                  },));
            }},
          child: Container(height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor),
            child: Text(getTranslated('add_to_cart', context)!,
              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Theme.of(context).hintColor : Theme.of(context).highlightColor),),
          ),
        )),
      ]),
    );
  }
}
