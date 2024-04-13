import 'package:flutter_sixvalley_ecommerce/features/coupon/domain/repositories/coupon_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/coupon/domain/services/coupon_service_interface.dart';

class CouponService implements CouponServiceInterface{
  CouponRepositoryInterface couponRepositoryInterface;
  CouponService({required this.couponRepositoryInterface});

  @override
  Future get(String id) async{
    return await couponRepositoryInterface.get(id);
  }

  @override
  Future getAvailableCouponList() async{
    return await couponRepositoryInterface.getAvailableCouponList();
  }

  @override
  Future getList({int? offset = 1}) async{
    return await couponRepositoryInterface.getList(offset: offset);
  }

  @override
  Future getSellerCouponList(int sellerId, int offset) async {
    return await couponRepositoryInterface.getSellerCouponList(sellerId, offset);
  }

}