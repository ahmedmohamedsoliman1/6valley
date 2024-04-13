import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/repositories/order_details_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/domain/services/order_details_service_interface.dart';

class OrderDetailsService implements OrderDetailsServiceInterface{
  OrderDetailsRepositoryInterface orderDetailsRepositoryInterface;
  OrderDetailsService({required this.orderDetailsRepositoryInterface});



  @override
  Future getOrderFromOrderId(String orderID) async{
    return await orderDetailsRepositoryInterface.getOrderFromOrderId(orderID);
  }

  @override
  Future getOrderDetails(String orderID) async{
    return await orderDetailsRepositoryInterface.get(orderID);
  }

  @override
  Future downloadDigitalProduct(int orderDetailsId) async{
    return await orderDetailsRepositoryInterface.downloadDigitalProduct(orderDetailsId);
  }

  @override
  Future verifyDigitalProductOtp(int orderId, String otp) async{
    return await orderDetailsRepositoryInterface.otpVerificationForDigitalProduct(orderId, otp);
  }

  @override
  Future resentDigitalProductOtp(int orderId) async{
    return await orderDetailsRepositoryInterface.resendOtpForDigitalProduct(orderId);
  }

  @override
  Future trackOrder(String orderId, String phoneNumber) async{
    return await orderDetailsRepositoryInterface.trackYourOrder(orderId, phoneNumber);
  }


}