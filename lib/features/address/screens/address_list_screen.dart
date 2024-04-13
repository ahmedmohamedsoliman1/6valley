import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/address_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/remove_address_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/screens/add_new_address_screen.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});
  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {

  @override
  void initState() {
    Provider.of<AddressController>(context, listen: false).getAddressList(all: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('addresses', context)),
      floatingActionButton: FloatingActionButton(
        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddNewAddressScreen(isBilling: false))),
        backgroundColor: ColorResources.getPrimary(context),
        child: Icon(Icons.add, color: Theme.of(context).highlightColor)),


      body: Consumer<AddressController>(
        builder: (context, locationProvider, child) {
          return  locationProvider.addressList != null? locationProvider.addressList!.isNotEmpty ?
          RefreshIndicator(onRefresh: () async => await locationProvider.getAddressList(),
            backgroundColor: Theme.of(context).primaryColor,
            child: ListView.builder(padding: const EdgeInsets.all(0),
              itemCount: locationProvider.addressList?.length,
              itemBuilder: (context, index){
              print('=====Address=====>>${locationProvider.addressList![index].toJson()}');
              return Padding(
                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, 0),
                child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                  child: Column(children: [

                    Row(children: [
                      Expanded(child: Text('${getTranslated('address', context)} : ${locationProvider.addressList?[index].address}',
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),),

                      InkWell(onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AddNewAddressScreen(
                        isBilling:  locationProvider.addressList?[index].isBilling,
                        address: locationProvider.addressList?[index], isEnableUpdate: true))),
                        child: Container(width: 40,
                          decoration: BoxDecoration(borderRadius:
                         BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor.withOpacity(.05)),
                          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            child: Image.asset(Images.edit),),),
                      ),
                    ]
                    ),

                    Row(children: [
                      Text('${getTranslated('city', context)} : ${locationProvider.addressList?[index].city ?? ""}',
                        style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Text('${getTranslated('zip', context)} : ${locationProvider.addressList?[index].zip ?? ""}',
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

                      const Spacer(),
                      InkWell(onTap: (){
                        showModalBottomSheet(backgroundColor: Colors.transparent, context: context, builder: (_)=>
                            RemoveFromAddressBottomSheet(addressId: locationProvider.addressList![index].id!, index: index));
                      },
                          child: const Padding(padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                              child: Icon(Icons.delete_forever, color: Colors.red, size: 30,)))


                    ]
                    ),
                  ],
                  ),
                ),
              );
              },
            ),
          ) : const NoInternetOrDataScreenWidget(isNoInternet: false,
            message: 'no_address_found',
            icon: Images.noAddress,): const AddressShimmerWidget();
        },
      ),
    );
  }
}
