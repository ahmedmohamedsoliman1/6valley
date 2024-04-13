import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/domain/models/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';


class OrderWidget extends StatelessWidget {
  final Orders? orderModel;
  const OrderWidget({super.key, this.orderModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: orderModel!.id)));},

      child: Stack(children: [
          Container(margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall,
              left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow:  [BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 82,height: 82,
                  child: Column(children: [
                    Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(.25)),
                      boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme? null :[BoxShadow(color: Colors.grey.withOpacity(.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 1))],),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        child: CustomImageWidget(
                          placeholder: Images.placeholder, fit: BoxFit.scaleDown, width: 70, height: 70,
                          image: '${Provider.of<SplashController>(context, listen: false).configModel?.baseUrls?.shopImageUrl}/${orderModel?.seller?.shop?.image}',
                          )),),]),),
                const SizedBox(width: Dimensions.paddingSizeLarge),



                Expanded(flex: 5,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text('${getTranslated('order', context)!}# ${orderModel!.id.toString()}',
                          style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, fontWeight: FontWeight.bold)))]),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(DateConverter.localDateToIsoStringAMPMOrder(DateTime.parse(orderModel!.createdAt!)),
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text(PriceConverter.convertPrice(context, orderModel!.orderAmount),
                      style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: ColorResources.getPrimary(context)),),])),



                Container(alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: orderModel!.orderStatus == 'delivered'? ColorResources.getGreen(context).withOpacity(.10) :
                      orderModel!.orderStatus == 'pending'? Theme.of(context).primaryColor.withOpacity(.10) :
                      orderModel!.orderStatus == 'confirmed'? ColorResources.getGreen(context).withOpacity(.10)
                          :orderModel!.orderStatus == 'processing'? ColorResources.getPurple(context).withOpacity(.10):
                      orderModel!.orderStatus == 'canceled'? ColorResources.getRed(context).withOpacity(.10):
                      ColorResources.getYellow(context).withOpacity(.1), borderRadius: BorderRadius.circular(50)),

                    child: Text(getTranslated('${orderModel!.orderStatus}', context)??'',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall, fontWeight: FontWeight.w500,
                      color: orderModel!.orderStatus == 'delivered'?  ColorResources.getGreen(context) :
                      orderModel!.orderStatus == 'pending'? Theme.of(context).primaryColor :
                      orderModel!.orderStatus == 'confirmed'? ColorResources.getGreen(context)
                          :orderModel!.orderStatus == 'processing'? ColorResources.getPurple(context) :
                      (orderModel!.orderStatus == 'canceled' || orderModel!.orderStatus == "failed")? ColorResources.getRed(context) :
                      ColorResources.getYellow(context)))),

              ]),
            ),
          ),

          Positioned(top: 2, left: Provider.of<LocalizationController>(context, listen: false).isLtr? 90 : MediaQuery.of(context).size.width-50, child: Container(padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Text("${orderModel?.orderDetailsCount}", style: textRegular.copyWith(color: Colors.white)))),
        ],
      ),
    );
  }
}
