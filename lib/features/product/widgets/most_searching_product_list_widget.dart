import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class MostSearchingProductListWidget extends StatefulWidget {
  const MostSearchingProductListWidget({super.key});
  @override
  State<MostSearchingProductListWidget> createState() => _MostSearchingProductListWidgetState();
}

class _MostSearchingProductListWidgetState extends State<MostSearchingProductListWidget> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('your_most_searching', context)),
      body:
      Consumer<ProductController>(
        builder: (context, productController,_) {
          return (productController.mostSearchingProduct != null && productController.mostSearchingProduct!.products != null) ?
          productController.mostSearchingProduct!.products!.isNotEmpty ?
          SingleChildScrollView(
            controller: scrollController,
            child: PaginatedListView(
              scrollController: scrollController,
              totalSize: productController.mostSearchingProduct!.totalSize,
              offset: (productController.mostSearchingProduct != null && productController.mostSearchingProduct!.offset != null) ?
              int.parse(productController.mostSearchingProduct!.offset.toString()) : null,
              onPaginate: (int? offset) async {
                await productController.getMostSearchingProduct(offset!);
              },

              itemView: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding, vertical: Dimensions.paddingSizeSmall),
                child: MasonryGridView.count(
                  itemCount: productController.mostSearchingProduct!.products!.length,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductWidget(productModel: productController.mostSearchingProduct!.products![index]);
                  }, crossAxisCount: 2,
                ),
              ),
            ),
          ): const Center(child: NoInternetOrDataScreenWidget(isNoInternet: false)) :
           const Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
