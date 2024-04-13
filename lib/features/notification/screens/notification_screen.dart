import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/notification_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/widget/notification_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/paginated_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  final bool fromNotification;
  const NotificationScreen({super.key,  this.fromNotification = false});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    if(widget.fromNotification){
      Provider.of<SplashController>(context, listen: false).initConfig(context).then((value){
        Provider.of<NotificationController>(context, listen: false).getNotificationList(1);
      });
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:  CustomAppBar(title: getTranslated('notification', context), onBackPressed: (){
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen()));
        }
      }),

      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          return notificationController.notificationModel != null ?
          (notificationController.notificationModel!.notification != null &&
              notificationController.notificationModel!.notification!.isNotEmpty) ?
          RefreshIndicator(onRefresh: () async => await notificationController.getNotificationList(1),
            child: SingleChildScrollView(
              controller: scrollController,
              child: PaginatedListView(
                 scrollController: scrollController,
                onPaginate: (int? offset) {  },
                totalSize: notificationController.notificationModel?.totalSize,
                offset:  notificationController.notificationModel?.offset,
                itemView: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notificationController.notificationModel!.notification!.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) =>
                      NotificationItemWidget(notificationItem: notificationController.notificationModel!.notification![index]),
                )))) : const NoInternetOrDataScreenWidget(isNoInternet: false,
            message: 'no_notification', icon: Images.noNotification,) : const NotificationShimmerWidget();
        }));
  }
}





