import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

const titilliumRegular = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 12,
);
const titleRegular = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontWeight: FontWeight.w500,
  fontSize: 14,

);
const titleHeader = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontWeight: FontWeight.w600,
  fontSize: 16,

);
const titilliumSemiBold = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const titilliumBold = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);
const titilliumItalic = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 14,
  fontStyle: FontStyle.italic,
);

const textRegular = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontWeight: FontWeight.w300,
  fontSize: 14,
);

const textMedium = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 14,
  fontWeight: FontWeight.w500
);
const textBold = TextStyle(
    fontFamily: 'SF-Pro-Rounded-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600
);

const robotoBold = TextStyle(
  fontFamily: 'SF-Pro-Rounded-Regular',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);


class ThemeShadow {
  static List <BoxShadow> getShadow(BuildContext context) {
    List<BoxShadow> boxShadow =  [BoxShadow(color: Provider.of<ThemeController>(context, listen: false).darkTheme? Colors.black26:
    Theme.of(context).primaryColor.withOpacity(.075), blurRadius: 5,spreadRadius: 1,offset: const Offset(1,1))];
    return boxShadow;
  }
}