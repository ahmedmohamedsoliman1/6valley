import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/featured_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/most_searching_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/products_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/recommended_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/featured_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/announcement_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/more_store_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/cart_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/fashion_theme/most_demanded_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/fashion_theme/shop_again_from_your_recent_store_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/fashion_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/single_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/just_for_you/just_for_you_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/more_store_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/shop_again_from_recent_store_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/all_shop_screen.dart';
import 'package:provider/provider.dart';


class FashionThemeHomePage extends StatefulWidget {
  const FashionThemeHomePage({super.key});

  @override
  State<FashionThemeHomePage> createState() => _FashionThemeHomePageState();
}

class _FashionThemeHomePageState extends State<FashionThemeHomePage> {
  final ScrollController _scrollController = ScrollController();


  Future<void> _loadData(bool reload) async {
    await Provider.of<BannerController>(Get.context!, listen: false).getBannerList(reload);
    await Provider.of<CategoryController>(Get.context!, listen: false).getCategoryList(reload);
    await Provider.of<ProductController>(Get.context!, listen: false).getHomeCategoryProductList(reload);
    await Provider.of<ShopController>(Get.context!, listen: false).getTopSellerList(reload, 1,type: "top");
    await Provider.of<BrandController>(Get.context!, listen: false).getBrandList(reload);
    await Provider.of<ProductController>(Get.context!, listen: false).getLatestProductList(1, reload: reload);
    await Provider.of<ProductController>(Get.context!, listen: false).getFeaturedProductList('1', reload: reload);
    await Provider.of<FeaturedDealController>(Get.context!, listen: false).getFeaturedDealList(reload);
    await Provider.of<ProductController>(Get.context!, listen: false).getLProductList('1', reload: reload);
    await Provider.of<ProductController>(Get.context!, listen: false).getRecommendedProduct();
    await Provider.of<ProductController>(Get.context!, listen: false).getMostDemandedProduct();
    await Provider.of<ProductController>(Get.context!, listen: false).getMostSearchingProduct(1);
    await Provider.of<ShopController>(Get.context!, listen: false).getMoreStore();
    await Provider.of<NotificationController>(Get.context!, listen: false).getNotificationList(1);
    if(Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn()){
      await Provider.of<ProfileController>(Get.context!, listen: false).getUserInfo(Get.context!);
      await Provider.of<SellerProductController>(Get.context!, listen: false).getShopAgainFromRecentStore();
      await Provider.of<WishListController>(Get.context!, listen: false).getWishList();
    }
  }


  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashController>(context, listen: false).configModel!.businessMode == "single";
    Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);
    _loadData(false);
    Provider.of<CartController>(context, listen: false).getCartData(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: SafeArea(child: RefreshIndicator(
          onRefresh: () async {
            await _loadData( true);
            await Provider.of<FlashDealController>(Get.context!, listen: false).getFlashDealList(true, false);
          },
          child: CustomScrollView(controller: _scrollController, slivers: [
            SliverAppBar(
              floating: true,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).highlightColor,
              title: Image.asset(Images.logoWithNameImage, height: 35), actions: const [
              CartHomePageWidget()]),

            SliverToBoxAdapter(child: Provider.of<SplashController>(context, listen: false).configModel!.announcement!.status == '1'?
              Consumer<SplashController>(
                builder: (context, announcement, _){
                  return (announcement.configModel!.announcement!.announcement != null && announcement.onOff)?
                  AnnouncementWidget(announcement: announcement.configModel!.announcement):const SizedBox();
                },):const SizedBox(),),


            SliverPersistentHeader(pinned: true,
                delegate: SliverDelegate(
                    child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                        child: const SearchHomePageWidget()))),

            SliverToBoxAdapter(
              child: Column(children: [
                const FashionBannersWidget(),
                const SizedBox(height: Dimensions.homePagePadding),



                Consumer<FlashDealController>(
                  builder: (context, megaDeal, child) {
                    return  megaDeal.flashDeal != null ? megaDeal.flashDealList.isNotEmpty ?
                    Column(children: [
                      Padding(padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding,
                          Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraExtraSmall),
                        child: TitleRowWidget(title: getTranslated('flash_deal', context),
                            eventDuration: megaDeal.flashDeal != null ? megaDeal.duration : null,
                            onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashDealScreenView()));
                          },isFlash: true)),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Text(getTranslated('flash_sale_fore_any_item', context)??'',
                          style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      SizedBox(height:  ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .58 : 350, child: const Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                          child: FlashDealsListWidget()))]) : const SizedBox.shrink(): const FlashDealShimmer();
                    },),




                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  child: TitleRowWidget(title: getTranslated('CATEGORY', context),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryScreen()))),),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                const Padding(padding: EdgeInsets.fromLTRB(0, 0 ,0 , Dimensions.homePagePadding),
                    child: CategoryListWidget(isHomePage: true)),




                Consumer<FeaturedDealController>(
                  builder: (context, featuredDealProvider, child) {
                    return  featuredDealProvider.featuredDealProductList != null? featuredDealProvider.featuredDealProductList!.isNotEmpty ?
                    Stack(children: [
                      Container(width: MediaQuery.of(context).size.width,height: 150,
                          color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                          Theme.of(context).primaryColor.withOpacity(.20):Theme.of(context).primaryColor.withOpacity(.125)),
                       Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                          child: Column(children: [
                           Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                             child: TitleRowWidget(title: '${getTranslated('featured_deals', context)}',
                               onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                               const FeaturedDealScreenView())))),
                            const FeaturedDealsListWidget()])),
                    ]) : const SizedBox.shrink() : const FindWhatYouNeedShimmer();},),




                Consumer<BannerController>(builder: (context, bannerProvider, child){
                  return bannerProvider.promoBannerMiddleTop != null?
                   Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                       left:Dimensions.homePagePadding, right: Dimensions.homePagePadding ),
                      child: SingleBannersWidget(bannerModel : bannerProvider.promoBannerMiddleTop,
                        height: MediaQuery.of(context).size.width/3,)):const SizedBox();}),



                Consumer<ProductController>(
                    builder: (context, featured,_) {
                      return  featured.featuredProductList != null? featured.featuredProductList!.isNotEmpty ?
                      Stack(children: [
                          Padding(padding: const EdgeInsets.only(left: 50, bottom: 20),
                            child: Container(width: MediaQuery.of(context).size.width - 50,
                              height: Dimensions.featuredProductCard,
                              decoration: BoxDecoration(borderRadius: const BorderRadius.only(
                                  topLeft : Radius.circular(Dimensions.paddingSizeDefault),
                                      bottomLeft: Radius.circular(Dimensions.paddingSizeDefault)),
                                  color: Theme.of(context).colorScheme.onSecondaryContainer))),

                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                                child: Padding(padding: const EdgeInsets.only(top: 20, left: 50,bottom: Dimensions.paddingSizeSmall),
                                    child: TitleRowWidget(title: getTranslated('featured_products', context),
                                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                            AllProductScreen(productType: ProductType.featuredProduct))))
                                )),

                              Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                                child: FeaturedProductWidget(scrollController: _scrollController, isHome: true))])],
                      ):const SizedBox(): const FeaturedProductShimmer();}),




                singleVendor?const SizedBox():
                Consumer<ShopController>(
                  builder: (context, topStoreProvider,_) {
                    return (topStoreProvider.sellerModel != null && (topStoreProvider.sellerModel!.sellers!=null && topStoreProvider.sellerModel!.sellers!.isNotEmpty))?
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        TitleRowWidget(title: getTranslated('top_fashion_house', context),
                            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            const AllTopSellerScreen(title: 'top_fashion_house',)))),
                        singleVendor?const SizedBox(height: 0):const SizedBox(height: Dimensions.paddingSizeSmall),
                        singleVendor?const SizedBox():
                         Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                            child: SizedBox(height: ResponsiveHelper.isTab(context)? 170 : 165, child:  TopSellerView(isHomePage: true, scrollController: _scrollController,)))]):
                    const SizedBox();}),


                Consumer<BannerController>(builder: (context, bannerProvider, child){
                  return bannerProvider.promoBannerLeft != null?
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                      left:Dimensions.homePagePadding, right: Dimensions.homePagePadding ),
                      child: SingleBannersWidget(bannerModel : bannerProvider.promoBannerLeft,
                          height: MediaQuery.of(context).size.width * .90)):const SizedBox();}),




                const Padding(padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                    child: RecommendedProductWidget(fromAsterTheme: true)),



                const LatestProductListWidget(),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                Consumer<BannerController>(builder: (context, bannerProvider, child){
                  return bannerProvider.promoBannerMiddleBottom != null?
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge,
                      left:Dimensions.homePagePadding, right: Dimensions.paddingSizeSmall ),
                      child: SingleBannersWidget(bannerModel : bannerProvider.promoBannerMiddleBottom,
                          height: MediaQuery.of(context).size.width/3)):const SizedBox();}),





                Consumer<ProductController>(
                    builder: (context, productController, _) {
                      return (productController.mostSearchingProduct != null && productController.mostSearchingProduct!.products != null &&
                          productController.mostSearchingProduct!.products!.isNotEmpty)?
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          TitleRowWidget(title: getTranslated('your_most_searching', context),
                              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                              const MostSearchingProductListWidget()))),
                          JustForYouView(productList: productController.mostSearchingProduct?.products),
                        ]):const SizedBox();}),




                Consumer<ProductController>(
                  builder: (context, demandProvider, _) {
                    return demandProvider.mostDemandedProductModel != null?
                    InkWell(onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>
                        ProductDetails(productId: demandProvider.mostDemandedProductModel?.productId,
                            slug: demandProvider.mostDemandedProductModel?.slug))),
                      child: Padding(padding: const EdgeInsets.all(Dimensions.homePagePadding),
                        child: Column(children: [
                          Text(getTranslated('most_demanded_product', context)!,
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          const MostDemandedProductView()]))): const SizedBox();}),



                if(Provider.of<AuthController>(Get.context!, listen: false).isLoggedIn())
                Consumer<SellerProductController>(
                  builder: (context, shopAgainProvider,_) {
                    return shopAgainProvider.shopAgainFromRecentStoreList.isNotEmpty?
                    Padding(padding: const EdgeInsets.only(top: Dimensions.homePagePadding),
                      child: Column(children: [
                        TitleRowWidget(title: getTranslated('shop_again_from_recent_store', context),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>
                            const ShopAgainFromRecentStoreListWidget()))),
                        const SizedBox(height: 160, child: ShopAgainFromYourRecentStore()),
                        const SizedBox(height: Dimensions.paddingSizeDefault)])):const SizedBox();}),


                Consumer<BannerController>(builder: (context, bannerProvider, child){
                  return bannerProvider.promoBannerRight != null?
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                      left:Dimensions.bannerPadding, right: Dimensions.bannerPadding ),
                      child: SingleBannersWidget(bannerModel : bannerProvider.promoBannerRight,
                          height: MediaQuery.of(context).size.width * 1.5)):const SizedBox();}),


                Consumer<BannerController>(builder: (context, bannerProvider, child){
                  return bannerProvider.promoBannerBottom != null?
                  Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding ),
                      child: SingleBannersWidget(noRadius: true, bannerModel : bannerProvider.promoBannerBottom,
                          height: MediaQuery.of(context).size.width / 10)):const SizedBox();}),




                Consumer<ShopController>(
                  builder: (context, moreSellerProvider, _) {
                    return moreSellerProvider.moreStoreList.isNotEmpty?
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: TitleRowWidget(title: getTranslated('other_store', context),
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            const MoreStoreViewListView()))),),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                       SizedBox(height: ResponsiveHelper.isTab(context)? 170 : 100, child: const MoreStoreView(isHome: true,)),
                    ],):const SizedBox();}),





                Container(decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.125)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(padding: const EdgeInsets.only(top: Dimensions.homePagePadding, bottom: Dimensions.paddingSizeSmall),
                      child: TitleRowWidget(title : getTranslated('all_products', context)!)),

                    Consumer<ProductController>(
                      builder: (context, productController, _) {
                        return Padding(padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeSmall),
                          child: SizedBox(height: 35,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: productController.productTypeList.length,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index){
                                  return InkWell(
                                    onTap: ()=> productController.changeTypeOfProduct(productController.productTypeList[index].productType,
                                      productController.productTypeList[index].title, index: index),
                                    child: Padding(padding: EdgeInsets.only(
                                        left : Provider.of<LocalizationController>(context, listen: false).isLtr ?
                                    Dimensions.paddingSizeDefault : 0,
                                        right: index+1 == productController.productTypeList.length? Dimensions.paddingSizeDefault :
                                        Provider.of<LocalizationController>(context, listen: false).isLtr ?
                                        0 : Dimensions.paddingSizeDefault),
                                      child: Container(padding: const EdgeInsets.symmetric(vertical : Dimensions.paddingSizeExtraSmall,
                                          horizontal: Dimensions.paddingSizeDefault),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                                              color: Theme.of(context).cardColor,
                                              border: Border.all(width: 1, color: index == productController.selectedProductTypeIndex?
                                              Theme.of(context).primaryColor.withOpacity(.5) :
                                              Theme.of(context).cardColor)),
                                          child: Center(child: Text('${getTranslated(productController.productTypeList[index].title!, context)}',
                                              style: textMedium.copyWith(color: index == productController.selectedProductTypeIndex?
                                              Theme.of(context).primaryColor : Theme.of(context).hintColor)))))
                                  );
                                })));
                      }),


                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: ProductListWidget(isHomePage: false,
                          productType: ProductType.newArrival, scrollController: _scrollController)),
                    const SizedBox(height: Dimensions.homePagePadding)])),
              ],
              ),
            )
          ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}
