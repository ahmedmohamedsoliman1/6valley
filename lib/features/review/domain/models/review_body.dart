class ReviewBody {
  String? _id;
  String? _orderId;
  String? _productId;
  String? _comment;
  String? _rating;
  List<String>? _fileUpload;

  ReviewBody(
      {
        String? id,
        String? orderId,
        String? productId,
        String? comment,
        String? rating,
        List<String>? fileUpload}) {
    _id = id;
    _orderId = orderId;
    _productId = productId;
    _comment = comment;
    _rating = rating;
    _fileUpload = fileUpload;

  }

  String? get id => _id;
  String? get orderId => _orderId;
  String? get productId => _productId;
  String? get comment => _comment;
  String? get rating => _rating;
  List<String>? get fileUpload => _fileUpload;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _id = json["id"];
    _orderId = json["order_id"];
    _productId = json['product_id'];
    _comment = json['comment'];
    _rating = json['rating'];
    _fileUpload = json['fileUpload'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = _id;
    data["order_id"] = _orderId;
    data['product_id'] = _productId;
    data['comment'] = _comment;
    data['rating'] = _rating;
    data['fileUpload'] = _fileUpload;
    return data;
  }
}
