import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_body.dart';
import 'package:image_picker/image_picker.dart';

abstract class SupportTicketServiceInterface{

  Future<dynamic> createNewSupportTicket(SupportTicketBody supportTicketModel, List<XFile?> file);

  Future<dynamic> getSupportReplyList(String ticketID);

  Future<dynamic> sendReply(String ticketID, String message, List<XFile?> file);

  Future<dynamic> closeSupportTicket(String ticketID);

  Future<dynamic> getList({int? offset = 1});
}