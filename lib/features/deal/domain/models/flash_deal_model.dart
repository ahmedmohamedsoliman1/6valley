    class FlashDealModel {
  int? _id;
  String? _title;
  String? _startDate;
  String? _endDate;
  String? _backgroundColor;
  String? _textColor;
  String? _banner;
  String? _slug;
  String? _createdAt;
  String? _updatedAt;
  int? _productId;
  String? _dealType;

  FlashDealModel(
      {int? id,
        String? title,
        String? startDate,
        String? endDate,
        String? backgroundColor,
        String? textColor,
        String? banner,
        String? slug,
        String? createdAt,
        String? updatedAt,
        int? productId,
        String? dealType}) {
    _id = id;
    _title = title;
    _startDate = startDate;
    _endDate = endDate;
    _backgroundColor = backgroundColor;
    _textColor = textColor;
    _banner = banner;
    _slug = slug;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _productId = productId;
    _dealType = dealType;
  }

  int? get id => _id;
  String? get title => _title;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get backgroundColor => _backgroundColor;
  String? get textColor => _textColor;
  String? get banner => _banner;
  String? get slug => _slug;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get productId => _productId;
  String? get dealType => _dealType;

  FlashDealModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _title = json['title'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _backgroundColor = json['background_color'];
    _textColor = json['text_color'];
    _banner = json['banner'];
    _slug = json['slug'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _productId = json['product_id'];
    _dealType = json['deal_type'];
  }

}
