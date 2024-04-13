import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/controllers/coupon_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/proced_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/shipping_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/offline_payment/widgets/offline_card_widget.dart';
import 'package:provider/provider.dart';

class OfflinePaymentScreen extends StatefulWidget {
  final double payableAmount;
  final Function callback;
  const OfflinePaymentScreen({super.key, required this.payableAmount, required this.callback});

  @override
  State<OfflinePaymentScreen> createState() => _OfflinePaymentScreenState();
}

class _OfflinePaymentScreenState extends State<OfflinePaymentScreen> {
   TextEditingController paymentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('offline_payment', context)),
      body: Consumer<CheckoutController>(
        builder: (context, checkoutProvider, _) {
          return CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
                Center(child: SizedBox(height: 100, child: Image.asset(Images.offlinePayment))),
                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Text('${getTranslated('offline_payment_helper_text', context)}', textAlign: TextAlign.center,
                      style: textRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeDefault)),),

                if(checkoutProvider.offlinePaymentModel != null && checkoutProvider.offlinePaymentModel!.offlineMethods != null &&
                    checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty)
                  SizedBox(height: 190,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods!.length,
                          itemBuilder: (context, index){
                            return InkWell(
                              splashColor: Colors.transparent,
                              onTap: (){
                              if(checkoutProvider.offlinePaymentModel?.offlineMethods != null &&
                                  checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty){
                                checkoutProvider.setOfflinePaymentMethodSelectedIndex(index);
                              }
                            }, child: OfflineCardWidget(
                                offlinePaymentModel: checkoutProvider.offlinePaymentModel!.offlineMethods![index],
                                index: index));})),


                Center(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Text('${getTranslated('amount', context)} : ${PriceConverter.convertPrice(context, widget.payableAmount)}',
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge)))),


                Text('${getTranslated('payment_info', context)}', style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?.length,
                    itemBuilder: (context, index){
                      return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                        child: CustomTextFieldWidget(
                          controller: checkoutProvider.inputFieldControllerList[index],
                          required: checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].isRequired == 1,
                          labelText: '${checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].customerInput}'.replaceAll('_', ' ').capitalize(),
                          hintText: '${checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations?[index].customerPlaceholder}'.replaceAll('_', ' ').capitalize(),),);}),


                const SizedBox(height: 20,),
                CustomTextFieldWidget(controller: paymentController,
                labelText:  getTranslated('note', context),
                hintText: getTranslated('note', context),),
                const SizedBox(height: 20,),
              ])))]);}),


      bottomNavigationBar: Consumer<CheckoutController>(
        builder: (context, checkoutProvider, _) {
          return Consumer<ProfileController>(
            builder: (context, profileProvider,_) {
              return Consumer<CouponController>(
                builder: (context, couponProvider,_) {
                  return Consumer<AddressController>(
                    builder: (context, locationProvider,_) {
                      return InkWell(onTap: (){bool emptyRequiredField = false;
                          for(int i = 0; i< checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations!.length; i++){
                            if(checkoutProvider.offlinePaymentModel!.offlineMethods![checkoutProvider.offlineMethodSelectedIndex].methodInformations![i].isRequired == 1 && checkoutProvider.inputFieldControllerList[i].text.isEmpty){
                              emptyRequiredField = true;
                              break;
                            }
                          }
                          if(emptyRequiredField){
                            showCustomSnackBar('${getTranslated('fill_all_required_fill', context)}', context);
                          }
                          else{
                            String paymentNote = paymentController.text.trim();
                            String orderNote = checkoutProvider.orderNoteController.text.trim();
                            String couponCode = couponProvider.discount != null && couponProvider.discount != 0? couponProvider.couponCode : '';
                            String couponCodeAmount = couponProvider.discount != null && couponProvider.discount != 0?
                            couponProvider.discount.toString() : '0';
                            String addressId = checkoutProvider.addressIndex != null ?
                            locationProvider.addressList![checkoutProvider.addressIndex!].id.toString() : '';
                            String billingAddressId =  (Provider.of<SplashController>(context, listen: false).configModel!.billingInputByCustomer == 1)?
                            !checkoutProvider.sameAsBilling ?
                             locationProvider.addressList![checkoutProvider.billingAddressIndex!].id.toString() : locationProvider.addressList![checkoutProvider.addressIndex!].id.toString() : '';


                            print('====AddressID=========>>${addressId}');
                            print('====billingAddressID=======>>${billingAddressId}');


                            checkoutProvider.placeOrder(callback: widget.callback, paymentNote: paymentNote,
                                addressID: addressId, billingAddressId: billingAddressId,
                                orderNote: orderNote, couponCode: couponCode, couponAmount: couponCodeAmount, isfOffline: true);
                          }
                        }, child: const ProceedButtonWidget());
                    }
                  );
                }
              );
            }
          );
        }
      ),
    );
  }
}
