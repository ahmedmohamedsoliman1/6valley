import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/domain/repositories/loyalty_point_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/domain/services/loyalty_point_service_interface.dart';

class LoyaltyPointService implements LoyaltyPointServiceInterface{
  LoyaltyPointRepositoryInterface loyaltyPointRepositoryInterface;

  LoyaltyPointService({required this.loyaltyPointRepositoryInterface});

  @override
  Future convertPointToCurrency(int point) async{
    return await loyaltyPointRepositoryInterface.convertPointToCurrency(point);
  }

  @override
  Future getList({int? offset = 1}) async{
    return loyaltyPointRepositoryInterface.getList(offset: offset);
  }
}