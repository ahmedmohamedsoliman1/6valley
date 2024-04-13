

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class CartQuantityButton extends StatelessWidget {
  final CartModel? cartModel;
  final bool isIncrement;
  final int? quantity;
  final int index;
  final int? maxQty;
  final int? minimumOrderQuantity;
  final bool? digitalProduct;
  const CartQuantityButton({super.key, required this.isIncrement, required this.quantity, required this.index,
    required this.maxQty,required this.cartModel, this.minimumOrderQuantity, this.digitalProduct});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
        builder: (context, cartProvider,_) {
          return InkWell(
            onTap: () {
              if (!isIncrement && quantity! > minimumOrderQuantity!) {
                cartProvider.updateCartProductQuantity(cartModel!.id, cartModel!.quantity!-1, context, false, index);
              } else if ((isIncrement && quantity! < maxQty!) || (isIncrement && digitalProduct!)) {
                cartProvider.updateCartProductQuantity(cartModel!.id, cartModel!.quantity!+1, context, true, index);
              }else if(isIncrement && quantity! == maxQty!){
                showCustomSnackBar(getTranslated('out_of_stock', context), context);
              }else{
                cartProvider.removeFromCartAPI(cartModel!.id, index);
              }
            },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(isIncrement ? CupertinoIcons.add : quantity! == minimumOrderQuantity!?
              CupertinoIcons.delete_solid : CupertinoIcons.minus,
                  color: Colors.red, size:  15),
            ),
          );
        }
    );
  }
}