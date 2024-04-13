import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/repositories/chat_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/domain/services/chat_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class ChatService implements ChatServiceInterface{
  ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future getChatList(String type, int offset) async{
    return chatRepositoryInterface.getChatList(type, offset);
  }

  @override
  Future getMessageList(String type, int? id, int offset) async{
    return chatRepositoryInterface.getMessageList(type, id, offset);
  }

  @override
  Future searchChat(String type, String search) async {
    return chatRepositoryInterface.searchChat(type, search);
  }

  @override
  Future seenMessage(int id, String type) async{
    return chatRepositoryInterface.seenMessage(id, type);
  }

  @override
  Future sendMessage(MessageBody messageBody, String type, List<XFile?> file) async{
    return chatRepositoryInterface.sendMessage(messageBody, type, file);
  }

}