import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/home_category_product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeCategoryProductItemWidget extends StatelessWidget {
  final HomeCategoryProduct homeCategoryProduct;
  final int index;
  final bool isHomePage;
  const HomeCategoryProductItemWidget({super.key, required this.homeCategoryProduct, required this.index, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isEven ? Theme.of(context).primaryColor.withOpacity(.125) : Colors.transparent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        isHomePage ?
        Padding(padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault),
            child: TitleRowWidget(title: homeCategoryProduct.name,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: homeCategoryProduct.id.toString(),
                      name: homeCategoryProduct.name)));
                })) :
        const SizedBox(),

        ConstrainedBox(constraints: homeCategoryProduct.products!.isNotEmpty ?
        const BoxConstraints(maxHeight: BouncingScrollSimulation.maxSpringTransferVelocity):
        const BoxConstraints(maxHeight: 0),
            child: MasonryGridView.count(
                itemCount: (isHomePage && homeCategoryProduct.products!.length > 4) ? 4
                    : homeCategoryProduct.products!.length,
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                physics: const BouncingScrollPhysics(),
                crossAxisCount: ResponsiveHelper.isTab(context)? 3 : 2,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {
                  return InkWell(onTap: () {
                    Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 1000),
                        pageBuilder: (context, anim1, anim2) => ProductDetails(productId: homeCategoryProduct.products![i].id,
                            slug: homeCategoryProduct.products![i].slug)));
                  },
                      child: SizedBox(width: (MediaQuery.of(context).size.width/2)-20,
                          child: ProductWidget(productModel: homeCategoryProduct.products![i])));
                })),
        const SizedBox(height: Dimensions.paddingSizeSmall),
      ],
      ),
    );
  }
}