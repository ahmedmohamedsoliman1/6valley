import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/controllers/loyalty_point_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/domain/models/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/loyaltyPoint/widget/loyalty_point_widget.dart';
import 'package:provider/provider.dart';

class LoyaltyPointListViewWidget extends StatelessWidget {
  final ScrollController? scrollController;
  const LoyaltyPointListViewWidget({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Provider.of<LoyaltyPointController>(context, listen: false).loyaltyPointList.isNotEmpty
          && !Provider.of<LoyaltyPointController>(context, listen: false).isLoading) {
        int? pageSize;
        pageSize = Provider.of<LoyaltyPointController>(context, listen: false).loyaltyPointPageSize;

        if(offset < pageSize!) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<LoyaltyPointController>(context, listen: false).showBottomLoader();
          Provider.of<LoyaltyPointController>(context, listen: false).getLoyaltyPointList(context, offset);
        }
      }

    });

    return Consumer<LoyaltyPointController>(
      builder: (context, loyaltyProvider, child) {
        List<LoyaltyPointList> loyaltyPointList;
        loyaltyPointList = loyaltyProvider.loyaltyPointList;
        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          !loyaltyProvider.firstLoading ? (loyaltyPointList.isNotEmpty) ?
          Padding(padding: const EdgeInsets.only(bottom: 50.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: loyaltyPointList.length,
                itemBuilder: (ctx,index){
                  return LoyaltyPointWidget(loyaltyPointModel: loyaltyPointList[index],
                      index: index,length: loyaltyPointList.length);
              })):

          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/6),
            child: const NoInternetOrDataScreenWidget(isNoInternet: false, icon: Images.noTransaction,
              message: 'no_transaction_history')) :

          ProductShimmer(isHomePage: true ,isEnabled: loyaltyProvider.firstLoading),
          loyaltyProvider.isLoading ? Center(child: Padding(padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))) :
          const SizedBox.shrink(),

        ]);
      },
    );
  }
}
