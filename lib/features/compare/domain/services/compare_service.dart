import 'package:flutter_sixvalley_ecommerce/features/compare/domain/repositories/compare_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/domain/services/compare_service_interface.dart';

class CompareService implements CompareServiceInterface{
  CompareRepositoryInterface compareRepositoryInterface;
  CompareService({required this.compareRepositoryInterface});

  @override
  Future addCompareProductList(int id) async{
    return await compareRepositoryInterface.addCompareProductList(id);
  }

  @override
  Future getAttributeList() async{
    return await compareRepositoryInterface.getAttributeList();
  }

  @override
  Future getList() async {
    return await compareRepositoryInterface.getList();
  }

  @override
  Future removeAllCompareProductList() async{
    return await compareRepositoryInterface.removeAllCompareProductList();
  }

  @override
  Future replaceCompareProductList(int compareId, int productId) async {
    return await compareRepositoryInterface.replaceCompareProductList(compareId, productId);
  }

}