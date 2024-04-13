import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class RelatedProductWidget extends StatelessWidget {
  const RelatedProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        return Column(children: [
          prodProvider.relatedProductList != null ? prodProvider.relatedProductList!.isNotEmpty ?
          MasonryGridView.count(
            crossAxisCount: ResponsiveHelper.isTab(context)? 3 : 2,
            itemCount: prodProvider.relatedProductList!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => ProductWidget(productModel: prodProvider.relatedProductList![index]),
          ):  Center(child: Text(getTranslated('no_related_product', context)??"")) :
          ProductShimmer(isHomePage: false, isEnabled: Provider.of<ProductController>(context).relatedProductList == null),
        ]);
      },
    );
  }
}
