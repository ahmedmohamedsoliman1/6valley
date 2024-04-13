import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/domain/models/shipping_method_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/shipping/controllers/shipping_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

class ShippingMethodBottomSheetWidget extends StatefulWidget {
  final String? groupId;
  final int? sellerId;
  final int sellerIndex;
  const ShippingMethodBottomSheetWidget({super.key, required this.groupId, required this.sellerId, required this.sellerIndex});

  @override
  ShippingMethodBottomSheetWidgetState createState() => ShippingMethodBottomSheetWidgetState();
}

class ShippingMethodBottomSheetWidgetState extends State<ShippingMethodBottomSheetWidget> {
  int selectedIndex = 0;
  @override
  void initState() {
    if(Provider.of<ShippingController>(context, listen: false).shippingList != null &&
        Provider.of<ShippingController>(context, listen: false).shippingList!.isNotEmpty){
      selectedIndex = Provider.of<ShippingController>(context, listen: false).shippingList![widget.sellerIndex].shippingIndex??0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 50.0),
      child: Container(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.paddingSizeDefault), ),),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(onTap: () => Navigator.pop(context),
              child: Container(width: 40,height: 5,decoration: BoxDecoration(color: Theme.of(context).hintColor.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20)))),
            const SizedBox(height: 20,),
            Text(getTranslated('select_shipping_method', context)!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeLarge),
              child: Text('${getTranslated('choose_a_method_for_your_delivery', context)}'),),


            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Consumer<ShippingController>(
                builder: (context, shippingController, child) {
                  return shippingController.isLoading ? const Center(child: CircularProgressIndicator()) :
                    (shippingController.shippingList != null && shippingController.shippingList!.isNotEmpty &&
                      shippingController.shippingList![widget.sellerIndex].shippingMethodList != null) ?
                  ( shippingController.shippingList![widget.sellerIndex].shippingMethodList!.isNotEmpty) ?
                  Column(mainAxisSize: MainAxisSize.min, children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shippingController.shippingList![widget.sellerIndex].shippingMethodList!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25),width: .5),
                              color: selectedIndex == index? Theme.of(context).primaryColor.withOpacity(.1): Theme.of(context).cardColor),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Padding(padding: const EdgeInsets.all(8.0),
                                  child: Row(children: [
                                    selectedIndex == index?
                                    const Icon(Icons.check_circle, color: Colors.green,): Icon(Icons.circle_outlined,
                                      color: Theme.of(context).hintColor,),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                    Expanded(child: Text('${shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].title}'
                                        ' (Duration ${shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].duration})'),),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    Text(' ${PriceConverter.convertPrice(context, shippingController.shippingList![widget.sellerIndex].shippingMethodList![index].cost)}',
                                      style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge))])))
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    CustomButton(buttonText: '${getTranslated('select', context)}', onTap: (){
                      Provider.of<ShippingController>(context, listen: false).setSelectedShippingMethod(selectedIndex, widget.sellerIndex);
                      ShippingMethodModel shipping = ShippingMethodModel();
                      shipping.id = shippingController.shippingList![widget.sellerIndex].shippingMethodList![selectedIndex].id;
                      shipping.duration = widget.groupId;
                      shippingController.isLoading ? const Center(child: CircularProgressIndicator()) :
                      shippingController.addShippingMethod(context, shipping.id, shipping.duration);
                    })]) :
                  const Center(child: Text('No method available')) : const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
