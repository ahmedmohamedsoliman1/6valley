import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cal_chat_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/cancel_and_support_center_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_amount_calculation.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_details_status_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/ordered_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/payment_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/seller_section_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_and_billing_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/shipping_info_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/order_details_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final bool isNotification;
  final int? orderId;
  final String? phone;
  final bool fromTrack;
  const OrderDetailsScreen({super.key, required this.orderId, this.isNotification = false, this.phone,  this.fromTrack = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {


  void _loadData(BuildContext context) async {
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn() && !widget.fromTrack){
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderDetails(widget.orderId.toString());
      await Provider.of<OrderController>(Get.context!, listen: false).initTrackingInfo(widget.orderId.toString());
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderFromOrderId(widget.orderId.toString());
    }else{
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).trackOrder(orderId: widget.orderId.toString(), phoneNumber: widget.phone);
      await Provider.of<OrderDetailsController>(Get.context!, listen: false).getOrderFromOrderId(widget.orderId.toString());

    }

  }

  @override
  void initState() {
    super.initState();
    if(Provider.of<SplashController>(context, listen: false).configModel == null ){
      Provider.of<SplashController>(context, listen: false).initConfig(context).then((value){
        _loadData(context);
        Provider.of<OrderDetailsController>(context, listen: false).digitalOnly(true);
      });
    }else{
      _loadData(context);
      Provider.of<OrderDetailsController>(context, listen: false).digitalOnly(true);
    }

  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) async{
       if(widget.isNotification){
         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
       }
        return;
      },
      child: Scaffold(
        appBar: AppBar(elevation: 1, backgroundColor: Theme.of(context).cardColor,
            toolbarHeight: 120, leadingWidth: 0, automaticallyImplyLeading: false,
            title: Consumer<OrderDetailsController>(
              builder: (context, orderProvider, _) {
                return (orderProvider.orderDetails != null && orderProvider.orders != null) ?
                const OrderDetailsStatusWidget():const SizedBox();})),

        body: Consumer<SplashController>(
            builder: (context, config, _) {
              return config.configModel != null?
              Consumer<OrderDetailsController>(
                builder: (context, orderProvider, child) {

                  double itemTotalAmount = 0;
                  double discount = 0;
                  double? eeDiscount = 0;
                  double tax = 0;
                  double shippingCost = 0;


                  if (orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty) {
                    if( orderProvider.orderDetails?[0].order?.isShippingFree == 1){
                      shippingCost = 0;
                    }else{
                      shippingCost = orderProvider.orders?.shippingCost??0;
                    }

                    for (var orderDetails in orderProvider.orderDetails!) {
                      if(orderDetails.productDetails?.productType != null && orderDetails.productDetails!.productType != "physical" ){
                        orderProvider.digitalOnly(false, isUpdate: false);
                      }
                    }



                    for (var orderDetails in orderProvider.orderDetails!) {
                      itemTotalAmount = itemTotalAmount + (orderDetails.price! * orderDetails.qty!);
                      discount = discount + orderDetails.discount!;
                      tax = tax + orderDetails.tax!;
                    }


                    if(orderProvider.orders != null && orderProvider.orders!.orderType == 'POS'){
                      if(orderProvider.orders!.extraDiscountType == 'percent'){
                        eeDiscount = itemTotalAmount * (orderProvider.orders!.extraDiscount!/100);
                      }else{
                        eeDiscount = orderProvider.orders!.extraDiscount;
                      }
                    }
                  }


                  return (orderProvider.orderDetails != null && orderProvider.orders != null) ?
                  ListView(padding: const EdgeInsets.all(0), children: [



                    Container(height: 10, color: Theme.of(context).primaryColor.withOpacity(.1)),
                    if(config.configModel?.orderVerification == 1 && orderProvider.orders!.orderType != 'POS')
                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                        child: Center(child: Text.rich(TextSpan(children: [
                          TextSpan(text: '${getTranslated('order_verification_code', context)} : ',
                              style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                          TextSpan(text: orderProvider.orders?.verificationCode??'',
                              style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),])))),


                    ShippingAndBillingWidget(orderProvider: orderProvider),


                    orderProvider.orders != null && orderProvider.orders!.orderNote != null?
                    Padding(padding : const EdgeInsets.all(Dimensions.marginSizeSmall),
                        child: Text.rich(TextSpan(children: [
                          TextSpan(text: '${getTranslated('order_note', context)} : ',
                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.getReviewRattingColor(context))),

                          TextSpan(text:  orderProvider.orders!.orderNote != null? orderProvider.orders!.orderNote ?? '': "",
                              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge?.color)),
                        ]))):const SizedBox(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),



                    SellerSectionWidget(order: orderProvider),


                    if(orderProvider.orders != null)
                      OrderProductListWidget(order: orderProvider, orderType: orderProvider.orders!.orderType,
                        fromTrack: widget.fromTrack,isGuest: orderProvider.orders!.isGuest!,orderId: orderProvider.orders!.id.toString(),),


                    const SizedBox(height: Dimensions.marginSizeDefault),
                    OrderAmountCalculation(orderProvider: orderProvider,itemTotalAmount: itemTotalAmount,discount: discount,eeDiscount: eeDiscount,shippingCost: shippingCost, tax: tax,),




                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    orderProvider.orders!.deliveryMan != null?
                    Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), spreadRadius:2, blurRadius: 10)]),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${getTranslated('shipping_info', context)}', style: robotoBold),
                              CallAndChatWidget(orderProvider: orderProvider, orderModel: orderProvider.orders),
                            ],
                          ),
                          const SizedBox(height: Dimensions.marginSizeExtraSmall),



                          Row( children: [
                            Text('${getTranslated('name', context)} : ',
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),


                            Text((orderProvider.orders!.deliveryMan != null ) ?
                            '${orderProvider.orders?.deliveryMan?.fName} ${orderProvider.orders?.deliveryMan?.lName}':'',
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault))]),

                          const SizedBox(height: 10,),
                          Row( children: [
                            Text('${getTranslated('email', context)} : ',
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),


                            Text((orderProvider.orders!.deliveryMan != null ) ?
                            '${orderProvider.orders?.deliveryMan?.email}':'',
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault))]),

                          const SizedBox(height: Dimensions.paddingSizeDefault),



                        ])):


                    orderProvider.orders!.deliveryServiceName != null?
                    ShippingInfoWidget(order: orderProvider):const SizedBox(),



                    if(orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty &&
                        orderProvider.orderDetails![0].verificationImages != null &&orderProvider.orderDetails![0].verificationImages!.isNotEmpty)
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
                            Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall),
                          child: Text('${getTranslated('picture_uploaded_by', context)} ${orderProvider.orders!.deliveryMan != null?
                          '${orderProvider.orders!.deliveryMan!.fName} ${orderProvider.orders!.deliveryMan!.lName}' : ''}',
                            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),),

                        SizedBox(height: 120,
                          child: ListView.builder(
                              itemCount: orderProvider.orderDetails![0].verificationImages?.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index){
                                return InkWell(onTap: (){
                                    showDialog(context: context, builder: (_)=> ImageDialog(
                                        imageUrl: '${AppConstants.baseUrl}/storage/app/public/delivery-man/verification-image/${orderProvider.orderDetails![0].verificationImages?[index].image}'));
                                  },
                                  child: Padding(padding:  EdgeInsets.only(left: Dimensions.paddingSizeSmall,
                                        right: orderProvider.orderDetails![0].verificationImages!.length == index+1?
                                        Dimensions.paddingSizeSmall : 0),
                                    child: SizedBox(width: 200,
                                      child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                        child: Container(decoration: BoxDecoration(
                                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25), width: .25),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                            child: CustomImageWidget(image: '${AppConstants.baseUrl}/storage/app/public/delivery-man/verification-image/${orderProvider.orderDetails![0].verificationImages?[index].image}')),))));}))]),


                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    PaymentInfoWidget(order: orderProvider),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    CancelAndSupportWidget(orderModel: orderProvider.orders),
                  ],
                  ) : const OrderDetailsShimmer();
                },
              ):const OrderDetailsShimmer();
            }
        )
      ),
    );
  }
}
