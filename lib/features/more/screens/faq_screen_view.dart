import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:provider/provider.dart';
class FaqScreen extends StatefulWidget {
  final String? title;
  const FaqScreen({super.key, required this.title});

  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    var splashController = Provider.of<SplashController>(context, listen: false);
    return Scaffold(
      body: Column(children: [
        CustomAppBar(title: widget.title),

        splashController.configModel!.faq != null && splashController.configModel!.faq!.isNotEmpty? Expanded(
          child: ListView.builder(
              itemCount: Provider.of<SplashController>(context, listen: false).configModel!.faq!.length,
              itemBuilder: (ctx, index){
                return  Consumer<SplashController>(
                  builder: (ctx, faq, child){
                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                            Flexible(child: ExpansionTile(iconColor: Theme.of(context).primaryColor,
                              title: Text(faq.configModel!.faq![index].question!,
                                style: robotoBold.copyWith(color: ColorResources.getTextTitle(context))),
                              leading: Icon(Icons.collections_bookmark_outlined,color:ColorResources.getTextTitle(context)),
                              children: <Widget>[
                                Padding(padding: const EdgeInsets.all(8.0),
                                  child: Text(faq.configModel!.faq![index].answer!,style: textRegular, textAlign: TextAlign.justify))])),
                          ]),
                      ],);
                  },
                );
              }),
        ): const NoInternetOrDataScreenWidget(isNoInternet: false)

      ],),
    );
  }
}
