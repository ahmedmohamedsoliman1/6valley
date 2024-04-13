import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';

class ImageDialog extends StatelessWidget {
  final String imageUrl;
  const ImageDialog({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

          Stack(children: [
              CustomImageWidget(image: imageUrl),
            Align(alignment: Alignment.centerRight,
                child: IconButton(icon: Icon(Icons.cancel, color: Theme.of(context).hintColor,),
                    onPressed: () => Navigator.of(context).pop())),

            ],
          ),

        ],
      ),
    );
  }
}
