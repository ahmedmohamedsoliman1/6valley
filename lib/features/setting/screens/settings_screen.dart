import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/setting/widgets/select_language_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_expanded_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/setting/widgets/select_currency_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Provider.of<SplashController>(context, listen: false).setFromSetting(true);

    return PopScope(
      onPopInvoked: (val) {
        Provider.of<SplashController>(context, listen: false).setFromSetting(false);
        return;
      },
      child: CustomExpandedAppBarWidget(title: getTranslated('settings', context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge,
                left: Dimensions.paddingSizeLarge),
              child: Text(getTranslated('settings', context)!,
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge))),

            Expanded(child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
              children: [
                SwitchListTile(value: Provider.of<ThemeController>(context).darkTheme,
                  onChanged: (bool isActive) =>Provider.of<ThemeController>(context, listen: false).toggleTheme(),
                  title: Text(getTranslated('dark_theme', context)!,
                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),),

                TitleButton(image: Images.language,
                  title: getTranslated('choose_language', context),
                  onTap: () => showModalBottomSheet(backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context, builder: (_)=> const SelectLanguageBottomSheetWidget())),

                TitleButton(image: Images.currency,
                  title: '${getTranslated('currency', context)} (${Provider.of<SplashController>(context).myCurrency!.name})',
                    onTap: () => showModalBottomSheet(backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context, builder: (_)=> const SelectCurrencyBottomSheetWidget())
                ),
              ],
        )),

      ])),
    );
  }

}

class TitleButton extends StatelessWidget {
  final String image;
  final String? title;
  final Function onTap;
  const TitleButton({super.key, required this.image, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill, color: ColorResources.getPrimary(context)),
      title: Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: onTap as void Function()?,
    );
  }
}

