import 'package:flutter_sixvalley_ecommerce/features/cart/domain/models/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

abstract class CartServiceInterface{

  Future<dynamic> getList();

  Future<dynamic> delete(int id);

  Future<dynamic> addToCartListData(CartModelBody cart, List<ChoiceOptions> choiceOptions, List<int>? variationIndexes);

  Future<dynamic> updateQuantity(int? key,int quantity);



}