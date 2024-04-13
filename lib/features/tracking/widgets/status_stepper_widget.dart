import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/tracking/widgets/line_dashed_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class StatusStepperWidget extends StatelessWidget {
  final String? title;
  final bool isLastItem;
  final String icon;
  final bool checked;
  final String? dateTime;
  const StatusStepperWidget({super.key, required this.title,
    this.isLastItem = false, required this.icon, this.checked = false, this.dateTime});

  @override
  Widget build(BuildContext context) {
    Color myColor;
    if (checked) {
      myColor = Provider.of<ThemeController>(context, listen: false).darkTheme? Colors.white  : Theme.of(context).primaryColor;
    } else {
      myColor = Provider.of<ThemeController>(context, listen: false).darkTheme? Theme.of(context).hintColor.withOpacity(.75) :
      Theme.of(context).hintColor;
    }
    return Container(height: 100,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [

              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                        color: Theme.of(context).primaryColor.withOpacity(.075)),
                    child: SizedBox(height: 30,child: Image.asset(icon, color: myColor)),)),

              Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

                checked?
                Text(title!, style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)):
                Text(title!, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor)),

                if(dateTime != null)
                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    child: Row(children: [
                      SizedBox(height: 20, child: Image.asset(Images.dateTimeIcon)),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(DateConverter.dateTimeStringToDateAndTime(dateTime!), style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ]))])]),

            isLastItem ? const SizedBox.shrink() :
            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, left: 35),
                child: CustomPaint(painter: LineDashedWidget(myColor)))])),


        if(checked)
          Padding(padding: const EdgeInsets.all(8.0),
              child: SizedBox(child: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Theme.of(context).primaryColor))),

      ],
      ),
    );
  }
}