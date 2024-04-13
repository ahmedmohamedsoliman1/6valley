import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/wallet_bonus_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wallet/controllers/wallet_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class WalletBonusWidget extends StatelessWidget {
  const WalletBonusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top : Dimensions.paddingSizeSmall, bottom: 50),
        child: Consumer<WalletController>(builder: (context, walletProvider, _) {
          return walletProvider.walletBonusModel != null ?
          (walletProvider.walletBonusModel!.bonusList != null && walletProvider.walletBonusModel!.bonusList!.isNotEmpty)?
          Stack(clipBehavior: Clip.none, children: [
            ClipRRect(borderRadius: BorderRadius.circular(8),
              child: CarouselSlider.builder(options: CarouselOptions(
                  viewportFraction: 1, aspectRatio: 2,
                  autoPlay: true, padEnds: false,
                  onPageChanged: (index, reason) {walletProvider.setCurrentIndex(index);}),
                itemCount: walletProvider.walletBonusModel?.bonusList?.length,
                itemBuilder: (context, index, _) {
                  return Stack(children: [
                    Align(alignment: Alignment.centerRight,
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                            child: Image.asset(Images.walletBonus))),
                    Container(width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(width: .75, color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                            Theme.of(context).hintColor.withOpacity(.5) : Theme.of(context).primaryColor.withOpacity(.5))),
                        child:  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${walletProvider.walletBonusModel?.bonusList?[index].title}',
                                  style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                      color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                      Theme.of(context).hintColor : Theme.of(context).primaryColor)),
                              if(walletProvider.walletBonusModel!.bonusList![index].endDateTime != null)
                                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text('${getTranslated('valid_till', context)} '
                                      '${DateConverter.dateTimeStringToDateTime(walletProvider.walletBonusModel!.bonusList![index].endDateTime!)}',
                                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),),


                              walletProvider.walletBonusModel!.bonusList![index].bonusType == 'fixed'?
                              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Text('${getTranslated('add_fund_to_wallet', context)} '
                                    '${PriceConverter.convertPrice(context, walletProvider.walletBonusModel!.bonusList![index].minAddMoneyAmount)} '
                                    '${getTranslated('and', context)} ${getTranslated('enjoy', context)} '
                                    '${PriceConverter.convertPrice(context, walletProvider.walletBonusModel!.bonusList![index].bonusAmount)} '
                                    '${getTranslated('bonus', context)}'),):
                              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Text('${getTranslated('add_fund_to_wallet', context)} '
                                    '${PriceConverter.convertPrice(context, walletProvider.walletBonusModel!.bonusList![index].minAddMoneyAmount)} '
                                    '${getTranslated('and', context)} ${getTranslated('enjoy', context)} '
                                    '${walletProvider.walletBonusModel!.bonusList![index].bonusAmount}% '
                                    '${getTranslated('bonus', context)}'),),



                              Text('${walletProvider.walletBonusModel?.bonusList?[index].description}',
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                      color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                      Theme.of(context).hintColor : Theme.of(context).primaryColor)),],),
                        )),
                  ],);},
              )),



            Positioned(bottom: -45, right: 0, left: 0, child: Center(child: SizedBox(height: 50,
              child: ListView.builder(padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: walletProvider.walletBonusModel?.bonusList?.length,
                  itemBuilder: (context, index){
                    return Container(width: index == walletProvider.currentIndex ?
                    Dimensions.radiusDefault : Dimensions.radiusSmall,
                      height: index == walletProvider.currentIndex ? Dimensions.radiusDefault : Dimensions.radiusSmall,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: (index == walletProvider.currentIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor)),
                    );
                  }),
            )))]):const SizedBox():const WalletBonusListShimmer();
        }));
  }
}
