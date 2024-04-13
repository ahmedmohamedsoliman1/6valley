
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/controllers/refund_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:provider/provider.dart';

class RefundDetailsWidget extends StatefulWidget {
  final Product? product;
  final int? orderDetailsId;
  final String? createdAt;
  final OrderDetailsModel? orderDetailsModel;
  const RefundDetailsWidget({super.key, required this.product, required this.orderDetailsId, this.orderDetailsModel, required this.createdAt});
  @override
  RefundDetailsWidgetState createState() => RefundDetailsWidgetState();
}

class RefundDetailsWidgetState extends State<RefundDetailsWidget> {
  @override
  void initState() {
    Provider.of<RefundController>(context, listen: false).getRefundResult(context, widget.orderDetailsId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: getTranslated('refund_request_details', context),
        showActionButton: true,showResetIcon: true, reset: Consumer<RefundController>(
          builder: (context, refund,_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: 2),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                border: Border.all(color: Colors.green, width: 1)
              ),
                child: Text("${getTranslated("${refund.refundResultModel!.refundRequest![0].status}", context)}",
                    style:  textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.green)),),
            );
          }
        )),
      body: Column(children: [
          SingleChildScrollView(
            child: Consumer<OrderDetailsController>(
              builder: (context, orderDetailsController,_) {
                return Consumer<RefundController>(builder: (context,refundReq,_) {
                  return Padding(padding: MediaQuery.of(context).viewInsets,
                    child: Consumer<RefundController>(builder: (context, refund,_) {
                    return refund.refundResultModel!=null && refund.refundResultModel!.refundRequest != null ?
                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [



                        Center(child: Column(children: [
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            child: Container(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                child: Column(children: [
                                  Text(getTranslated("refund_amount", context)??'',
                                    style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(.75),
                                        fontSize: Dimensions.fontSizeDefault),),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                  Text(PriceConverter.convertPrice(context,
                                      refund.refundInfoModel!.refund!.refundAmount),
                                    style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),)
                            ]))),

                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeDefault),
                            child: RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                              TextSpan(text: "${getTranslated('order_placed_date', context)} : ",
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.displayLarge?.color?.withOpacity(.75))),
                              TextSpan(text: DateConverter.refundDateTime(widget.createdAt!),
                                  style:  textMedium.copyWith(fontSize: Dimensions.fontSizeDefault))]))),


                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                              TextSpan(text: "${getTranslated('refund_request', context)} : ",
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.displayLarge?.color?.withOpacity(.75))),
                              TextSpan(text: DateConverter.refundDateTime(refund.refundResultModel!.refundRequest![0].createdAt!),
                                  style:  textMedium.copyWith(fontSize: Dimensions.fontSizeDefault))]))),



                            refund.refundResultModel!.refundRequest![0].approvedNote != null?
                            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                TextSpan(text: getTranslated('approved_note', context),
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),


                                const TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w200)),

                                TextSpan(text: refund.refundResultModel!.refundRequest![0].approvedNote,
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault))]))):
                            const SizedBox(),


                            refund.refundResultModel!.refundRequest![0].rejectedNote != null?
                            RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                              TextSpan(text: getTranslated('rejected_note', context),
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.displayLarge?.color?.withOpacity(.75))),


                              const TextSpan(text: ' : ', style: TextStyle(fontWeight: FontWeight.w200)),
                              TextSpan(text: refund.refundResultModel!.refundRequest![0].rejectedNote,
                                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),],),):
                            const SizedBox(),

                          ],
                        ),),



                        Padding(padding: const EdgeInsets.all(8.0),
                          child: Container(width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style, children: <TextSpan>[
                                TextSpan(text:  "${getTranslated('reason', context)} : ",
                                    style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                                TextSpan(text: refund.refundResultModel!.refundRequest![0].refundReason,
                                    style:  textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),],),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),


                              (refund.refundResultModel!.refundRequest![0].images != null && refund.refundResultModel!.refundRequest![0].images!.isNotEmpty)?
                              SizedBox(height: 90,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount:  refund.refundResultModel!.refundRequest![0].images!.length,
                                  itemBuilder: (BuildContext context, index){
                                    return  refund.refundResultModel!.refundRequest![0].images!.isNotEmpty?
                                    Padding(padding: const EdgeInsets.all(8.0),
                                      child: Stack(children: [
                                        InkWell(onTap: () => showDialog(context: context, builder: (ctx) =>
                                            ImageDialog(imageUrl:'${AppConstants.baseUrl}/storage/app/public/refund/'
                                                '${refund.refundResultModel!.refundRequest![0].images![index]}'), ),
                                          child: Container(width: 85, height: 85,
                                            decoration: const BoxDecoration(
                                              color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                            child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                              child: CustomImageWidget(placeholder: Images.placeholder, image: '${AppConstants.baseUrl}/storage/app/public/refund/'
                                                      '${refund.refundResultModel!.refundRequest![0].images![index]}',
                                                  width: 85, height: 85, fit: BoxFit.cover),) ,
                                          ),
                                        ),
                                      ],),):const SizedBox();
                                  },),):const SizedBox()

                            ],),),
                        ),






                      ]),):const SizedBox();
                  }),
                  );
                });
              }
            ),
          ),
        ],
      ),
    );
  }
}


