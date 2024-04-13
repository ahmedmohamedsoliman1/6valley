import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/controllers/address_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/address_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/controllers/checkout_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/address/widgets/address_type_widget.dart';
import 'package:provider/provider.dart';
import 'add_new_address_screen.dart';



class SavedBillingAddressListScreen extends StatefulWidget {
  const SavedBillingAddressListScreen({super.key});
  @override
  State<SavedBillingAddressListScreen> createState() => _SavedBillingAddressListScreenState();
}

class _SavedBillingAddressListScreenState extends State<SavedBillingAddressListScreen> {
  @override
  void initState() {
    Provider.of<AddressController>(context, listen: false).getAddressList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const AddNewAddressScreen(isBilling: true))),
        backgroundColor: ColorResources.getPrimary(context),
        child: Icon(Icons.add, color: Theme.of(context).highlightColor)),

      appBar: CustomAppBar(title: getTranslated('BILLING_ADDRESS_LIST', context),),

      body: SafeArea(child: Consumer<AddressController>(
        builder: (context, locationProvider, child) {
          return SingleChildScrollView(
            child: Column(children: [
              locationProvider.addressList != null? locationProvider.addressList!.isNotEmpty ?

              ListView.builder(physics: const NeverScrollableScrollPhysics(),
                itemCount: locationProvider.addressList?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(onTap: () {Provider.of<CheckoutController>(context, listen: false).setBillingAddressIndex(index);
                    Navigator.pop(context);
                    },
                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Container(margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                          border: index == Provider.of<CheckoutController>(context).billingAddressIndex ?
                          Border.all(width: 2, color: Theme.of(context).primaryColor) : null,),
                        child: AddressTypeWidget(address: locationProvider.addressList?[index]))));}) :

              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                 child: Center(child: Container(alignment: Alignment.center,
                     margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                     child: const NoInternetOrDataScreenWidget(isNoInternet: false,
                         message: 'no_address_found', icon: Images.noAddress))),
               ): const  AddressShimmerWidget(),
              ],
            ),
          );
        },
      )),
    );
  }
}
