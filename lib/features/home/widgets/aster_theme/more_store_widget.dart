import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/more_store_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:provider/provider.dart';
class MoreStoreWidget extends StatefulWidget {
  final MoreStoreModel moreStore;
  final int index;
  final int length;
  final bool fromHomePage;
  const MoreStoreWidget({super.key, required this.moreStore, required this.index, required this.length,  this.fromHomePage  = false});

  @override
  State<MoreStoreWidget> createState() => _MoreStoreWidgetState();
}

class _MoreStoreWidgetState extends State<MoreStoreWidget> {
  bool vacationIsOn = false;
  @override
  Widget build(BuildContext context) {

    if(widget.moreStore.shop!.vacationEndDate != null){
      DateTime vacationDate = DateTime.parse(widget.moreStore.shop!.vacationEndDate!);
      DateTime vacationStartDate = DateTime.parse(widget.moreStore.shop!.vacationStartDate!);
      final today = DateTime.now();
      final difference = vacationDate.difference(today).inDays;
      final startDate = vacationStartDate.difference(today).inDays;

      if(difference >= 0 && widget.moreStore.shop!.vacationStatus! && startDate <= 0){
        vacationIsOn = true;
      } else{
        vacationIsOn = false;
      }

    }


    return InkWell(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => TopSellerProductScreen(
        sellerId: widget.moreStore.id,
        temporaryClose: widget.moreStore.shop?.temporaryClose??false,
        vacationStatus: widget.moreStore.shop?.vacationStatus??false,
        vacationEndDate: widget.moreStore.shop?.vacationEndDate,
        vacationStartDate: widget.moreStore.shop?.vacationStartDate,
        name: widget.moreStore.shop?.name,
        banner: widget.moreStore.shop?.banner,
        image: widget.moreStore.shop?.image,)));
    },
      child: Center(child: Padding(padding: widget.fromHomePage?
      EdgeInsets.only(left : Provider.of<LocalizationController>(context, listen: false).isLtr ?
      Dimensions.paddingSizeSmall : 0, right: widget.index+1 == widget.length? Dimensions.paddingSizeDefault :
      Provider.of<LocalizationController>(context, listen: false).isLtr ? 0 : Dimensions.paddingSizeDefault):
      const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        child: Column( children: [Stack(children: [
          Center(child: Container(height: MediaQuery.of(context).size.width /6.6, width: MediaQuery.of(context).size.width /6.6,
              decoration: BoxDecoration(border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.125),width: .25),
                  borderRadius: BorderRadius.circular(30), color: Theme.of(context).primaryColor.withOpacity(.125)),
              child: ClipRRect(borderRadius: BorderRadius.circular(30),
                  child: CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls!.shopImageUrl}'
                      '/${widget.moreStore.shop?.image}'))),),


          if(widget.moreStore.shop!.temporaryClose!  || vacationIsOn)
            Center(
              child: Container(height: MediaQuery.of(context).size.width/6.6, width:  MediaQuery.of(context).size.width/6.6,
                decoration: BoxDecoration(color: Colors.black.withOpacity(.5),
                borderRadius: const BorderRadius.all(Radius.circular(30)))),
            ),

          widget.moreStore.shop!.temporaryClose!?
          Positioned(top: 0,left: 0,right: 0,bottom: 0,
            child: Align(alignment : Alignment.center, child: Text(getTranslated('temporary_closed', context)!, textAlign: TextAlign.center,
              style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),)),
          ):
          vacationIsOn?
          Positioned(top: 0,left: 0,right: 0,bottom: 0,
            child: Align(alignment: Alignment.center, child: Text(getTranslated('close_for_now', context)!, textAlign: TextAlign.center,
              style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),)),
          ): const SizedBox()
        ],),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Center(child: SizedBox(width: 70,
            child: Text(widget.moreStore.shop?.name??'', textAlign: TextAlign.center, maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                    color: ColorResources.getTextTitle(context))),
          ),
          ),

        ]),
      ),
      ),
    );
  }
}