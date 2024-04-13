import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';

class ShopAgainFromRecentStoreModel {
  int? id;
  String? name;
  String? slug;
  String? thumbnail;
  double? unitPrice;
  int? userId;
  int? reviewsCount;
  Seller? seller;


  ShopAgainFromRecentStoreModel(
      {this.id,
        this.name,
        this.slug,
        this.thumbnail,
        this.unitPrice,
        this.userId,
        this.reviewsCount,
        this.seller,
       });

  ShopAgainFromRecentStoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    thumbnail = json['thumbnail'];
    unitPrice = json['unit_price'].toDouble();
    userId = json['user_id'];
    reviewsCount = int.parse(json['reviews_count'].toString());
    seller = json['seller'] != null ? Seller.fromJson(json['seller']) : null;
  }
}

