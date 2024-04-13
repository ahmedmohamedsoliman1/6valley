import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmerWidget extends StatelessWidget {
  const ChatShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: 20,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (context, index) {

          bool isMe = index % 2 == 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).cardColor,
              highlightColor: Theme.of(context).hintColor.withOpacity(.5),
              enabled: true,
              child: Column(children: [
                Container(height: 10,  width: 150,decoration: BoxDecoration(
                  color: Theme.of(context).hintColor, borderRadius: BorderRadius.circular(50))),
                  const SizedBox(height: 30,),
                  Row(mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start, children: [
                      isMe ? const SizedBox.shrink() : const InkWell(child: CircleAvatar(child: Icon(Icons.person))),
                      Expanded(child: Container(margin: isMe ?  EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/2.5, 5, 10, 5) :  EdgeInsets.fromLTRB(10, 5, MediaQuery.of(context).size.width/2.5, 5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(10),
                              bottomLeft: isMe ? const Radius.circular(10) : const Radius.circular(0),
                              bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(10),
                              topRight: const Radius.circular(10)),
                              color: Theme.of(context).hintColor.withOpacity(.5)),
                          child: Container(height: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}