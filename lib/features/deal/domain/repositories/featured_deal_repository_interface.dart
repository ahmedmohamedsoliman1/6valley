import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class FeaturedDealRepositoryInterface implements RepositoryInterface{

  Future<dynamic> getFeaturedDeal();
}