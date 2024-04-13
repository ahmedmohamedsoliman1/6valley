import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/how_to_use_dialog_widget.dart';
import 'package:provider/provider.dart';

class LoyaltyPointConverterDialogueWidget extends StatefulWidget {
  final double? myPoint;
  const LoyaltyPointConverterDialogueWidget({super.key, this.myPoint});
  @override
  State<LoyaltyPointConverterDialogueWidget> createState() => _LoyaltyPointConverterDialogueWidgetState();
}

class _LoyaltyPointConverterDialogueWidgetState extends State<LoyaltyPointConverterDialogueWidget> {
  double convertPointAmount = 0;
  final TextEditingController _convertPointAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double? exchangeRate = Provider.of<SplashController>(context,listen: false).configModel!.loyaltyPointExchangeRate;
    int? min = Provider.of<SplashController>(context,listen: false).configModel!.loyaltyPointMinimumPoint;

    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(alignment: Alignment.topRight,
          child: InkWell(onTap: ()=> Navigator.pop(context),
            child: Padding(padding: const EdgeInsets.only(right : Dimensions.paddingSizeSmall, top: Dimensions.paddingSizeSmall),
              child: Container(decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).hintColor),
                padding: const EdgeInsets.all(3), child: const Icon(Icons.clear, size: 15))))),
        const SizedBox(height: Dimensions.paddingSizeSmall),


        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            color: Theme.of(context).cardColor),
          width: MediaQuery.of(context).size.width * 0.90,
          padding: const EdgeInsets.all(Dimensions.homePagePadding),
          child: Column(children: [
            Text('${getTranslated('enter_point_amount', context)}',
                style: textRegular.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: Dimensions.paddingSizeSmall),

              Card(elevation: 1, margin: EdgeInsets.zero,
                child: Padding(padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text('${getTranslated('convert_point_to_wallet_money', context)}',
                        style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    CustomTextFieldWidget(
                      controller: _convertPointAmountController,
                      hintText: '0',
                      textAlign: TextAlign.center,
                      showLabelText: false,
                      isAmount: false,
                      inputType: TextInputType.number,
                      onChanged: (value){
                        setState(() => convertPointAmount = double.parse(value)/exchangeRate!);}),

                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Text('${getTranslated('converted_amount', context)} = ${PriceConverter.convertPrice(context, convertPointAmount)}',
                        style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400)),
                    const SizedBox(height: Dimensions.paddingSizeSmall)]))),


              const SizedBox(height: Dimensions.paddingSizeSmall),

              Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).primaryColor.withOpacity(0.1)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${getTranslated('note', context)}:',
                        style: textRegular.copyWith(color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    PointWithTextWidget(pointColor: ColorResources.getTextTitle(context),
                        text: '${getTranslated('minimum_exchange_point_is', context)} $min'),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    PointWithTextWidget(pointColor: ColorResources.getTextTitle(context),
                        text: getTranslated('note_point_one', context)!),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    PointWithTextWidget(pointColor: ColorResources.getTextTitle(context),
                        text: '$exchangeRate ${getTranslated('note_point_two', context)} '
                            '${PriceConverter.convertPrice(context, 1)}'),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                    PointWithTextWidget(pointColor: ColorResources.getTextTitle(context),
                        text: getTranslated('note_point_three', context)!),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    PointWithTextWidget(pointColor: ColorResources.getTextTitle(context),
                        text: getTranslated('note_point_four', context)!),
                    const SizedBox(height: Dimensions.paddingSizeSmall)])),
              const SizedBox(height: 40),


              Consumer<LoyaltyPointController>(
                  builder: (context, convert,_) {
                    return convert.isConvert?
                    Container(width: 30,height: 30,color: Theme.of(context).cardColor,
                      child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):
                    SizedBox(width: MediaQuery.of(context).size.width * 0.57,
                      child: CustomButton(leftIcon: Images.dollarIcon,
                        buttonText: '${getTranslated('convert_to_currency', context)}',
                        isBorder: true,
                        onTap: (){
                          int point = int.parse(_convertPointAmountController.text.trim());
                          if(point < min!){
                            Navigator.pop(context);
                            showCustomSnackBar('${getTranslated('minimum_point_is', context)!} $min', context, isToaster: true);
                          }
                          else if(point.toDouble() > widget.myPoint!){
                            Navigator.pop(context);
                            showCustomSnackBar(getTranslated('insufficient_point', context), context);}
                          else{
                            convert.convertPointToCurrency(context ,point).then((value){
                              Navigator.pop(context);
                              Provider.of<ProfileController>(context, listen: false).getUserInfo(context);
                              convert.getLoyaltyPointList(context,1);});}},),);}),


            const SizedBox(height: Dimensions.paddingSizeLarge),
            ],
          ),
        ),
      ],
      ),
    );
  }
}
