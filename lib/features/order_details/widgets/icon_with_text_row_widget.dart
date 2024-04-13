import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class IconWithTextRowWidget extends StatelessWidget {


  final String text;
  final IconData icon;
  final String? imageIcon;
  final Color? iconColor;
  final Color? textColor;
  final bool isTitle;
  const IconWithTextRowWidget({super.key, required this.text, required this.icon, this.iconColor, this.textColor, this.isTitle =false, this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      imageIcon != null? Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(width: 17,child: Image.asset(imageIcon!, color: Theme.of(context).primaryColor.withOpacity(.5),)),
      ):
        Icon(icon, color:  Provider.of<ThemeController>(context, listen: false).darkTheme?
        Colors.white : Theme.of(context).primaryColor.withOpacity(.30), size: Dimensions.iconSizeDefault,),
        const SizedBox(width: Dimensions.marginSizeSmall,),

        Expanded(child: Text(maxLines: 2, overflow : TextOverflow.ellipsis,
              text, style: titilliumRegular.copyWith(fontSize: isTitle? Dimensions.fontSizeLarge : Dimensions.fontSizeDefault,
                  color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color)))
    ]);
  }
}
