import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/models/brand_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/domain/models/category_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/controllers/search_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class ProductFilterDialog extends StatefulWidget {
  final int? sellerId;
  final bool fromShop;
  const ProductFilterDialog({super.key, this.sellerId,  this.fromShop = true});

  @override
  ProductFilterDialogState createState() => ProductFilterDialogState();
}

class ProductFilterDialogState extends State<ProductFilterDialog> {

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('key'),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
            child: Column( mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: Dimensions.paddingSizeSmall),

              InkWell(onTap: ()=> Navigator.of(context).pop(),
                child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const SizedBox(width: 35,),
                        Container(width: 35,height: 4,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                            color: Theme.of(context).hintColor.withOpacity(.5))),

                      Icon(Icons.clear, color: Theme.of(context).hintColor)])))),

              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const SizedBox(width: 60),
                  Text(getTranslated('filter', context)??'',
                      style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                  InkWell(onTap: ()=> Provider.of<CategoryController>(context, listen: false).resetChecked(widget.fromShop?widget.sellerId!: null, widget.fromShop),
                    child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        SizedBox(width: 20, child: Image.asset(Images.reset)),
                        Text('${getTranslated('reset', context)}', style: textRegular.copyWith(color: Theme.of(context).primaryColor))])))])),


              Consumer<SearchProductController>(
                  builder: (context, searchProvider, child) {
                    return Consumer<CategoryController>(
                        builder: (context, categoryProvider,_) {
                          return Consumer<BrandController>(
                              builder: (context, brandProvider,_) {
                                return Consumer<SellerProductController>(
                                    builder: (context, productController,_) {
                                      return SingleChildScrollView(
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min, children: [


                                            Text(getTranslated('CATEGORY', context)??'',
                                                style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                            Divider(color: Theme.of(context).hintColor.withOpacity(.25), thickness: .5),

                                            if(categoryProvider.categoryList.isNotEmpty)
                                              ListView.builder(
                                                  itemCount: categoryProvider.categoryList.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index){
                                                    return Column(children: [

                                                      CategoryFilterItem(title: categoryProvider.categoryList[index].name,
                                                          checked: categoryProvider.categoryList[index].isSelected!,
                                                          onTap: () => categoryProvider.checkedToggleCategory(index)),
                                                      if(categoryProvider.categoryList[index].isSelected!)
                                                        Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraLarge),
                                                          child: ListView.builder(itemCount: categoryProvider.categoryList[index].subCategories?.length??0,
                                                              shrinkWrap: true,
                                                              padding: EdgeInsets.zero,
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              itemBuilder: (context, subIndex){
                                                                return CategoryFilterItem(title: categoryProvider.categoryList[index].subCategories![subIndex].name,
                                                                    checked: categoryProvider.categoryList[index].subCategories![subIndex].isSelected!,
                                                                    onTap: () => categoryProvider.checkedToggleSubCategory(index, subIndex));
                                                              }),
                                                        )
                                                    ],
                                                    );
                                                  }),


                                            Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                                child: Text(getTranslated('brand', context)??'',
                                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge))),

                                            Divider(color: Theme.of(context).hintColor.withOpacity(.25), thickness: .5),

                                            if(brandProvider.brandList.isNotEmpty)
                                              ListView.builder(
                                                  itemCount: brandProvider.brandList.length,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index){
                                                    return CategoryFilterItem(title: brandProvider.brandList[index].name,
                                                        checked: brandProvider.brandList[index].checked!,
                                                        onTap: () => brandProvider.checkedToggleBrand(index));
                                                  }),


                                            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                              child: CustomButton(buttonText: getTranslated('apply', context),
                                                onTap: () {
                                                  searchProvider.setFilterApply();
                                                  List<int> selectedBrandIdsList =[];
                                                  List<int> selectedCategoryIdsList =[];

                                                  for(CategoryModel category in categoryProvider.categoryList){
                                                    if(category.isSelected!){
                                                      selectedCategoryIdsList.add(category.id!);
                                                    }
                                                  }
                                                  for(CategoryModel category in categoryProvider.categoryList){
                                                    if(category.isSelected!){
                                                      if(category.subCategories != null){
                                                        for(int i=0; i< category.subCategories!.length; i++){
                                                          selectedCategoryIdsList.add(category.subCategories![i].id!);
                                                        }
                                                      }

                                                    }
                                                  }
                                                  for(BrandModel brand in brandProvider.brandList){
                                                    if(brand.checked!){
                                                      selectedBrandIdsList.add(brand.id!);
                                                    }
                                                  }

                                                  if(selectedCategoryIdsList.isEmpty && selectedBrandIdsList.isEmpty){
                                                    showCustomSnackBar('${getTranslated('select_brand_or_category_first', context)}', context, isToaster: true);
                                                  }else{
                                                    String selectedCategoryId = selectedCategoryIdsList.isNotEmpty? jsonEncode(selectedCategoryIdsList) : '[]';
                                                    String selectedBrandId = selectedBrandIdsList.isNotEmpty? jsonEncode(selectedBrandIdsList) : '[]';
                                                    if(widget.fromShop){
                                                      productController.getSellerProductList(widget.sellerId.toString(), 1, "",categoryIds: selectedCategoryId, brandIds: selectedBrandId).then((value) {
                                                        if(value.response?.statusCode == 200){
                                                          Navigator.pop(context);
                                                        }
                                                      });
                                                    }else{
                                                      searchProvider.searchProduct(query : searchProvider.searchController.text.toString(),
                                                          offset: 1, brandIds: selectedBrandId, categoryIds: selectedCategoryId, sort: searchProvider.sortText,
                                                          priceMin: searchProvider.minPriceForFilter.toString(), priceMax: searchProvider.maxPriceForFilter.toString());
                                                      Navigator.pop(context);
                                                    }


                                                  }

                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              }
                          );
                        }
                    );
                  }
              ),

            ]),
          ),
        ),
      ),
    );
  }
}

class FilterItemWidget extends StatelessWidget {
  final String? title;
  final int index;
  const FilterItemWidget({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Row(children: [
          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(
                onTap: ()=> Provider.of<SearchProductController>(context, listen: false).setFilterIndex(index),
                child: Icon(Provider.of<SearchProductController>(context).filterIndex == index? Icons.check_box_rounded: Icons.check_box_outline_blank_rounded,
                    color: (Provider.of<SearchProductController>(context).filterIndex == index )? Theme.of(context).primaryColor: Theme.of(context).hintColor.withOpacity(.5))),
          ),
          Expanded(child: Text(title??'', style: textRegular.copyWith())),

        ],),),
    );
  }
}

class CategoryFilterItem extends StatelessWidget {
  final String? title;
  final bool checked;
  final Function()? onTap;
  const CategoryFilterItem({super.key, required this.title, required this.checked, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
        child: Row(children: [
          Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            child: InkWell(
                onTap: onTap,
                child: Icon(checked? Icons.check_box_rounded: Icons.check_box_outline_blank_rounded,
                    color: (checked && !Provider.of<ThemeController>(context, listen: false).darkTheme)?
                    Theme.of(context).primaryColor:(checked && Provider.of<ThemeController>(context, listen: false).darkTheme)?
                    Colors.white : Theme.of(context).hintColor.withOpacity(.5))),
          ),
          Expanded(child: Text(title??'', style: textRegular.copyWith())),

        ],),),
    );
  }
}

