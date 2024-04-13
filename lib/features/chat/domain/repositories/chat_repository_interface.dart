import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';
import 'package:image_picker/image_picker.dart';
abstract class ChatRepositoryInterface<T> extends RepositoryInterface{

  Future<dynamic> getChatList(String type, int offset);

  Future<dynamic> searchChat(String type, String search);

  Future<dynamic> getMessageList(String type, int? id,int offset);

  Future<dynamic> seenMessage(int id, String type);

  Future<dynamic> sendMessage(MessageBody messageBody, String type, List<XFile?> file);
}