import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';


class ChatTypeButtonWidget extends StatelessWidget {
  final String? text;
  final int index;
  const ChatTypeButtonWidget({super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, chatProvider,_) {
        return InkWell(splashColor: Colors.transparent, focusColor: Colors.transparent, highlightColor: Colors.transparent,
          onTap: (){
          if(!chatProvider.isLoading){
              Provider.of<ChatController>(context, listen: false).setUserTypeIndex(context, index);
            }
          },
          child: Consumer<ChatController>(builder: (context, chat,_) {
            return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,
                vertical: Dimensions.paddingSizeExtraSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, children: [

                  Text(text!, style: chat.userTypeIndex == index ?
                  textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge):

                  textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge)),

                  (chat.userTypeIndex == index && index == 0)?
                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: Container(color: Theme.of(context).primaryColor, height: 2,width: 34),):

                  (chat.userTypeIndex == index && index == 1)?
                  Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                    child: Container(color: Theme.of(context).primaryColor, height: 2,width: 75),):

                  const Padding(padding: EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                      child: SizedBox()),
                ],
              ),
            );
          },
          ),
        );
      }
    );
  }
}