import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:shimmer/shimmer.dart';

class TransactionShimmer extends StatelessWidget {
  const TransactionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {

        return Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
          highlightColor: Colors.grey[300]!,
          enabled: true,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
             const InkWell(child: CircleAvatar(child: Icon(Icons.person))),
            Expanded(child: Column(children: [
                Container(margin:  const EdgeInsets.fromLTRB(10, 5, 50, 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration:  BoxDecoration(color:  ColorResources.iconBg()),
                  child: Container(height: 20)),
                const SizedBox(height: 15),
                Row(children: [
                    Container(height: 15,width: 120, color: ColorResources.iconBg())]),
                const Padding(padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Divider(thickness: .5))
              ],
            ))]),
        );
      },
    );
  }
}