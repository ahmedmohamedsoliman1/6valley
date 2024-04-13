import 'package:flutter_sixvalley_ecommerce/features/refund/domain/repositories/refund_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/refund/domain/services/refund_service_interface.dart';
import 'package:image_picker/image_picker.dart';

class RefundService implements RefundServiceInterface{
  RefundRepositoryInterface refundRepositoryInterface;
  RefundService({required this.refundRepositoryInterface});

  @override
  Future getRefundInfo(int? orderDetailsId) async{
    return await refundRepositoryInterface.getRefundInfo(orderDetailsId);
  }

  @override
  Future getRefundResult(int? orderDetailsId) async{
    return refundRepositoryInterface.getRefundResult(orderDetailsId);
  }

  @override
  Future refundRequest(int? orderDetailsId, double? amount, String refundReason, List<XFile?> file) async{
    return await refundRepositoryInterface.refundRequest(orderDetailsId, amount, refundReason, file);
  }

}