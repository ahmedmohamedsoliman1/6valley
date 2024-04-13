
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/controllers/chat_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/widgets/chat_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/widgets/chat_type_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/widgets/inbox_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/widgets/search_inbox_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const InboxScreen({super.key, this.isBackButtonExist = true});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {

  TextEditingController searchController = TextEditingController();

  late bool isGuestMode;
  @override
  void initState() {

    isGuestMode = !Provider.of<AuthController>(context, listen: false).isLoggedIn();
      if(!isGuestMode) {
        load();
      }
    super.initState();
  }


  Future<void> load ()async {
    await Provider.of<ChatController>(context, listen: false).getChatList(1, reload: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: Navigator.of(context).canPop(),
      onPopInvoked: (val) async{
        if(Navigator.of(context).canPop()){
          return;
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: getTranslated('inbox', context), isBackButtonExist: widget.isBackButtonExist,
        onBackPressed: (){
          if(Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));

          }
        },),
        body: Consumer<ChatController>(
          builder: (context, chat, _) {
            return Column(children: [
              if(!isGuestMode)
              Consumer<ChatController>(
                builder: (context, chat, _) {
                  return Padding(padding: const EdgeInsets.fromLTRB( Dimensions.homePagePadding,
                      Dimensions.paddingSizeSmall, Dimensions.homePagePadding, 0),
                    child: SearchInboxWidget(hintText: getTranslated('search', context)));
                }),

                if(!isGuestMode && chat.chatModel != null)
              Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
                child: Row(children: [
                  ChatTypeButtonWidget(text: getTranslated('seller', context), index: 0),
                  ChatTypeButtonWidget(text: getTranslated('delivery-man', context), index: 1)])),

              Expanded(child: isGuestMode ? const NotLoggedInWidget() :

              RefreshIndicator(
                onRefresh: () async {
                  searchController.clear();
                  await chat.getChatList(1);
                  },
                child: Consumer<ChatController>(
                  builder: (context, chatProvider, child) {
                    return chat.chatModel != null? (chat.chatModel!.chat != null &&
                        chat.chatModel!.chat!.isNotEmpty)?
                        ListView.builder(
                          itemCount: chat.chatModel?.chat?.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return ChatItemWidget(chat: chat.chatModel!.chat![index], chatProvider: chat);
                          },
                        ) : const NoInternetOrDataScreenWidget(isNoInternet: false, message: 'no_conversion',
                      icon: Images.noInbox,): const InboxShimmerWidget();
                  }))
              ),


            ]);
          }
        ),
      ),
    );
  }
}



