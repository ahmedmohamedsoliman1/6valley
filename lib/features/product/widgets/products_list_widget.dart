import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';

import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  final bool isHomePage;
  final ProductType productType;
  final ScrollController? scrollController;

  const ProductListWidget({super.key, required this.isHomePage, required this.productType, this.scrollController});

  @override
  Widget build(BuildContext context) {
    
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Provider.of<ProductController>(context, listen: false).latestProductList!.isNotEmpty
          && !Provider.of<ProductController>(context, listen: false).filterIsLoading) {
        late int pageSize;
        if(productType == ProductType.bestSelling || productType == ProductType.topProduct ||
            productType == ProductType.newArrival ||productType == ProductType.discountedProduct ) {
          pageSize = (Provider.of<ProductController>(context, listen: false).latestPageSize!/10).ceil();
          offset = Provider.of<ProductController>(context, listen: false).lOffset;
        }

        else if(productType == ProductType.justForYou){

        }
        if(offset < pageSize) {
          offset++;
          Provider.of<ProductController>(context, listen: false).showBottomLoader();
          Provider.of<ProductController>(context, listen: false).getLatestProductList(offset);
        }else{

        }
      }

    });

    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = [];
        if(productType == ProductType.latestProduct) {
          productList = prodProvider.lProductList;
        }
        else if(productType == ProductType.featuredProduct) {
          productList = prodProvider.featuredProductList;
        }else if(productType == ProductType.topProduct) {
          productList = prodProvider.latestProductList;
        }else if(productType == ProductType.bestSelling) {
          productList = prodProvider.latestProductList;
        }else if(productType == ProductType.newArrival) {
          productList = prodProvider.latestProductList;
        }else if(productType == ProductType.justForYou) {
          productList = prodProvider.justForYouProduct;
        }

        return Column(children: [
          !prodProvider.filterFirstLoading ? (productList != null && productList.isNotEmpty) ?
          MasonryGridView.count(
            itemCount: isHomePage? productList.length>4?
            4:productList.length:productList.length,
            crossAxisCount: ResponsiveHelper.isTab(context)? 3 :2,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ProductWidget(productModel: productList![index]);
            },
          ) : const NoInternetOrDataScreenWidget(isNoInternet: false): ProductShimmer(isHomePage: isHomePage ,isEnabled: prodProvider.firstLoading),

          prodProvider.filterIsLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink()]);
      },
    );
  }
}

