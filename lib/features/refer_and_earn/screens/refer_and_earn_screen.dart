import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/refer_and_earn/widgets/refer_hint_view.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final tooltipController = JustTheController();
  @override
  Widget build(BuildContext context) {
    var profileController = Provider.of<ProfileController>(context, listen: false);
    final List<String> shareItem = [Images.share];
    final List<String> hintList = [getTranslated("invite_your_friends", context)??"",
      '${getTranslated('they_register', context)} ${AppConstants.appName} ${getTranslated('with_special_offer', context)}',
      '${getTranslated('you_made_your_earning', context)}'];
    return Scaffold(
      appBar: CustomAppBar(title: '${getTranslated('refer_and_earn', context)}'),
      body: Stack(children: [
        Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Column(children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
                  child: Image.asset(Images.referAndEarn, height: MediaQuery.of(context).size.height * 0.2)),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Text('${getTranslated('invite_friend_and_businesses', context)}',
                  textAlign: TextAlign.center, style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Text('${getTranslated('copy_your_code', context)}',
                  textAlign: TextAlign.center, style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault)),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              Text('${getTranslated('your_personal_code', context)}', textAlign: TextAlign.center,
                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                    color:  Provider.of<ThemeController>(context, listen: false).darkTheme?
                    Theme.of(context).hintColor: Theme.of(context).primaryColor.withOpacity(.5)),),
              const SizedBox(height: Dimensions.paddingSizeLarge,),

              DottedBorder(padding: const EdgeInsets.all(3), borderType: BorderType.RRect,
                  radius: const Radius.circular(20), dashPattern: const [5, 5],
                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                  Colors.grey : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  strokeWidth: 1,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Text(Provider.of<ProfileController>(context, listen: false).userInfoModel?.referCode??'',
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)))),

                    JustTheTooltip(
                      backgroundColor: Colors.black87,
                      controller: tooltipController,
                      preferredDirection: AxisDirection.down,
                      tailLength: 10,
                      tailBaseWidth: 20,
                      content: Container(width: 90,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: Text(getTranslated('copied', context)!,
                              style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault))),
                      child: GestureDetector(onTap: () async {
                        tooltipController.showTooltip();
                        await Clipboard.setData(ClipboardData(text: profileController.userInfoModel?.referCode??''));
                      },
                          child: Container(width: 85, height: 40, alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(60)),
                              child: Text('${getTranslated('copy', context)}', style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge, color: Colors.white.withOpacity(0.9))))),
                    )
                  ])),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              Text('${getTranslated('or_share', context)}',
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,),

              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: shareItem.map((item) => GestureDetector(
                        onTap: () => Share.share('Greetings, ${AppConstants.appName} is the best e-commerce platform in the country. If you are new to this website don’t forget to use "${Provider.of<ProfileController>(context, listen: false).userInfoModel?.referCode??''}" as the referral code while sign up into  ${AppConstants.appName}. ${'${Provider.of<SplashController>(context, listen: false).configModel?.refSignup}${Provider.of<ProfileController>(context, listen: false).userInfoModel?.referCode??''}'}',),
                        child: Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          child: Image.asset(item, height: 45, width: 45),),
                      )).toList()))])),

        DraggableScrollableSheet(
          initialChildSize: 0.1,
          maxChildSize: (hintList.length + 1.0) * 0.1,
          minChildSize: 0.1,
          builder: (context, scrollController) => ListView.builder(
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return ReferHintView(hintList: hintList);
            },
          ),
        ),
        ],
      ),
    );
  }
}
