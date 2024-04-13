import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'marque_text_widget.dart';
class AnnouncementWidget extends StatelessWidget {
  final Announcement? announcement;
  const AnnouncementWidget({super.key, this.announcement});

  @override
  Widget build(BuildContext context) {
    String color = announcement!.color!.replaceAll('#', '0xff');
    String textColor = announcement!.textColor!.replaceAll('#', '0xff');
    return Container(decoration: BoxDecoration(color: Color(int.parse(color))),
        child: Row(children: [
          Expanded(child: MarqueeWidget(direction: Axis.horizontal,
              animationDuration: Duration(seconds: (announcement!.announcement!.length * .15).ceil()),
              backDuration: Duration(seconds: (announcement!.announcement!.length * .15).ceil()),
              pauseDuration: const Duration(seconds: 0),
              child: Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                  child: Text(announcement?.announcement??'',
                      style: TextStyle(color: Color(int.parse(textColor))))))),

          Container( width: 40, padding: const EdgeInsets.all(10), child: Center(
                child: InkWell(onTap: ()=> Provider.of<SplashController>(context,listen: false).changeAnnouncementOnOff(false),
                    child: Icon(Icons.clear, color: Color(int.parse(textColor)))),
              ),
            ),
          ],
        ));
  }
}
