import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/services/chat_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:http/http.dart' as http;



class ChatController extends ChangeNotifier {
  final ChatServiceInterface? chatServiceInterface;
  ChatController({required this.chatServiceInterface});


  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  File? _imageFile;
  File? get imageFile => _imageFile;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _userTypeIndex = 0;
  int get userTypeIndex =>  _userTypeIndex;
  ChatModel? chatModel;
  bool sellerChatCall= false;
  bool deliveryChatCall= false;



  Future<void> getChatList( int offset, {bool reload = true}) async {
    chatModel = null;
    if(reload){
      notifyListeners();
    }

    ApiResponse apiResponse = await chatServiceInterface!.getChatList(_userTypeIndex == 0? 'seller' : 'delivery-man', offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1){
        chatModel = null;
        chatModel = ChatModel.fromJson(apiResponse.response!.data);
      }else{
        chatModel?.chat?.addAll(ChatModel.fromJson(apiResponse.response!.data).chat!);
        chatModel?.offset  = (ChatModel.fromJson(apiResponse.response!.data).offset!);
        chatModel?.totalSize  = (ChatModel.fromJson(apiResponse.response!.data).totalSize!);
      }

    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<void> searchChat(BuildContext context, String search) async {
    _isLoading = true;
    chatModel = null;
    notifyListeners();
    ApiResponse apiResponse = await chatServiceInterface!.searchChat(_userTypeIndex == 0? 'seller' : 'delivery-man', search);
    if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
        chatModel = null;
        chatModel = ChatModel(totalSize: 1, limit: '10', offset: '1', chat: []);
        apiResponse.response!.data.forEach((chat) => chatModel!.chat!.add(Chat.fromJson(chat)));
        chatModel?.chat = chatModel!.chat;

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  List<String> dateList = [];
  List<dynamic> messageList=[];
  List<Message> allMessageList=[];
  MessageModel? messageModel;

  Future<void> getMessageList(BuildContext context, int? id, int offset, {bool reload = true}) async {
    if(reload){
      messageModel = null;
      dateList = [];
      messageList = [];
      allMessageList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatServiceInterface!.getMessageList(_userTypeIndex == 0? 'seller' : 'delivery-man', id, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      messageModel = null;
      dateList = [];
      messageList = [];
      allMessageList = [];
        messageModel = MessageModel.fromJson(apiResponse.response!.data);
        for (var data in messageModel!.message!) {
          if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          allMessageList.add(data);
        }
      for(int i=0;i< dateList.length;i++){
        messageList.add([]);
        for (var element in allMessageList) {
          if(dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            messageList[i].add(element);
          }
        }
      }
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }



  Future<http.StreamedResponse> sendMessage(MessageBody messageBody,) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatServiceInterface!.sendMessage(messageBody,_userTypeIndex == 0? 'seller' : 'delivery-man' , pickedImageFileStored??[]);
    if (response.statusCode == 200) {
      getMessageList(Get.context!, messageBody.id, 1, reload: false);
      _pickedImageFiles = [];
      pickedImageFileStored = [];
      _isLoading = false;
    } else {
      _isLoading = false;
    }
    _pickedImageFiles = [];
    pickedImageFileStored = [];
    _isLoading = false;
    notifyListeners();
    return response;
  }


  Future<ApiResponse> seenMessage(BuildContext context, int? sellerId, int? deliveryId) async {
    ApiResponse apiResponse = await chatServiceInterface!.seenMessage(_userTypeIndex == 0? sellerId!: deliveryId!, _userTypeIndex == 0? 'seller' : 'delivery-man');
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      await getChatList(1);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
    return apiResponse;
  }




  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(String text) {
    _imageFile = null;
    text.isEmpty ? _isSendButtonActive = false : _isSendButtonActive = true;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }
  void setUserTypeIndex(BuildContext context, int index) {
    _userTypeIndex = index;
    getChatList(1);
    notifyListeners();
  }

  List <XFile> _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  List <XFile>?  pickedImageFileStored = [];
  void pickMultipleImage(bool isRemove,{int? index}) async {
    if(isRemove) {
      if(index != null){
        pickedImageFileStored?.removeAt(index);
      }
    }else {
      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      pickedImageFileStored?.addAll(_pickedImageFiles);
    }
    notifyListeners();
  }


}
