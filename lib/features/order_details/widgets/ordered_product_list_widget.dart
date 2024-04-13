import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/widgets/order_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';

class OrderProductListWidget extends StatelessWidget {
  final OrderDetailsController? order;
  final String? orderType;
  final String? orderId;
  final bool fromTrack;
  final int? isGuest;
  const OrderProductListWidget({super.key, this.order, this.orderType,  this.fromTrack = false, this.isGuest, this.orderId});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      itemCount:
      order!.orderDetails!.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => OrderDetailsWidget(orderDetailsModel: order!.orderDetails![i],
          isGuest: isGuest,
          fromTrack: fromTrack,
          callback: () {showCustomSnackBar('${getTranslated('review_submitted_successfully', context)}', context, isError: false);},
          orderType: orderType!, paymentStatus: order!.orders!.paymentStatus!, orderId: orderId!,),
    );
  }
}
