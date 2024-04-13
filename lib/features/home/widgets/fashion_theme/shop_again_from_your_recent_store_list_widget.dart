import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/shop_again_from_recent_store_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:provider/provider.dart';

class ShopAgainFromYourRecentStore extends StatelessWidget {

  const ShopAgainFromYourRecentStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SellerProductController>(
      builder: (context, shopAgainProvider,_) {
        return ListView.builder(
          shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: shopAgainProvider.shopAgainFromRecentStoreList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
          return ShopAgainFromRecentStoreWidget(shopAgainFromRecentStoreModel: shopAgainProvider.shopAgainFromRecentStoreList[index],
            index: index,length: shopAgainProvider.shopAgainFromRecentStoreList.length,);
        });
      }
    );
  }
}
