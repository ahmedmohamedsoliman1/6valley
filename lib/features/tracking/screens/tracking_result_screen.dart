import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/widgets/status_stepper_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

class TrackingResultScreen extends StatefulWidget {
  final String orderID;
  const TrackingResultScreen({super.key, required this.orderID});

  @override
  State<TrackingResultScreen> createState() => _TrackingResultScreenState();
}

class _TrackingResultScreenState extends State<TrackingResultScreen> {
  @override
  void initState() {
    Provider.of<OrderController>(context, listen: false).initTrackingInfo(widget.orderID);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<String> statusList = ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered'];


    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('TRACK_ORDER', context)),
      body: Column(children: [


          Expanded(child: Consumer<OrderController>(
              builder: (context, tracking, child) {
                String? status = tracking.trackingModel != null ? tracking.trackingModel!.orderStatus : '';
                return tracking.trackingModel != null?
                ListView( children: [

                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Center(child: RichText(text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: '${getTranslated('your_order', context)}',
                              style: textBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                          TextSpan(text: '  #${widget.orderID}',
                              style: textBold.copyWith(color: Theme.of(context).primaryColor))])))),

                  StatusStepperWidget(title: getTranslated('order_placed', context), icon: Images.orderIdIcon, checked: true,
                      dateTime: tracking.trackingModel!.createdAt),


                  StatusStepperWidget(title: '${getTranslated('order_confirmed', context)}', icon: Images.orderConfirmedIcon,
                    checked: (status == statusList[1] || status == statusList[2] || status == statusList[3] ||status == statusList[4])),


                  StatusStepperWidget(icon: Images.shipment, title: '${getTranslated('preparing_for_shipment', context)}',
                    checked: (status == statusList[2] || status == statusList[3] ||status == statusList[4])),


                  StatusStepperWidget(icon: Images.outForDeliveryIcon, title: '${getTranslated('order_is_on_the_way', context)}',
                    checked: (status == statusList[3] ||status == statusList[4])),

                  StatusStepperWidget(icon: Images.deliveredIcon, title: '${getTranslated('order_delivered', context)}',
                      checked: (status == statusList[4]), isLastItem: true),
                ],
                ): const Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
        ],
      ),
    );
  }
}


