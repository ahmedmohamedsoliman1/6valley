
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/custom_check_box_widget.dart';
import 'package:provider/provider.dart';

class PaymentMethodBottomSheetWidget extends StatefulWidget {
  final bool onlyDigital;
  const PaymentMethodBottomSheetWidget({super.key, required this.onlyDigital,});
  @override
  PaymentMethodBottomSheetWidgetState createState() => PaymentMethodBottomSheetWidgetState();
}
class PaymentMethodBottomSheetWidgetState extends State<PaymentMethodBottomSheetWidget> {


  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutController>(
      builder: (context, checkoutProvider, _) {
        return Container(constraints : BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9,
            minHeight: MediaQuery.of(context).size.height * 0.5 ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(color: Theme.of(context).highlightColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: Center(child: Container(width: 35,height: 4,decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).hintColor.withOpacity(.5))))),

              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(getTranslated('choose_payment_method', context)??'',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault)),

                  Expanded(child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                      child: Text('${getTranslated('click_one_of_the_option_below', context)}',
                          style: textRegular.copyWith(color: Theme.of(context).hintColor,
                              fontSize: Dimensions.fontSizeSmall))))])),


              Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [


                  Row(children: [
                    if(Provider.of<SplashController>(context, listen: false).configModel != null &&
                        Provider.of<SplashController>(context, listen: false).configModel!.cashOnDelivery! && !widget.onlyDigital)
                    Expanded(child: CustomButton(
                        isBorder: true,
                      leftIcon: Images.cod,
                      backgroundColor: checkoutProvider.codChecked? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                        textColor:  checkoutProvider.codChecked? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeSmall,
                        onTap: () => checkoutProvider.setOfflineChecked('cod'),
                        buttonText: '${getTranslated('cash_on_delivery', context)}')),
                    const SizedBox(width: Dimensions.paddingSizeDefault),

                    if(Provider.of<SplashController>(context, listen: false).configModel != null &&
                        Provider.of<SplashController>(context, listen: false).configModel!.walletStatus! == 1 &&
                        Provider.of<AuthController>(context, listen: false).isLoggedIn())

                    Expanded(child: CustomButton(onTap: () => checkoutProvider.setOfflineChecked('wallet'),
                        isBorder: true,
                        leftIcon: Images.payWallet,
                        backgroundColor: checkoutProvider.walletChecked ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                        textColor:  checkoutProvider.walletChecked? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeSmall,
                        buttonText: '${getTranslated('pay_via_wallet', context)}'))],),



                  if(Provider.of<SplashController>(context, listen: false).configModel != null &&
                      Provider.of<SplashController>(context, listen: false).configModel!.digitalPayment!)
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${getTranslated('pay_via_online', context)}', style: textRegular),
                        Expanded(child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                            child: Text('${getTranslated('fast_and_secure', context)}',
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).hintColor)),))])),


                  if(Provider.of<SplashController>(context, listen: false).configModel != null &&
                      Provider.of<SplashController>(context, listen: false).configModel!.digitalPayment!)
                    Consumer<SplashController>(
                      builder: (context, configProvider,_) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: configProvider.configModel?.paymentMethods?.length??0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return  CustomCheckBoxWidget(index: index,
                              icon: '${configProvider.configModel?.paymentMethodImagePath}/'
                                  '${configProvider.configModel?.paymentMethods?[index].additionalDatas?.gatewayImage??''}',
                              name: configProvider.configModel!.paymentMethods![index].keyName!,
                              title: configProvider.configModel!.paymentMethods![index].additionalDatas?.gatewayTitle??'',
                            );
                          },
                        );
                      }
                  ),


                  if(Provider.of<SplashController>(context, listen: false).configModel != null &&
                      Provider.of<SplashController>(context, listen: false).configModel!.offlinePayment != null)
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Container(decoration: BoxDecoration(
                        color: checkoutProvider.offlineChecked?Theme.of(context).primaryColor.withOpacity(.15): null,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                      child: Column(children: [

                        InkWell(onTap: () {
                            if(checkoutProvider.offlinePaymentModel?.offlineMethods != null &&
                                checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty){
                              checkoutProvider.setOfflineChecked('offline');
                            }
                          },
                          child: Padding(padding: const EdgeInsets.all(8.0),
                            child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
                              child: Row(children: [
                                Theme(data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Theme.of(context).primaryColor.withOpacity(.25),),
                                  child: Checkbox(visualDensity: VisualDensity.compact,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge)),
                                      value: checkoutProvider.offlineChecked, activeColor: Colors.green,
                                      onChanged: (bool? isChecked){
                                        if(checkoutProvider.offlinePaymentModel?.offlineMethods != null &&
                                            checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty){
                                          checkoutProvider.setOfflineChecked('offline');}})),
                                Text('${getTranslated('pay_offline', context)}', style: textRegular.copyWith(),)])))),


                      if(checkoutProvider.offlinePaymentModel != null && checkoutProvider.offlinePaymentModel!.offlineMethods != null &&
                          checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty && checkoutProvider.offlineChecked)
                        Padding(padding: EdgeInsets.only(left: Provider.of<LocalizationController>(context, listen: false).isLtr?
                        Dimensions.paddingSizeDefault : 0, bottom: Dimensions.paddingSizeDefault,
                            right: Provider.of<LocalizationController>(context, listen: false).isLtr?
                            0 : Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeSmall),
                          child: SizedBox(height: 40,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: checkoutProvider.offlinePaymentModel!.offlineMethods!.length,
                                itemBuilder: (context, index){
                                  return InkWell(onTap: (){
                                      if(checkoutProvider.offlinePaymentModel?.offlineMethods != null &&
                                          checkoutProvider.offlinePaymentModel!.offlineMethods!.isNotEmpty) {
                                        checkoutProvider.setOfflinePaymentMethodSelectedIndex(index);
                                      }
                                    },
                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                      child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                          border: checkoutProvider.offlineMethodSelectedIndex == index ?
                                          Border.all(color: Theme.of(context).primaryColor, width: 2):
                                          Border.all(color: Theme.of(context).primaryColor.withOpacity(.5), width: .25)),
                                          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                            child: Center(child: Text(checkoutProvider.offlinePaymentModel!.offlineMethods![index].methodName??'')),
                                          )),
                                    ));
                                })))
                      ]))),

                  CustomButton(buttonText: '${getTranslated('save', context)}',
                  onTap: ()=> Navigator.of(context).pop()),
                ],
              ),

            ]),
          ),
        );
      }
    );
  }
}

