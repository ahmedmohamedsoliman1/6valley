import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final Color indicatorColor;
  final Color selectedIndicatorColor;
  OnBoardingScreen({super.key, this.indicatorColor = Colors.grey, this.selectedIndicatorColor = Colors.black});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingController>(context, listen: false).getOnBoardingList();


    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Consumer<OnBoardingController>(
        builder: (context, onBoardingList, child) {
          return Stack(clipBehavior: Clip.none, children: [

              Consumer<OnBoardingController>(
                builder: (context, onBoardingList, child) => ListView(children: [
                    SizedBox(height: height*0.7,
                      child: PageView.builder(
                        itemCount: onBoardingList.onBoardingList.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end, children: [
                                Image.asset(onBoardingList.onBoardingList[index].imageUrl,),
                                Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                                  child: Text(onBoardingList.onBoardingList[index].title,
                                      style: titilliumBold.copyWith(fontSize: 18), textAlign: TextAlign.center),),
                                Text(onBoardingList.onBoardingList[index].description,
                                    textAlign: TextAlign.center, style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault)),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],
                            ),
                          );
                        },
                        onPageChanged: (index) {
                          if(index != onBoardingList.onBoardingList.length){
                            onBoardingList.changeSelectIndex(index);
                          }else{
                            Provider.of<SplashController>(context, listen: false).disableIntro();
                            Provider.of<AuthController>(context, listen: false).getGuestIdUrl();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                          }
                        })),


                  onBoardingList.selectedIndex == onBoardingList.onBoardingList.length - 1?
                  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Center(child: SizedBox(width: 100,child: CustomButton(
                      textColor: Theme.of(context).primaryColor,
                        radius: 5,backgroundColor: Theme.of(context).primaryColor.withOpacity(.1),
                        buttonText: getTranslated("explore", context),
                    onTap: (){
                      Provider.of<SplashController>(context, listen: false).disableIntro();
                      Provider.of<AuthController>(context, listen: false).getGuestIdUrl();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                    },))))
                      :
                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                      child: Stack(children: [
                        if(onBoardingList.onBoardingList.isNotEmpty)
                        Center(child: SizedBox(height: 50, width: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor.withOpacity(.6)),
                              value: (onBoardingList.selectedIndex + 1) / onBoardingList.onBoardingList.length,
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(.125)))),

                    Align(alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (onBoardingList.selectedIndex == onBoardingList.onBoardingList.length - 1) {
                            Provider.of<SplashController>(context, listen: false).disableIntro();
                            Provider.of<AuthController>(context, listen: false).getGuestIdUrl();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                          } else {
                            _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                          }
                        },
                        child: Container(height: 40, width: 40,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: const BoxDecoration(shape: BoxShape.circle,),
                          child: Icon(onBoardingList.selectedIndex == onBoardingList.onBoardingList.length - 1 ? Icons.check : Icons.navigate_next,
                            color: Theme.of(context).primaryColor, size: 30)))),
                  ]),
                )
              ],
            ),
          ),

              if(onBoardingList.selectedIndex != onBoardingList.onBoardingList.length - 1)
              Positioned(child: Align(alignment: Alignment.topRight, child: InkWell(
                onTap: (){
                  Provider.of<SplashController>(context, listen: false).disableIntro();
                  Provider.of<AuthController>(context, listen: false).getGuestIdUrl();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                },
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  child: Text('${getTranslated('skip', context)}',
                      style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor))))))
            ],
          );
        }
      ),
    );
  }

}
