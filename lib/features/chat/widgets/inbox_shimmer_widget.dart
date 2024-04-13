import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';



class InboxShimmerWidget extends StatelessWidget {
  const InboxShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemBuilder: (context, index) {
        return Padding(padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),
                color: ColorResources.iconBg(),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
            child: Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [
                  const CircleAvatar(radius: 40, child: Icon(Icons.person)),
                  Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Column(children: [
                        Container(height: 15, color: ColorResources.iconBg(),),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Container(height: 15, color: ColorResources.iconBg(),)]))),
                  Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.end,  children: [
                    Container(height: 10, width: 120, color: ColorResources.white),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Container(height: 10, width: 50,
                      decoration: BoxDecoration(color: Theme.of(context).cardColor)),
                  ])
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}