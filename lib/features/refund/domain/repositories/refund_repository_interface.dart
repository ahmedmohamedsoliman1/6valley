import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class RefundRepositoryInterface implements RepositoryInterface{

  Future<dynamic> refundRequest(int? orderDetailsId, double? amount, String refundReason, List<XFile?> file);

  Future<dynamic> getRefundInfo(int? orderDetailsId);

  Future<dynamic> getRefundResult(int? orderDetailsId);

}