class ShippingMethodModel {
  int? id;
  String? creatorType;
  String? title;
  double? cost;
  String? duration;
  String? createdAt;
  String? updatedAt;

  ShippingMethodModel(
      {this.id,
        this.creatorType,
        this.title,
        this.cost,
        this.duration,
        this.createdAt,
        this.updatedAt});



  ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorType = json['creator_type'];
    title = json['title'];
    if(json['cost'] != null){
      try{
        cost = json['cost'].toDouble();
      }catch(e){
        cost = double.parse(json['cost'].toString());
      }
    }

    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
