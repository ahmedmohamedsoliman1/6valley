import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class LoyaltyPointRepositoryInterface implements RepositoryInterface{
  Future<dynamic> convertPointToCurrency(int point);
}