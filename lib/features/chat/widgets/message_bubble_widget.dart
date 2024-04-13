import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/widgets/chatting_multi_image_slider.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/image_diaglog_widget.dart';
import 'package:provider/provider.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message message;
  final Message? previous;
  const MessageBubbleWidget({super.key, required this.message, this.previous});

  @override
  Widget build(BuildContext context) {

    if(previous != null){
      if(previous?.sentBySeller == message.sentBySeller){
      }else{
      }
    }

    bool isMe = message.sentByCustomer!;
    String? baseUrl = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    Provider.of<SplashController>(context, listen: false).baseUrls!.shopImageUrl:
    Provider.of<SplashController>(context, listen: false).baseUrls!.deliveryManImageUrl;
    String? image = Provider.of<ChatController>(context, listen: false).userTypeIndex == 0 ?
    message.sellerInfo != null? message.sellerInfo?.shops![0].image :'' : message.deliveryMan?.image;

    return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
            isMe ? const SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Container( width: 40, height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Theme.of(context).primaryColor)),
                child: ClipRRect(borderRadius: BorderRadius.circular(20.0),
                  child: CustomImageWidget(fit: BoxFit.cover, width: 40, height: 40, image: '$baseUrl/$image'))),
            ),


            if(message.message != null && message.message!.isNotEmpty)
            Flexible(child: Container(
              margin: isMe ?  const EdgeInsets.fromLTRB(70, 5, 10, 5) : const EdgeInsets.fromLTRB(10, 5, 70, 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    bottomLeft: isMe ? const Radius.circular(10) : const Radius.circular(0),
                    bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(10),
                    topRight: const Radius.circular(10),),
                      color: isMe ? ColorResources.getImageBg(context) : ColorResources.chattingSenderColor(context)),
                  child: (message.message != null && message.message!.isNotEmpty) ? Text(message.message!,
                      textAlign: TextAlign.justify,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                          color : isMe? Colors.white: Theme.of(context).textTheme.bodyLarge?.color)) :
                  const SizedBox.shrink()))]),

      if(message.attachment!.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
      message.attachment!.isNotEmpty?
      Directionality(textDirection:Provider.of<LocalizationController>(context, listen: false).isLtr ? isMe ?
      TextDirection.rtl : TextDirection.ltr : isMe ? TextDirection.ltr : TextDirection.rtl,
        child: SizedBox(width: MediaQuery.of(context).size.width/3,
          child: Stack(children: [
              GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1, crossAxisCount: 2,
                  mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: message.attachment!.length> 4? 4: message.attachment!.length,
                itemBuilder: (BuildContext context, index) {
                  return  InkWell(onTap: () {
                    if(message.attachment?.length == 1){
                      showDialog(context: context, builder: (ctx)  =>  ImageDialog(
                          imageUrl: '${AppConstants.baseUrl}/storage/app/public/chatting/${message.attachment![index]}'));
                    }else{
                      showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                          images: message.attachment??[]));
                    }
                  },
                    child: ClipRRect(borderRadius: BorderRadius.circular(5),
                        child:CustomImageWidget(height: 100, width: 100, fit: BoxFit.cover,
                            image: '${AppConstants.baseUrl}/storage/app/public/chatting/${message.attachment![index]}')),);

                }),

            if(message.attachment!.length> 4)
            Positioned(bottom: 0, right: 0,
              child: InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>  ChattingMultiImageSlider(
                  images: message.attachment??[])),
                child: ClipRRect(borderRadius: BorderRadius.circular(5),
                    child:Container(width: MediaQuery.of(context).size.width/6.5, height: MediaQuery.of(context).size.width/6.5,
                      decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(.75), borderRadius: BorderRadius.circular(10)
                    ),child: Center(child: Text("+${message.attachment!.length-3}", style: textRegular.copyWith(color: Colors.white),)),)),),
            )


            ],
          ),
        )):
      const SizedBox.shrink(),
      ],
    );
  }
}
