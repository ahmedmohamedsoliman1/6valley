
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/just_for_you/just_for_you_product_card_widget.dart';
import 'package:provider/provider.dart';

class JustForYouView extends StatefulWidget {
  final List<Product>? productList;
   const JustForYouView({super.key, required this.productList});

  @override
  State<JustForYouView> createState() => _JustForYouViewState();
}

class _JustForYouViewState extends State<JustForYouView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, productController,_) {
        return Column(children: [
          SizedBox(height: 400,
            child: Swiper(autoplay: true,
              layout: SwiperLayout.TINDER,
              itemWidth: MediaQuery.of(context).size.width-60,
              itemHeight: 400.0,
              itemBuilder: (BuildContext context,int index)=> JustForYouProductCard(widget.productList![index], index: index),
              itemCount: widget.productList!.length))]);
      }
    );
  }
}
