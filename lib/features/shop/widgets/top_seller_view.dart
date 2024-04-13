import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/seller_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/seller_card.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:provider/provider.dart';



class TopSellerView extends StatefulWidget {
  final bool isHomePage;
  final ScrollController scrollController;
   const TopSellerView({super.key, required this.isHomePage, required this.scrollController});

  @override
  State<TopSellerView> createState() => _TopSellerViewState();
}

class _TopSellerViewState extends State<TopSellerView> {
  @override
  Widget build(BuildContext context) {
    return widget.isHomePage? Consumer<ShopController>(
      builder: (context, topSellerProvider, child) {
        return topSellerProvider.sellerModel != null? (topSellerProvider.sellerModel!.sellers != null && topSellerProvider.sellerModel!.sellers!.isNotEmpty) ?
            ListView.builder(
              itemCount: topSellerProvider.sellerModel?.sellers?.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: widget.isHomePage? Axis.horizontal : Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(width: 250,
                    child: SellerCard(sellerModel: topSellerProvider.sellerModel?.sellers?[index], isHomePage: widget.isHomePage,
                        index: index,length: topSellerProvider.sellerModel?.sellers?.length??0));
              },
            ) : const SizedBox():const TopSellerShimmer();

      },
    ):Consumer<ShopController>(
      builder: (context, topSellerProvider, child) {
        return topSellerProvider.sellerModel != null? (topSellerProvider.sellerModel!.sellers != null && topSellerProvider.sellerModel!.sellers!.isNotEmpty) ?
        SingleChildScrollView(
          controller: widget.scrollController,
          child: PaginatedListView(
            scrollController: widget.scrollController,
            onPaginate: (int? offset) async => await topSellerProvider.getTopSellerList(false, offset?? 1, type : topSellerProvider.sellerType),
            totalSize: topSellerProvider.sellerModel!.totalSize,
            offset: topSellerProvider.sellerModel!.offset,
            itemView: ListView.builder(
              itemCount: topSellerProvider.sellerModel?.sellers?.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: widget.isHomePage? Axis.horizontal : Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return SellerCard(sellerModel: topSellerProvider.sellerModel?.sellers?[index], isHomePage: widget.isHomePage,
                    index: index,length: topSellerProvider.sellerModel?.sellers?.length??0);
              },
            ),
          ),
        ) : const SizedBox():const SellerShimmer();

      },
    );
  }
}



