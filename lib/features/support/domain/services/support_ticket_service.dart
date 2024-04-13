import 'package:flutter_sixvalley_ecommerce/features/support/domain/models/support_ticket_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/repositories/support_ticket_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/support/domain/services/support_ticket_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class SupportTicketService implements SupportTicketServiceInterface{
  SupportTicketRepositoryInterface supportTicketRepositoryInterface;

  SupportTicketService({required this.supportTicketRepositoryInterface});

  @override
  Future closeSupportTicket(String ticketID) async{
    return await supportTicketRepositoryInterface.closeSupportTicket(ticketID);
  }

  @override
  Future createNewSupportTicket(SupportTicketBody supportTicketModel, List<XFile?> file) async{
    return await supportTicketRepositoryInterface.createNewSupportTicket(supportTicketModel, file);
  }

  @override
  Future getList({int? offset = 1}) async{
    return await supportTicketRepositoryInterface.getList();
  }

  @override
  Future getSupportReplyList(String ticketID) async{
    return await supportTicketRepositoryInterface.getSupportReplyList(ticketID);
  }

  @override
  Future sendReply(String ticketID, String message, List<XFile?> file) async{
    return await supportTicketRepositoryInterface.sendReply(ticketID, message, file);
  }

}