class FilterItemWidget extends StatelessWidget {
  final String? title;
  final int index;
  const FilterItemWidget({super.key, required this.title, required this.index});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Row(children: [
          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(onTap: ()=> Provider.of<SearchProductController>(context, listen: false).setFilterIndex(index),
                child: Icon(Provider.of<SearchProductController>(context).filterIndex == index?
                Icons.check_box_rounded: Icons.check_box_outline_blank_rounded,
                    color: Provider.of<SearchProductController>(context).filterIndex == index?
                    Theme.of(context).primaryColor: Theme.of(context).hintColor.withOpacity(.5))),
          ),
          Expanded(child: Text(title??'', style: textRegular.copyWith())),
        ],),),
    );
  }
}

class CategoryFilterItem extends StatelessWidget {
  final String? title;
  final bool checked;
  final Function()? onTap;
  const CategoryFilterItem({super.key, required this.title, required this.checked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Row(children: [
          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(onTap: onTap,
                child: Icon(checked? Icons.check_box_rounded: Icons.check_box_outline_blank_rounded,
                    color: checked? Theme.of(context).primaryColor: Theme.of(context).hintColor.withOpacity(.5)))),
          Expanded(child: Text(title??'', style: textRegular.copyWith())),
        ],),),
    );
  }
}

