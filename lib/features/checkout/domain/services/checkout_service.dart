import 'package:flutter_sixvalley_ecommerce/features/checkout/domain/repositories/checkout_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/domain/services/checkout_service_interface.dart';

class CheckoutService implements CheckoutServiceInterface{
  CheckoutRepositoryInterface checkoutRepositoryInterface;


  CheckoutService({required this.checkoutRepositoryInterface});

  @override
  Future cashOnDeliveryPlaceOrder(String? addressID, String? couponCode, String? couponDiscountAmount, String? billingAddressId, String? orderNote) async{
    return await checkoutRepositoryInterface.cashOnDeliveryPlaceOrder(addressID, couponCode, couponDiscountAmount, billingAddressId, orderNote);
  }

  @override
  Future digitalPaymentPlaceOrder(String? orderNote, String? customerId, String? addressId, String? billingAddressId, String? couponCode, String? couponDiscount, String? paymentMethod) async {
    return await checkoutRepositoryInterface.digitalPaymentPlaceOrder(orderNote, customerId, addressId, billingAddressId, couponCode, couponDiscount, paymentMethod);
  }

  @override
  Future offlinePaymentList()  async{
   return await checkoutRepositoryInterface.offlinePaymentList();
  }

  @override
  Future offlinePaymentPlaceOrder(String? addressID, String? couponCode, String? couponDiscountAmount, String? billingAddressId, String? orderNote, List<String?> typeKey, List<String> typeValue, int? id, String name, String? paymentNote) async{
    return await checkoutRepositoryInterface.offlinePaymentPlaceOrder(addressID, couponCode, couponDiscountAmount, billingAddressId, orderNote, typeKey, typeValue, id, name, paymentNote);
  }

  @override
  Future walletPaymentPlaceOrder(String? addressID, String? couponCode, String? couponDiscountAmount, String? billingAddressId, String? orderNote) async{
    return await checkoutRepositoryInterface.walletPaymentPlaceOrder(addressID, couponCode, couponDiscountAmount, billingAddressId, orderNote);
  }

}