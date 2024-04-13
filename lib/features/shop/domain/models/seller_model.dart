class SellerModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Seller>? sellers;

  SellerModel({this.totalSize, this.limit, this.offset, this.sellers});

  SellerModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['sellers'] != null) {
      sellers = <Seller>[];
      json['sellers'].forEach((v) {
        sellers!.add(Seller.fromJson(v));
      });
    }
  }


}
class Seller {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? image;
  String? email;
  String? password;
  String? status;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? authToken;
  String? gst;
  String? cmFirebaseToken;
  int? posStatus;
  double? minimumOrderAmount;
  double? freeDeliveryStatus;
  double? freeDeliveryOverAmount;
  int? ordersCount;
  int? productCount;
  int? totalRating;
  int? ratingCount;
  double? averageRating;
  Shop? shop;

  Seller(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.image,
        this.email,
        this.password,
        this.status,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.authToken,
        this.gst,
        this.cmFirebaseToken,
        this.posStatus,
        this.minimumOrderAmount,
        this.freeDeliveryStatus,
        this.freeDeliveryOverAmount,
        this.ordersCount,
        this.productCount,
        this.totalRating,
        this.ratingCount,
        this.averageRating,
        this.shop});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    password = json['password'];
    status = json['status'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authToken = json['auth_token'];
    gst = json['gst'];
    cmFirebaseToken = json['cm_firebase_token'];
    posStatus = int.parse(json['pos_status'].toString());
    minimumOrderAmount = double.parse(json['minimum_order_amount'].toString());
    freeDeliveryStatus = double.parse(json['free_delivery_status'].toString());
    freeDeliveryOverAmount = double.parse(json['free_delivery_over_amount'].toString());
    ordersCount = json['orders_count'];
    productCount = json['product_count'];
    totalRating = json['total_rating'];
    ratingCount = json['rating_count'];
    if(json['average_rating'] != null){
      averageRating =  double.tryParse(json['average_rating'].toString());
    }else{
      averageRating = 0;
    }

    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
  }

}

class Shop {
  int? id;
  int? sellerId;
  String? name;
  String? address;
  String? contact;
  String? image;
  String? bottomBanner;
  String? offerBanner;
  String? vacationStartDate;
  String? vacationEndDate;
  String? vacationNote;
  bool? vacationStatus;
  bool? temporaryClose;
  String? createdAt;
  String? updatedAt;
  String? banner;

  Shop(
      {this.id,
        this.sellerId,
        this.name,
        this.address,
        this.contact,
        this.image,
        this.bottomBanner,
        this.offerBanner,
        this.vacationStartDate,
        this.vacationEndDate,
        this.vacationNote,
        this.vacationStatus,
        this.temporaryClose,
        this.createdAt,
        this.updatedAt,
        this.banner});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellerId = int.parse(json['seller_id'].toString());
    name = json['name'];
    address = json['address'];
    contact = json['contact'];
    image = json['image'];
    bottomBanner = json['bottom_banner'];
    offerBanner = json['offer_banner'];
    vacationStartDate = json['vacation_start_date'];
    vacationEndDate = json['vacation_end_date'];
    vacationNote = json['vacation_note'];
    if(json['vacation_status'] != null){
      try{
        vacationStatus = json['vacation_status']??false;
      }catch(e){
        vacationStatus = json['vacation_status']==1? true :false;
      }
    }
    if(json['temporary_close'] != null){
      try{
        temporaryClose = json['temporary_close']??false;
      }catch(e){
        temporaryClose = json['temporary_close']== 1?true : false;
      }
    }

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    banner = json['banner'];
  }

}
