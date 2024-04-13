
abstract class LoyaltyPointServiceInterface {
  Future<dynamic> getList({int? offset = 1});
  Future<dynamic> convertPointToCurrency(int point);
}