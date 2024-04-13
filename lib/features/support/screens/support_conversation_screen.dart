import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/controllers/support_ticket_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/widgets/support_ticket_reply_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

class SupportConversationScreen extends StatefulWidget {
  final SupportTicketModel supportTicketModel;
  const SupportConversationScreen({super.key, required this.supportTicketModel});

  @override
  State<SupportConversationScreen> createState() => _SupportConversationScreenState();
}

class _SupportConversationScreenState extends State<SupportConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketController>(context, listen: false).getSupportTicketReplyList(context, widget.supportTicketModel.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBar(title: widget.supportTicketModel.subject,),
      body: Consumer<SupportTicketController>(
        builder: (context, support, child) {
          return Column(children: [

            Expanded(child: Consumer<SupportTicketController>(builder: (context, support, child) {
              return support.supportReplyList != null ?
              ListView.builder(
                itemCount: support.supportReplyList!.length,
                reverse: true,
                itemBuilder: (context, index) {
                  bool isMe = (support.supportReplyList![index].adminId !=  '1' || support.supportReplyList![index].customerMessage != null);
                  String? message = isMe ? support.supportReplyList![index].customerMessage : support.supportReplyList![index].adminMessage;
                  String dateTime = DateConverter.localDateToIsoStringAMPM(DateTime.parse(support.supportReplyList![index].createdAt!));
                  return SupportTicketReplyWidget(message: message, dateTime: dateTime, isMe: isMe,
                      replyModel: support.supportReplyList![index]);
                },) : const Center(child: CircularProgressIndicator());
            })),




            support.pickedImageFileStored.isNotEmpty ?
            Container(height: 90, width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                return  Stack(children: [
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ClipRRect(borderRadius: BorderRadius.circular(10),
                          child: SizedBox(height: 80, width: 80,
                              child: Image.file(File(support.pickedImageFileStored[index].path),
                                  fit: BoxFit.cover)))),


                  Positioned(right: 5, child: InkWell(child: const Icon(Icons.cancel_outlined, color: Colors.red),
                      onTap: () => support.pickMultipleImage(true,index: index)))]);},
                itemCount: support.pickedImageFileStored.length)) : const SizedBox(),


            SizedBox(height: 70,
              child: Card(color: Theme.of(context).highlightColor,
                shadowColor: Colors.grey[200],
                elevation: 2,
                margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Row(children: [
                    Expanded(child: TextField(
                      controller: _controller,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 1,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'Type here...',
                          hintStyle: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                          border: InputBorder.none,
                          suffixIcon: InkWell(onTap: ()=> support.pickMultipleImage(false),
                            child: Padding(padding: const EdgeInsets.all(8.0),
                              child: Image.asset(Images.attachment)))))),

                    InkWell(onTap: () {
                        if(_controller.text.isEmpty && support.pickedImageFileStored.isEmpty ){

                        }else{
                          support.sendReply(widget.supportTicketModel.id, _controller.text);
                          _controller.text = '';
                        }
                      },
                      child: Icon(Icons.send, color: Theme.of(context).primaryColor, size: Dimensions.iconSizeDefault,),
                    ),
                  ]),
                ),
              ),
            ),

          ]);
        }
      ),
    );
  }
}
