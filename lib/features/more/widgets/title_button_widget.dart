import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class MenuButtonWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final bool isNotification;
  final bool isProfile;
  const MenuButtonWidget({super.key, required this.image, required this.title, required this.navigateTo,
    this.isNotification = false, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        trailing: isNotification? Consumer<NotificationController>(
            builder: (context, notificationController, _) {
              return CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
                child: Text(notificationController.notificationModel?.newNotificationItem.toString() ?? '0',
                    style: textRegular.copyWith(color: ColorResources.white, fontSize: Dimensions.fontSizeSmall)),
              );}):

        isProfile? Consumer<ProfileController>(
            builder: (context, profileProvider, _) {
              return CircleAvatar(radius: 12, backgroundColor: Theme.of(context).primaryColor,
                  child: Text(profileProvider.userInfoModel?.referCount.toString() ?? '0',
                      style: textRegular.copyWith(color: ColorResources.white,
                          fontSize: Dimensions.fontSizeSmall)));}):
        const SizedBox(),


        leading: Image.asset(image, width: 25, height: 25, fit: BoxFit.fill,
          color: Theme.of(context).primaryColor.withOpacity(.6),),
        title: Text(title!, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo)));
  }
}