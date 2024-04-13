import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/cart_page_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/widgets/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/screens/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/widgets/shipping_method_bottom_sheet_widget.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  const CartScreen({super.key, this.fromCheckout = false, this.sellerId = 1});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  Future<void> _loadData() async{
    await Provider.of<CartController>(Get.context!, listen: false).getCartData(Get.context!);
     Provider.of<CartController>(Get.context!, listen: false).setCartData();
      if( Provider.of<SplashController>(Get.context!,listen: false).configModel!.shippingMethod != 'sellerwise_shipping'){
        Provider.of<ShippingController>(Get.context!, listen: false).getAdminShippingMethodList(Get.context!);
      }
  }

  Color _currentColor = Theme.of(Get.context!).cardColor; // Initial color
  final Duration duration = const Duration(milliseconds: 500);
  void changeColor() {
    setState(() {
      _currentColor = (_currentColor == Theme.of(Get.context!).cardColor) ? Colors.grey.withOpacity(.15) : Theme.of(Get.context!).cardColor;
      Future.delayed(const Duration(milliseconds: 500)).then((value){
        reBackColor();
      });
    });
  }

  void reBackColor() {
    setState(() {
      _currentColor = (_currentColor == Theme.of(Get.context!).cardColor) ? Colors.grey.withOpacity(.15) : Theme.of(Get.context!).cardColor;
    });
  }


  @override
  void initState() {
    _loadData();
    super.initState();
  }
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashController>(
      builder: (context, configProvider,_) {
        return Consumer<ShippingController>(
          builder: (context, shippingController,_) {
            return Consumer<CartController>(builder: (context, cart, child) {
              double amount = 0.0;
              double shippingAmount = 0.0;
              double discount = 0.0;
              double tax = 0.0;
              int totalQuantity = 0;
              int totalPhysical = 0;
              bool onlyDigital= true;
              List<CartModel> cartList = [];
              cartList.addAll(cart.cartList);

              for(CartModel cart in cartList) {

                if(cart.productType == "physical"){
                  onlyDigital = false;
                }
              }

              List<String?> orderTypeShipping = [];
              List<String?> sellerList = [];
              List<List<String>> productType = [];
              List<CartModel> sellerGroupList = [];
              List<List<CartModel>> cartProductList = [];
              List<List<int>> cartProductIndexList = [];
              for(CartModel cart in cartList) {
                if(!sellerList.contains(cart.cartGroupId)) {
                  sellerList.add(cart.cartGroupId);
                  sellerGroupList.add(cart);
                }
              }



              for(String? seller in sellerList) {
                List<CartModel> cartLists = [];
                List<int> indexList = [];
                List<String> productTypeList = [];
                for(CartModel cart in cartList) {
                  if(seller == cart.cartGroupId) {
                    cartLists.add(cart);
                    indexList.add(cartList.indexOf(cart));
                    productTypeList.add(cart.productType!);
                  }
                }
                cartProductList.add(cartLists);
                productType.add(productTypeList);
                cartProductIndexList.add(indexList);
              }

              double freeDeliveryAmountDiscount = 0;
              for (var seller in sellerGroupList) {
                if(seller.freeDeliveryOrderAmount?.status == 1){
                  freeDeliveryAmountDiscount += seller.freeDeliveryOrderAmount!.shippingCostSaved!;
                }
                if(seller.shippingType == 'order_wise'){
                  orderTypeShipping.add(seller.shippingType);
                }
              }


              if(cart.getData && configProvider.configModel!.shippingMethod =='sellerwise_shipping') {
                shippingController.getShippingMethod(context, cartProductList);
              }

              for(int i=0;i<cart.cartList.length;i++){
                totalQuantity += cart.cartList[i].quantity!;
                amount += (cart.cartList[i].price! - cart.cartList[i].discount!) * cart.cartList[i].quantity!;
                discount += cart.cartList[i].discount! * cart.cartList[i].quantity!;
                if (kDebugMode) {
                  print('====TaxModel == ${cart.cartList[i].taxModel}');
                }
                if(cart.cartList[i].taxModel == "exclude"){
                  tax += cart.cartList[i].tax! * cart.cartList[i].quantity!;
                }

              }
              for(int i=0;i<shippingController.chosenShippingList.length;i++){
                shippingAmount += shippingController.chosenShippingList[i].shippingCost!;
              }
              for(int j = 0; j< cartList.length; j++){
                shippingAmount += cart.cartList[j].shippingCost??0;

              }


              return Scaffold(bottomNavigationBar: (!cart.cartLoading && cartList.isNotEmpty) ?
                Consumer<SplashController>(
                  builder: (context, configProvider,_) {


                    return Container(height: cartList.isNotEmpty? 160 : 0, padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,
                        vertical: Dimensions.paddingSizeDefault),

                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                      child: cartList.isNotEmpty ?
                      Column( children: [

                        Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                            Row(children: [
                                Text('${getTranslated('total_price', context)} ', style: titilliumSemiBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                                Text('${getTranslated('inc_vat_tax', context)}', style: titilliumSemiBold.copyWith(
                                    fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor))]),

                            Text(PriceConverter.convertPrice(context, amount+tax+shippingAmount-freeDeliveryAmountDiscount), style: titilliumSemiBold.copyWith(
                                color: Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor : Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeLarge))])),




                        InkWell(onTap: () {
                              bool hasNull = false;
                              bool minimum = false;
                              bool stockOutProduct = false;
                              bool closeShop = false;
                              double total = 0;


                               if(configProvider.configModel!.shippingMethod =='sellerwise_shipping'){
                                for(int index = 0; index < cartProductList.length; index++) {
                                  for(CartModel cart in cartProductList[index]) {
                                    if(cart.productType == 'physical' && sellerGroupList[index].shippingType == 'order_wise'  &&
                                        Provider.of<ShippingController>(context, listen: false).shippingList![index].shippingIndex == -1) {
                                      hasNull = true;
                                      break;
                                    }
                                  }
                                }
                              }


                                for(int index = 0; index < sellerGroupList.length; index++) {
                                  total = 0;
                                  for(CartModel cart in cartProductList[index]) {
                                    total += (cart.price! - cart.discount!) * cart.quantity! ;

                                  }
                                  log("===Here===>$total====<${sellerGroupList[index].minimumOrderAmountInfo!}>");
                                  if(total< sellerGroupList[index].minimumOrderAmountInfo!) {
                                    minimum = true;
                                  }

                                }

                              for(int index = 0; index < sellerGroupList.length; index++) {
                                if(sellerGroupList[index].quantity! > sellerGroupList[index].productInfo!.totalCurrentStock! && sellerGroupList[index].productType =="physical") {
                                  stockOutProduct = true;
                                  break;
                                }

                              }

                              for(int index = 0; index < sellerGroupList.length; index++) {
                                if (sellerGroupList[index].shop?.vacationEndDate != null) {
                                  DateTime vacationDate = DateTime.parse(sellerGroupList[index].shop!.vacationEndDate!);
                                  DateTime vacationStartDate = DateTime.parse(sellerGroupList[index].shop!.vacationStartDate!);
                                  final today = DateTime.now();
                                  final difference = vacationDate.difference(today).inDays;
                                  final startDate = vacationStartDate.difference(today).inDays;

                                  if ((difference >= 0 && sellerGroupList[index].shop!.vacationStatus! && startDate <= 0) || sellerGroupList[index].shop!.temporaryClose!) {
                                    closeShop = true;
                                    break;
                                  }
                                }
                              }





                              if(configProvider.configModel?.guestCheckOut == 0 && !Provider.of<AuthController>(context, listen: false).isLoggedIn()){
                                showModalBottomSheet(backgroundColor: Colors.transparent,context:context, builder: (_)=> const NotLoggedInBottomSheetWidget());
                              }
                              else if (cart.cartList.isEmpty) {
                                showCustomSnackBar(getTranslated('select_at_least_one_product', context), context);
                              } else if (stockOutProduct) {
                                showCustomSnackBar(getTranslated('stock_out_product_in_your_cart', context), context);
                              }
                              else if (closeShop) {
                                showCustomSnackBar(getTranslated('unavailable_shop_product_in_your_cart', context), context);
                              }
                              else if(hasNull && configProvider.configModel!.shippingMethod =='sellerwise_shipping' && !onlyDigital){
                                showCustomSnackBar(getTranslated('select_all_shipping_method', context), context);
                              }

                              else if(shippingController.chosenShippingList.isEmpty &&
                                  configProvider.configModel!.shippingMethod !='sellerwise_shipping' &&
                                  configProvider.configModel!.inhouseSelectedShippingType =='order_wise' && !onlyDigital){
                                showCustomSnackBar(getTranslated('select_all_shipping_method', context), context);
                              }else if(minimum){
                                changeColor();
                                showCustomSnackBar(getTranslated('some_shop_not_full_fill_minimum_order_amount', context), context);
                              }


                              else {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(quantity: totalQuantity,
                                  cartList: cartList,totalOrderAmount: amount,shippingFee: shippingAmount-freeDeliveryAmountDiscount, discount: discount,
                                  tax: tax, onlyDigital: sellerGroupList.length != totalPhysical, hasPhysical: totalPhysical > 0)));
                              }
                          },
                          child: Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),

                            child: Center(child: Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.fontSizeSmall),
                                child: Text(getTranslated('checkout', context)!,
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ]):const SizedBox());
                  }
                ) : null,
                appBar: CustomAppBar(title: getTranslated('my_cart', context)),
                body: Column(children: [



                  cart.cartLoading ? const Expanded(child: CartPageShimmerWidget()) :sellerList.isNotEmpty ?
                  Expanded(child: Column(children: [
                    Expanded(child: RefreshIndicator(
                        onRefresh: () async {
                          if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
                            await Provider.of<CartController>(context, listen: false).getCartData(context);
                          }
                          },
                        child: ListView.builder(
                          itemCount: sellerList.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            bool hasPhysical = false;
                            double totalCost = 0;
                            bool shopClose = false;
                            for(CartModel cart in cartProductList[index]) {
                              totalCost += (cart.price! - cart.discount!) * cart.quantity!;
                            }

                            for(CartModel cart in cartProductList[index]) {
                              if(cart.productType == 'physical') {
                                hasPhysical = true;
                                totalPhysical += 1;
                                break;
                              }
                            }



                            if (sellerGroupList[index].shop?.vacationEndDate != null) {
                              DateTime vacationDate = DateTime.parse(sellerGroupList[index].shop!.vacationEndDate!);
                              DateTime vacationStartDate = DateTime.parse(sellerGroupList[index].shop!.vacationStartDate!);
                              final today = DateTime.now();
                              final difference = vacationDate.difference(today).inDays;
                              final startDate = vacationStartDate.difference(today).inDays;

                              if ((difference >= 0 && sellerGroupList[index].shop!.vacationStatus! && startDate <= 0) || sellerGroupList[index].shop!.temporaryClose!) {
                                shopClose = true;
                              }
                            }

                            return AnimatedContainer(color: (sellerGroupList[index].minimumOrderAmountInfo!> totalCost) ? _currentColor:
                            index.floor().isOdd? Theme.of(context).colorScheme.onSecondaryContainer : Theme.of(context).canvasColor,
                              duration: duration,
                              child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  sellerGroupList[index].shopInfo!.isNotEmpty ?

                                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Expanded(
                                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                              child: Row(children: [
                                                  Flexible(child: Text(sellerGroupList[index].shopInfo!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.start, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                                          color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                                          Theme.of(context).hintColor : Theme.of(context).primaryColor)),),
                                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                    child: Text('(${cartProductList[index].length})',
                                                      style: textBold.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                                      Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))),

                                                if(shopClose)
                                                  JustTheTooltip(
                                                    backgroundColor: Colors.black87,
                                                    controller: tooltipController,
                                                    preferredDirection: AxisDirection.down,
                                                    tailLength: 10,
                                                    tailBaseWidth: 20,
                                                    content: Container(width: 150,
                                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                        child: Text(getTranslated('store_is_closed', context)!,
                                                            style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
                                                    child: InkWell(onTap: ()=>  tooltipController.showTooltip(),
                                                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                                        child: SizedBox(width: 30, child: Image.asset(Images.warning, color: Theme.of(context).colorScheme.error,)),
                                                      ),
                                                    ),
                                                  )


                                                ]))),

                                      SizedBox(width: 200, child: configProvider.configModel!.shippingMethod =='sellerwise_shipping' &&
                                          sellerGroupList[index].shippingType == 'order_wise' && hasPhysical ?

                                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                        child: InkWell(onTap: () {
                                          showModalBottomSheet(
                                            context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                            builder: (context) => ShippingMethodBottomSheetWidget(groupId: sellerGroupList[index].cartGroupId,
                                                sellerIndex: index, sellerId: sellerGroupList[index].id),
                                          );
                                        },
                                          child: Container(decoration: BoxDecoration(
                                              border: Border.all(width: 0.5,color: Colors.grey),
                                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                                            child: Padding(padding: const EdgeInsets.all(8.0),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                               if(shippingController.shippingList == null || shippingController.shippingList!.isEmpty || shippingController.shippingList?[index].shippingMethodList == null ||
                                                   shippingController.chosenShippingList.isEmpty || shippingController.shippingList![index].shippingIndex == -1)

                                                Row(children: [
                                                    SizedBox(width: 15,height: 15, child: Image.asset(Images.delivery,color: Theme.of(context).textTheme.bodyLarge?.color)),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                    Text(getTranslated('choose_shipping', context)!, style: textRegular, overflow: TextOverflow.ellipsis,maxLines: 1,),]),

                                                Flexible(child: Text((shippingController.shippingList == null ||
                                                    shippingController.shippingList![index].shippingMethodList == null ||
                                                    shippingController.chosenShippingList.isEmpty ||
                                                    shippingController.shippingList![index].shippingIndex == -1) ? ''
                                                    : shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].title.toString(),
                                                    style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
                                                    maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end)),
                                                Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      ) : const SizedBox(),)
                                      ],
                                    ),
                                  ) : const SizedBox(),

                                  if(sellerGroupList[index].minimumOrderAmountInfo!> totalCost)
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                    child: Text('${getTranslated('minimum_order_amount_is', context)} '
                                        '${PriceConverter.convertPrice(context, sellerGroupList[index].minimumOrderAmountInfo)}',
                                      style: textRegular.copyWith(color: Theme.of(context).colorScheme.error),),),

                                  if(configProvider.configModel!.shippingMethod == 'sellerwise_shipping' && sellerGroupList[index].shippingType == 'order_wise' && hasPhysical)
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    child: (shippingController.shippingList == null ||
                                        shippingController.shippingList![index].shippingMethodList == null ||
                                        shippingController.chosenShippingList.isEmpty ||
                                        shippingController.shippingList![index].shippingIndex == -1)?const SizedBox():
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(children: [
                                          Text((shippingController.shippingList == null ||
                                              shippingController.shippingList![index].shippingMethodList == null ||
                                              shippingController.chosenShippingList.isEmpty ||
                                              shippingController.shippingList![index].shippingIndex == -1) ? '':
                                          '${getTranslated('shipping_cost', context)??''} : ', style: textRegular,),

                                        Text((shippingController.shippingList == null ||
                                            shippingController.shippingList![index].shippingMethodList == null ||
                                            shippingController.chosenShippingList.isEmpty ||
                                            shippingController.shippingList![index].shippingIndex == -1) ? ''
                                            : PriceConverter.convertPrice(context,
                                            shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].cost),
                                            style: textBold.copyWith(),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end),
                                        ],
                                      ),
                                      const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                      Row(children: [
                                          Text((shippingController.shippingList == null ||
                                              shippingController.shippingList![index].shippingMethodList == null ||
                                              shippingController.chosenShippingList.isEmpty ||
                                              shippingController.shippingList![index].shippingIndex == -1) ? '':
                                          '${getTranslated('shipping_time', context)??''} : ',style: textRegular,),
                                        Text((shippingController.shippingList == null ||
                                            shippingController.shippingList![index].shippingMethodList == null ||
                                            shippingController.chosenShippingList.isEmpty ||
                                            shippingController.shippingList![index].shippingIndex == -1) ? ''
                                            : '${shippingController.shippingList![index].shippingMethodList![shippingController.shippingList![index].shippingIndex!].duration.toString()} '
                                            '${getTranslated('days', context)}',
                                            style: textBold.copyWith(),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.end)
                                        ],
                                      ),

                                    ],),
                                  ),



                                  Card(child: Container(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                    decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                                    child: Column(children: [
                                      ListView.builder(physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(0),
                                        itemCount: cartProductList[index].length,
                                        itemBuilder: (context, i) {
                                        return CartWidget(cartModel: cartProductList[index][i],
                                          index: cartProductIndexList[index][i],
                                          fromCheckout: widget.fromCheckout,
                                        );
                                        },
                                      ),

                                    ],
                                    ),
                                  ),
                                  ),
                                    if(sellerGroupList[index].freeDeliveryOrderAmount?.status == 1 && hasPhysical)
                                    Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeDefault,
                                        right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        SizedBox(height: 16, child: Image.asset(Images.freeShipping,
                                          color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                          Theme.of(context).hintColor: Theme.of(context).primaryColor,)),
                                        if(sellerGroupList[index].freeDeliveryOrderAmount!.amountNeed! > 0)
                                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                            child: Text(PriceConverter.convertPrice(context, sellerGroupList[index].freeDeliveryOrderAmount!.amountNeed!),
                                                style: textMedium.copyWith(color: Theme.of(context).primaryColor)),),
                                        sellerGroupList[index].freeDeliveryOrderAmount!.percentage! < 100?
                                        Text('${getTranslated('add_more_for_free_delivery', context)}', style: textMedium.copyWith(color: Theme.of(context).hintColor)):
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                          child: Text('${getTranslated('you_got_free_delivery', context)}', style: textMedium.copyWith(color: Colors.green)),
                                        )
                                      ],),
                                    ),
                                  if(sellerGroupList[index].freeDeliveryOrderAmount?.status == 1 && hasPhysical)
                                    Padding(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                                      child: LinearPercentIndicator(
                                        padding: EdgeInsets.zero,
                                        barRadius: const Radius.circular(Dimensions.paddingSizeDefault),
                                        width: MediaQuery.of(context).size.width - 40,
                                        lineHeight: 4.0,
                                        percent: sellerGroupList[index].freeDeliveryOrderAmount!.percentage! / 100,
                                        backgroundColor: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                        Theme.of(context).primaryColor.withOpacity(.5):Theme.of(context).primaryColor.withOpacity(.2),
                                        progressColor: (sellerGroupList[index].freeDeliveryOrderAmount!.percentage! < 100 &&
                                            !Provider.of<ThemeController>(context, listen: false).darkTheme)?
                                        Theme.of(context).colorScheme.onSecondary : Colors.green,
                                      ),
                                    ),
                                ]),
                              ),
                            );
                            },
                        ),
                      ),
                    ),
                    ( !onlyDigital && configProvider.configModel!.shippingMethod != 'sellerwise_shipping' && configProvider.configModel!.inhouseSelectedShippingType =='order_wise')?
                    InkWell(onTap: () {showModalBottomSheet(
                          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                          builder: (context) => const ShippingMethodBottomSheetWidget(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1));},
                      child: Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0,Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                        child: Container(decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Padding(padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                              Row(children: [
                                  SizedBox(width: 15,height: 15, child: Image.asset(Images.delivery, color: Theme.of(context).textTheme.bodyLarge?.color)),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(getTranslated('choose_shipping', context)!, style: textRegular, overflow: TextOverflow.ellipsis,maxLines: 1,),]),

                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                Text((shippingController.shippingList == null ||shippingController.chosenShippingList.isEmpty ||
                                    shippingController.shippingList!.isEmpty || shippingController.shippingList![0].shippingMethodList == null ||
                                    shippingController.shippingList![0].shippingIndex == -1) ? ''
                                    : shippingController.shippingList![0].shippingMethodList![shippingController.shippingList![0].shippingIndex!].title.toString(),
                                  style: titilliumSemiBold.copyWith(color: Theme.of(context).hintColor),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                              ]),
                            ]),
                          ),
                        ),
                      ),
                    ):const SizedBox(),


                  ],
                  ),
                  ) : const Expanded(child: NoInternetOrDataScreenWidget(icon: Images.emptyCart, icCart: true,
                    isNoInternet: false, message: 'no_product_in_cart',)),
                ]),
              );
            });
          }
        );
      }
    );
  }
}
