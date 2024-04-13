import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class DeliveryChatItemWidget extends StatefulWidget {
  final Chat? chat;
  final ChatController chatProvider;
  const DeliveryChatItemWidget({super.key, this.chat, required this.chatProvider});

  @override
  State<DeliveryChatItemWidget> createState() => DeliveryChatItemWidgetState();
}

class DeliveryChatItemWidgetState extends State<DeliveryChatItemWidget> {
  String? baseUrl = '', image = '', call = '', name = '';
  int? id;
  bool vacationIsOn = false;
  @override
  void initState() {
    baseUrl = widget.chatProvider.userTypeIndex == 0 ?
    Provider.of<SplashController>(context, listen: false).baseUrls!.shopImageUrl:
    Provider.of<SplashController>(context, listen: false).baseUrls!.deliveryManImageUrl;

    image = widget.chatProvider.userTypeIndex == 0 ?
    widget.chat!.sellerInfo != null? widget.chat!.sellerInfo?.shops![0].image :'' : widget.chat!.deliveryMan?.image??'';

    call = widget.chatProvider.userTypeIndex == 0 ?
    '' : '${widget.chat!.deliveryMan?.code}${widget.chat!.deliveryMan?.phone}';

    id = widget.chatProvider.userTypeIndex == 0 ?
    widget.chat!.sellerId : widget.chat!.deliveryManId;
    name = widget.chatProvider.userTypeIndex == 0 ?
    widget.chat!.sellerInfo != null ? widget.chat!.sellerInfo!.shops![0].name??'' :
    'Shop not found': "${widget.chat!.deliveryMan?.fName??''} ${widget.chat!.deliveryMan?.lName??''}";




    if(widget.chatProvider.userTypeIndex == 0){
      if (widget.chat?.sellerInfo!.shops![0].vacationEndDate != null) {
        DateTime vacationDate = DateTime.parse(widget.chat!.sellerInfo!.shops![0].vacationEndDate!);
        DateTime vacationStartDate = DateTime.parse(widget.chat!.sellerInfo!.shops![0].vacationStartDate!);
        final today = DateTime.now();
        final difference = vacationDate.difference(today).inDays;
        final startDate = vacationStartDate.difference(today).inDays;

        if ((difference >= 0 && widget.chat!.sellerInfo!.shops![0].vacationStatus! && startDate <= 0)|| widget.chat!.sellerInfo!.shops![0].temporaryClose!) {
          vacationIsOn = true;
        } else {
          vacationIsOn = false;
        }
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Consumer<ChatController>(
        builder: (context, chatController,_) {
          return InkWell( onTap: (){
            chatController.seenMessage( context, id,id,);
            if(name!.trim().isEmpty || name == 'Shop not found' || name!.trim()==''){
              showCustomSnackBar(getTranslated('user_account_was_deleted', context), context);
            }else if(widget.chatProvider.userTypeIndex == 0 && vacationIsOn){
              showCustomSnackBar(getTranslated('this_shop_is_close_now', context), context);
            }else{
              Navigator.push(Get.context!, MaterialPageRoute(builder: (_) =>
                  ChatScreen(id: id, name: name, image: '$baseUrl/$image',
                      isDelivery: widget.chatProvider.userTypeIndex == 1, phone: call)));
            }
          },
            child: Container(decoration: BoxDecoration(
                color: (widget.chat!.unseenMessageCount != null && widget.chat!.unseenMessageCount! > 0)?
                Theme.of(context).primaryColor.withOpacity(.05) : Theme.of(context).cardColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeDefault),
                child: Row(children: [

                  Stack(children: [
                    Container(width: 70,height: 70,decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25),width: .5),
                        borderRadius: BorderRadius.circular(100)),
                        child: ClipRRect(borderRadius: BorderRadius.circular(100),
                            child: CustomImageWidget(image: '$baseUrl/$image',
                                height: 50,width: 50, fit: BoxFit.cover))),

                    if(vacationIsOn)
                      Container(width: 70,height: 70,decoration: BoxDecoration(
                          color: Colors.black54.withOpacity(.65),
                          borderRadius: BorderRadius.circular(100)),
                          child: ClipRRect(borderRadius: BorderRadius.circular(100),
                              child: Center(child: Text(getTranslated("close", context)??'',
                                style: textMedium.copyWith(color: Colors.white),))))

                  ],
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),
                  Expanded(child: Column(children: [

                    Row(children: [

                      Expanded(child: Text(name??'', style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault))),

                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text(DateConverter.inboxLocalDateToIsoStringAMPM(DateTime.parse(widget.chat!.createdAt!)),
                          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).hintColor)),
                    ],),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Row(children: [
                      Expanded(child: Text(widget.chat!.message??'Attachment', maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                      ),


                      if(widget.chat!.unseenMessageCount != null && widget.chat!.unseenMessageCount! > 0)
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                      if(widget.chat!.unseenMessageCount != null && widget.chat!.unseenMessageCount! > 0)
                        CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
                            child: Text('${widget.chat!.unseenMessageCount}', style: textRegular.copyWith(
                                color: Colors.white, fontSize: Dimensions.fontSizeSmall)))
                    ],),

                  ],
                  ),
                  ),
                ],
                ),
              ),
            ),
          );
        }
    );
  }
}
