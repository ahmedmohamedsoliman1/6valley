import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class ShippingInfoWidget extends StatelessWidget {
  final OrderDetailsController? order;
  const ShippingInfoWidget({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${getTranslated('shipping_info', context)}', style: robotoBold),
            const SizedBox(height: Dimensions.marginSizeExtraSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${getTranslated('delivery_service_name', context)} : ',
                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

              Text((order!.orders!.deliveryServiceName != null &&
                  order!.orders!.deliveryServiceName!.isNotEmpty) ?
                  order!.orders!.deliveryServiceName!:'',
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall))]),
            const SizedBox(height: Dimensions.marginSizeExtraSmall),


            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${getTranslated('tracking_id', context)} : ',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

                  Text(order!.orders!.thirdPartyDeliveryTrackingId != null ?
                  order!.orders!.thirdPartyDeliveryTrackingId! : '',
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                ]),
          ]),
    );
  }
}
