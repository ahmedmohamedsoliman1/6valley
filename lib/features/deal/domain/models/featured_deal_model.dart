
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';


class FeaturedDealModel {

  Product? product;

  FeaturedDealModel(
      {this.product});

  FeaturedDealModel.fromJson(Map<String, dynamic> json) {

    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}


