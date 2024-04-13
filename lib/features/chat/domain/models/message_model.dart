import 'package:flutter_sixvalley_ecommerce/features/chat/domain/models/chat_model.dart';

class MessageModel {
  int? totalSize;
  String? limit;
  String? offset;
  List<Message>? message;

  MessageModel({this.totalSize, this.limit, this.offset, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

}

class Message {
  int? id;
  String? message;
  bool? sentByCustomer;
  bool? sentBySeller;
  bool? sentByAdmin;
  bool? seenByDeliveryMan;
  String? createdAt;
  DeliveryMan? deliveryMan;
  SellerInfo? sellerInfo;
  List<String>? attachment;

  Message(
      {this.id,
        this.message,
        this.sentByCustomer,
        this.sentBySeller,
        this.sentByAdmin,
        this.seenByDeliveryMan,
        this.createdAt,
        this.deliveryMan,
        this.sellerInfo,
        this.attachment,
      });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    sentByCustomer = json['sent_by_customer'];
    sentBySeller = json['sent_by_seller'];
    sentByAdmin = json['sent_by_admin'];
    if(json['seen_by_delivery_man'] != null){
      seenByDeliveryMan = json['seen_by_delivery_man']??false;
    }

    createdAt = json['created_at'];
    deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    sellerInfo = json['seller_info'] != null ? SellerInfo.fromJson(json['seller_info']) : null;
    if(json['attachment'] != null){
      attachment = json['attachment'].cast<String>();
    }else{
      attachment = [];
    }

  }

}




