import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/wishlist_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/widgets/wishlist_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});
  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    super.initState();
    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
      Provider.of<WishListController>(context, listen: false).getWishList();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('wishList', context)),
      resizeToAvoidBottomInset: true,
      body: Column(children: [
          Expanded(child: !Provider.of<AuthController>(context, listen: false).isLoggedIn() ?
          const NotLoggedInWidget() :
          Consumer<WishListController>(builder: (context, wishListProvider, child) {
            return wishListProvider.wishList != null ? wishListProvider.wishList!.isNotEmpty ? RefreshIndicator(
              onRefresh: () async => await  wishListProvider.getWishList(),
              child: ListView.builder(padding: const EdgeInsets.all(0),
                  itemCount: wishListProvider.wishList!.length, itemBuilder: (context, index) {
                return WishListWidget(wishlistModel: wishListProvider.wishList![index], index: index);
              })) :
            const NoInternetOrDataScreenWidget(isNoInternet: false,message: 'no_wishlist_product',
              icon: Images.noWishlist,): const WishListShimmer();
          }),
          ),
        ],
      ),
    );
  }
}


