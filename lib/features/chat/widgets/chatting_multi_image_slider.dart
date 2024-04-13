import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class ChattingMultiImageSlider extends StatefulWidget {
  final List<String> images;
  const ChattingMultiImageSlider({super.key, required this.images});

  @override
  State<ChattingMultiImageSlider> createState() => _ChattingMultiImageSliderState();
}

class _ChattingMultiImageSliderState extends State<ChattingMultiImageSlider> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Stack(children: [
          SizedBox(height: width , width: width,
            child: CarouselSlider.builder(
              options: CarouselOptions(
                  aspectRatio: 4/1,
                  viewportFraction: 0.8,
                  autoPlay: false,
                  enlargeFactor: .2,
                  enlargeCenterPage: true,
                  disableCenter: true,
                  onPageChanged: (index, reason) {
                  }),
              itemCount:  widget.images.length,
              itemBuilder: (context, index, _) {
                String baseUrl ="${AppConstants.baseUrl}/storage/app/public/chatting";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                        child: CustomImageWidget(image: "$baseUrl/${widget.images[index]}"),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(icon: Icon(Icons.cancel,size: 50, color: Theme.of(context).primaryColor,),
                    onPressed: () => Navigator.of(context).pop()),
              )),

        ],
        ),

      ],
      ),
    );
  }
}
