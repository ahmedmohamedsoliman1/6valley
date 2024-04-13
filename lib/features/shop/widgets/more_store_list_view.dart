import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/more_store_widget.dart';
import 'package:provider/provider.dart';

class MoreStoreViewListView extends StatefulWidget {
  final String? title;
  const MoreStoreViewListView({super.key, this.title});
  @override
  State<MoreStoreViewListView> createState() => _MoreStoreViewListViewState();
}

class _MoreStoreViewListViewState extends State<MoreStoreViewListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title??  getTranslated('other_store', context),),
      body: Consumer<ShopController>(
          builder: (context, moreSellerProvider, _) {
            return GridView.builder(padding: EdgeInsets.zero, shrinkWrap: true,
              itemCount: moreSellerProvider.moreStoreList.length,
              itemBuilder: (context, index) {
                return Center(child: Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                    child: MoreStoreWidget(moreStore: moreSellerProvider.moreStoreList[index],
                        index: index, length: moreSellerProvider.moreStoreList.length),),);
              },  gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 5,crossAxisSpacing: 5, childAspectRatio: .8));
          }
      ),
    );
  }
}
