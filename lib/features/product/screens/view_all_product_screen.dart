import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/products_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';

class AllProductScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final ProductType productType;
  AllProductScreen({super.key, required this.productType});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: productType == ProductType.featuredProduct ?
      '${getTranslated('featured_product', context)}':productType == ProductType.justForYou ?
      '${getTranslated('just_for_you', context)}':'${getTranslated('latest_product', context)}'),

      body: CustomScrollView(controller: _scrollController, slivers: [
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: ProductListWidget(isHomePage: false , productType: productType, scrollController: _scrollController)
          ))]),
    );
  }
}
