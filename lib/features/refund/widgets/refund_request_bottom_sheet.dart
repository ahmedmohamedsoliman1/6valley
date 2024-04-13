
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class RefundBottomSheet extends StatefulWidget {
  final Product? product;
  final int orderDetailsId;
  final String orderId;
  const RefundBottomSheet({super.key, required this.product, required this.orderDetailsId, required this.orderId});

  @override
  RefundBottomSheetState createState() => RefundBottomSheetState();
}

class RefundBottomSheetState extends State<RefundBottomSheet> {
  final TextEditingController _refundReasonController = TextEditingController();
  @override
  void initState() {
    Provider.of<RefundController>(context, listen: false).getRefundReqInfo(widget.orderDetailsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: getTranslated('refund_request', context)),

      body: SingleChildScrollView(
        child: Consumer<RefundController>(builder: (context,refundReq,_) {
          return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Consumer<RefundController>(builder: (context, refund,_) {
                return (refund.refundInfoModel != null && refund.refundInfoModel!.refund != null)?
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor,
                            boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme ? null :
                            [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1,
                                blurRadius: 7, offset: const Offset(0, 1))],
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                        child: Column(children: [

                          TitleWithAmountRow(title: getTranslated('total_price', context)!,
                              amount: PriceConverter.convertPrice(context,
                                  refund.refundInfoModel!.refund!.productPrice!*refund.refundInfoModel!.refund!.quntity!)),

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: TitleWithAmountRow(title: getTranslated('product_discount', context)!,
                                  amount: '-${PriceConverter.convertPrice(context, refund.refundInfoModel!.refund!.productTotalDiscount)}')),

                          TitleWithAmountRow(title: getTranslated('tax', context)!,
                              amount: PriceConverter.convertPrice(context, refund.refundInfoModel!.refund!.productTotalTax)),

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: TitleWithAmountRow(title: getTranslated('sub_total', context)!,
                                  amount: PriceConverter.convertPrice(context, refund.refundInfoModel!.refund!.subtotal))),

                          TitleWithAmountRow(title: getTranslated('coupon_discount', context)!,
                              amount: PriceConverter.convertPrice(context, refund.refundInfoModel!.refund!.couponDiscount)),

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Divider(color: Theme.of(context).primaryColor.withOpacity(0.125), height: 2)),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('total_refund_amount', context)!, style: robotoBold),
                            Text(PriceConverter.convertPrice(context, refund.refundInfoModel!.refund!.refundAmount),
                                style: robotoBold.copyWith(color: Theme.of(context).primaryColor))])]))]),
                ): const SizedBox();}),
              const SizedBox(height: Dimensions.paddingSizeDefault),


              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    Text(getTranslated('refund_reason', context)!, style: textRegular),
                    Icon(Icons.keyboard_arrow_down, color: Theme.of(context).hintColor, size: 30)])),

              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CustomTextFieldWidget(maxLines: 4,
                      controller: _refundReasonController, inputAction: TextInputAction.done)),

              Consumer<RefundController>(builder: (context, refundProvider,_) {
                return refundProvider.refundImage.isNotEmpty?
                SizedBox(height: 100, child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: refundProvider.refundImage.length,
                    itemBuilder: (BuildContext context, index){
                      return  refundProvider.refundImage.isNotEmpty?
                      Padding(padding: const EdgeInsets.all(8.0), child: Stack(children: [
                        Container(width: 100, height: 100,
                            decoration: const BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                child: Image.file(File(refundProvider.refundImage[index]!.path), width: 100, height: 100,
                                    fit: BoxFit.cover))),
                        Positioned(top:0,right:0, child: InkWell(onTap :() => refundProvider.removeImage(index),
                            child: Container(decoration: BoxDecoration(color: Theme.of(context).hintColor,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                                child: const Padding(padding: EdgeInsets.all(4.0),
                                    child: Icon(Icons.clear,color: Colors.white,size: Dimensions.iconSizeExtraSmall))))),
                      ])):const SizedBox();})):const SizedBox();}),


              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: InkWell(onTap: () => refundReq.pickImage(false), child: SizedBox(height: 30,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Text(getTranslated('upload_image', context)!),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Image.asset(Images.uploadImage)])))),


              refundReq.isLoading? const Center(child: CircularProgressIndicator()):
              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: CustomButton(
                buttonText: getTranslated('send_request', context),
                onTap: () {String reason  = _refundReasonController.text.trim().toString();
                  if(reason.isEmpty) {
                    showCustomSnackBar(getTranslated('reason_required', context)??'', context);
                  }else {
                    refundReq.refundRequest(widget.orderId, widget.orderDetailsId, refundReq.refundInfoModel!.refund!.refundAmount,reason);}
                  },
              ),
              ),
            ]),
          );
        }),
      ),
    );
  }
}

class TitleWithAmountRow extends StatelessWidget {
  final String title;
  final String amount;
  const TitleWithAmountRow({
    super.key, required this.title, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: textRegular.copyWith(color: Theme.of(context).hintColor)),
        Text(amount, style: textRegular),
      ],
    );
  }
}


