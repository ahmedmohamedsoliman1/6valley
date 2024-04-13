import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/models/order_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/controllers/review_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_body.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:provider/provider.dart';

class ReviewDialog extends StatefulWidget {
  final String productID;
  final Function? callback;
  final OrderDetailsModel orderDetailsModel;
  final String orderType;
  final String orderId;
  const ReviewDialog({super.key, required this.productID, required this.callback, required this.orderDetailsModel, required this.orderType, required this.orderId});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {

  @override
  void initState() {
    Provider.of<ReviewController>(Get.context!, listen: false).initReviewImage();
    loadData();
    super.initState();
  }
  final TextEditingController _controller = TextEditingController();
  Future<void> loadData() async{
    await Provider.of<ReviewController>(Get.context!, listen: false).getOrderWiseReview(widget.productID, widget.orderId);
    if(Provider.of<ReviewController>(Get.context!, listen: false).orderWiseReview != null){
      Provider.of<ReviewController>(Get.context!, listen: false).setRating(Provider.of<ReviewController>(Get.context!, listen: false).orderWiseReview!.rating!);
      _controller.text = Provider.of<ReviewController>(Get.context!, listen: false).orderWiseReview?.comment??'';
    }
  }



  @override
  Widget build(BuildContext context) {
    log("===>orderid=Review===> ${widget.orderId}");
    return Consumer<ReviewController>(
      builder: (context, reviewController, _) {
        return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column( mainAxisSize: MainAxisSize.min, children: [
                Align(alignment: Alignment.topRight,
                  child: InkWell(onTap: () => Navigator.pop(context),
                    child: Container(decoration: BoxDecoration(shape: BoxShape.circle,
                        color: Theme.of(context).cardColor.withOpacity(0.5)),
                      padding: const EdgeInsets.all(3), child: const Icon(Icons.clear)))),
                const SizedBox(height: Dimensions.paddingSizeSmall),


                Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                    color: Theme.of(context).cardColor),
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(Dimensions.homePagePadding),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      OrderDetails(orderDetailsModel: widget.orderDetailsModel,
                        orderType: widget.orderType,),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Center(child: Text(getTranslated('rate_the_quality', context)??'',
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))),

                      Center(child: SizedBox(height: 45,
                          child: ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(child: Icon(reviewController.rating < (index+1) ?
                              Icons.star_outline_rounded : Icons.star_rate_rounded, size: 30,
                                  color: reviewController.rating < (index+1) ?
                                  Theme.of(context).primaryColor.withOpacity(0.125) : Theme.of(context).primaryColor),
                                onTap: () => reviewController.setRating(index+1));}))),


                      Align(alignment: Alignment.centerLeft,
                        child: Text(getTranslated('have_thoughts_to_share', context)!,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall))),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      CustomTextFieldWidget(
                        maxLines: 4,
                        hintText: getTranslated('write_your_experience_here', context),
                        controller: _controller,
                        inputAction: TextInputAction.done),


                    if(reviewController.orderWiseReview != null && reviewController.orderWiseReview!.attachment != null && reviewController.orderWiseReview!.attachment!.isNotEmpty)
                      Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
                          child: SizedBox(height: 75,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount : reviewController.orderWiseReview?.attachment?.length ,
                                  itemBuilder: (BuildContext context, index){
                                    log("--img--> ${Provider.of<SplashController>(context, listen: false).baseUrls?.reviewImageUrl}/${reviewController.orderWiseReview?.attachment?[index]}");
                                    return Stack(children: [
                                      Padding(padding: const EdgeInsets.only(right : Dimensions.paddingSizeSmall),
                                          child: Container(decoration: const BoxDecoration(color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(20)),),
                                              child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                                  child:  CustomImageWidget(image: "${Provider.of<SplashController>(context, listen: false).baseUrls?.reviewImageUrl}/review/${reviewController.orderWiseReview?.attachment?[index]}",)))),


                                      Positioned(top:0,right: 0,
                                          child: InkWell(onTap :() => reviewController.deleteOrderWiseReviewImage(reviewController.orderWiseReview!.id!.toString(), reviewController.orderWiseReview!.attachment![index].toString(), widget.productID, widget.orderId),
                                              child: Container(decoration: const BoxDecoration(color: Colors.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                                                  child: Padding(padding: const EdgeInsets.all(4.0),
                                                      child: Icon(Icons.cancel,color: Theme.of(context).hintColor, size: 15)))))]);} ))),


                    Padding(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault),
                      child: SizedBox(height: 75,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount : reviewController.reviewImages.length + 1 ,
                            itemBuilder: (BuildContext context, index){
                              return index ==  reviewController.reviewImages.length ?
                              Padding(padding: const EdgeInsets.only(right : Dimensions.paddingSizeDefault),
                                child: InkWell(onTap: ()=> reviewController.pickImage(false, fromReview: true),
                                  child: DottedBorder(
                                    strokeWidth: 2,
                                    dashPattern: const [10,5],
                                    color: Theme.of(context).hintColor,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(Dimensions.paddingSizeSmall),
                                    child: Stack(children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                        child:  SizedBox(height: 75,
                                          width: 75, child: Image.asset(Images.placeholder, fit: BoxFit.cover))),
                                      Positioned(bottom: 0, right: 0, top: 0, left: 0,
                                        child: Container(decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(0.07),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)))),
                                    ],
                                    ),
                                  ),
                                ),
                              ) :

                              Stack(children: [
                                Padding(padding: const EdgeInsets.only(right : Dimensions.paddingSizeSmall),
                                  child: Container(decoration: const BoxDecoration(color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(20)),),
                                    child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                                      child:  Image.file(File(reviewController.reviewImages[index].path),
                                        width: 75, height: 75, fit: BoxFit.cover)))),


                                Positioned(top:0,right:0,
                                  child: InkWell(onTap :() => reviewController.removeImage(index,fromReview: true),
                                    child: Container(decoration: const BoxDecoration(color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))),
                                        child: Padding(padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.cancel,color: Theme.of(context).hintColor, size: 15)))))]);} ))),


                    Provider.of<ReviewController>(context).errorText != null ?
                      Padding(padding: const EdgeInsets.all(8.0),
                        child: Text(Provider.of<ReviewController>(context).errorText!,
                            style: textRegular.copyWith(color: ColorResources.red))) :
                      const SizedBox.shrink(),

                      Consumer<ReviewController>(builder: (context, reviewController,_) => !reviewController.isLoading ?
                        CustomButton(buttonText: getTranslated('submit', context),
                          onTap: () {
                            log("===>orderid====> ${widget.orderId}");
                            if(reviewController.rating == 0) {
                              reviewController.setErrorText('${getTranslated('add_a_rating', context)}');
                            }else if(_controller.text.isEmpty) {
                              reviewController.setErrorText('${getTranslated('write_a_review', context)}');
                            }else {
                              reviewController.setErrorText('');
                              ReviewBody reviewBody = ReviewBody(
                                id: reviewController.orderWiseReview?.id.toString(),
                                  productId: widget.productID,
                                orderId: widget.orderId,
                                rating: reviewController.rating.toString(),
                                comment: _controller.text.isEmpty ? '' : _controller.text);
                              reviewController.submitReview(reviewBody, reviewController.reviewImages, reviewController.orderWiseReview != null).then((value) {
                                if(value.isSuccess) {
                                  Navigator.pop(context);
                                  widget.callback!();
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  _controller.clear();
                                }else {
                                  reviewController.setErrorText(value.message);
                                }
                              });
                            }
                          },
                        ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}



///Order Details Widget

class OrderDetails extends StatefulWidget {
  final OrderDetailsModel orderDetailsModel;

  final String orderType;
  const OrderDetails({super.key, required this.orderDetailsModel, required this.orderType});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            color: Theme.of(context).cardColor,
            boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme ? null : [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

          child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.125),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(.125)),),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: 70, height: 70,
                    image: '${Provider.of<SplashController>(context, listen: false).
                    baseUrls!.productThumbnailUrl}/${widget.orderDetailsModel.productDetails?.thumbnail}',
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                        fit: BoxFit.scaleDown, width: 70, height: 70)))),
              const SizedBox(width: Dimensions.marginSizeDefault),



              Expanded(flex: 3,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(widget.orderDetailsModel.productDetails?.name??'',
                        style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor),
                        maxLines: 2, overflow: TextOverflow.ellipsis))]),
                    const SizedBox(height: Dimensions.marginSizeExtraSmall),


                    Row(children: [
                      Text("${getTranslated('price', context)}: ",
                        style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: 14),),

                      Text(PriceConverter.convertPrice(context, widget.orderDetailsModel.price),maxLines: 1,
                          style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context), fontSize: 16),),

                      Expanded(child: Text('(${getTranslated('tax', context)} ${widget.orderDetailsModel.productDetails!.taxModel} ${widget.orderDetailsModel.tax})',
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: 14)))]),
                    const SizedBox(height: Dimensions.marginSizeExtraSmall),

                    Text('${getTranslated('qty', context)}: ${widget.orderDetailsModel.qty}',
                        style: titilliumRegular.copyWith(color: ColorResources.hintTextColor, fontSize: 14)),
                    const SizedBox(height: Dimensions.marginSizeExtraSmall),



                    (widget.orderDetailsModel.variant != null && widget.orderDetailsModel.variant!.isNotEmpty) ?
                    Padding(padding: const EdgeInsets.only(
                        top: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        Text('${getTranslated('variations', context)}: ',
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),


                        Flexible(child: Text(widget.orderDetailsModel.variant!,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,)))]),
                    ) : const SizedBox(),
                    const SizedBox(height: Dimensions.marginSizeExtraSmall)]))])),

        Positioned(top: 10,  left: 0,
          child: widget.orderDetailsModel.discount! > 0?
          Container(height: 20,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                  bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall))),


            child: Text(PriceConverter.percentageCalculation(context,
                (widget.orderDetailsModel.price! * widget.orderDetailsModel.qty!),
                widget.orderDetailsModel.discount, 'amount'),
              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: ColorResources.white))):const SizedBox(),
        ),
      ],
    );
  }
}
