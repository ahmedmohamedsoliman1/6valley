abstract class CouponServiceInterface{

  Future<dynamic> getList({int? offset = 1});

  Future<dynamic> get(String id);

  Future<dynamic> getAvailableCouponList();

  Future<dynamic> getSellerCouponList(int sellerId, int offset);

}