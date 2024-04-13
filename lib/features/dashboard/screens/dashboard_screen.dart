import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/models/navigation_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/dashboard_menu_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/widgets/app_exit_card_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/more/screens/more_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/screens/order_screen.dart';
import 'package:provider/provider.dart';



class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;
  late List<NavigationModel> _screens ;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final PageStorageBucket bucket = PageStorageBucket();

  bool singleVendor = false;
  @override
  void initState() {
    super.initState();
    singleVendor = Provider.of<SplashController>(context, listen: false).configModel!.businessMode == "single";

      _screens = [
        NavigationModel(
          name: 'home',
          icon: Images.homeImage,
          screen: (Provider.of<SplashController>(context, listen: false).configModel!.activeTheme == "default")?
        const HomePage():
       (Provider.of<SplashController>(context, listen: false).configModel!.activeTheme == "theme_aster")?
        const AsterThemeHomeScreen(): const FashionThemeHomePage()),

        if(!singleVendor)
          NavigationModel(name: 'inbox', icon: Images.messageImage, screen: const InboxScreen(isBackButtonExist: false)),
          NavigationModel(name: 'orders', icon: Images.shoppingImage, screen:  const OrderScreen(isBacButtonExist: false)),
          NavigationModel(name: 'more', icon: Images.moreImage, screen:  const MoreScreen()),

      ];




    NetworkInfo.checkConnectivity(context);

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) async {
        if(_pageIndex != 0) {
          _setPage(0);
          return;
        }else {
        showModalBottomSheet(backgroundColor: Colors.transparent,
            context: context, builder: (_)=> const AppExitCard());
        }
        return;
      },
      child: Scaffold(
        key: _scaffoldKey,

        body: PageStorage(bucket: bucket, child: _screens[_pageIndex].screen),
        bottomNavigationBar: Container(height: 68,
          decoration: BoxDecoration(borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.paddingSizeLarge)),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(offset: const Offset(1,1), blurRadius: 2, spreadRadius: 1,
                color: Theme.of(context).primaryColor.withOpacity(.125))],),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _getBottomWidget(singleVendor)))));
  }


  void _setPage(int pageIndex) {
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _getBottomWidget(bool isSingleVendor) {
    List<Widget> list = [];
    for(int index = 0; index < _screens.length; index++) {
      list.add(Expanded(child: CustomMenuWidget(
        isSelected: _pageIndex == index,
        name: _screens[index].name,
        icon: _screens[index].icon,
        onTap: () => _setPage(index))));
    }
    return list;
  }

}




