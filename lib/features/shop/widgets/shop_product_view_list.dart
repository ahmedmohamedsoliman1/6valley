import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ShopProductViewList extends StatefulWidget {
  final ScrollController scrollController;
  final int sellerId;
  const ShopProductViewList({super.key, required this.scrollController, required this.sellerId});

  @override
  State<ShopProductViewList> createState() => _ShopProductViewListState();
}

class _ShopProductViewListState extends State<ShopProductViewList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductController>(
      builder: (context, productController, _) {
        return productController.sellerProduct != null ? (productController.sellerProduct!.products != null &&
            productController.sellerProduct!.products!.isNotEmpty)?
        PaginatedListView(scrollController: widget.scrollController,
            onPaginate: (offset) async=> await productController.getSellerProductList(widget.sellerId.toString(), offset!, ""),
            totalSize: productController.sellerProduct?.totalSize,
            offset: productController.sellerProduct?.offset,
            itemView: MasonryGridView.count(
              itemCount: productController.sellerProduct?.products?.length,
              crossAxisCount: ResponsiveHelper.isTab(context)? 3 : 2,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(productModel: productController.sellerProduct!.products![index]);
              },
            )): const SizedBox():
        const ProductShimmer(isEnabled: true, isHomePage: false);
      }
    );
  }
}
