abstract class OrderServiceInterface{

  Future<dynamic> getOrderList(int offset, String status, {String? type});

  Future<dynamic> getTrackingInfo(String orderID);

  Future<dynamic> cancelOrder(int? orderId);
}