import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';

class GuestUserContactInformationWidget extends StatefulWidget {
  const GuestUserContactInformationWidget({super.key});

  @override
  State<GuestUserContactInformationWidget> createState() => _GuestUserContactInformationWidgetState();
}

class _GuestUserContactInformationWidgetState extends State<GuestUserContactInformationWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('contact_information', context),),

      body: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: ListView(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomTextFieldWidget(controller: nameController,
            prefixIcon: Images.user,
            hintText: getTranslated('order_id', context),
              validator: (value) =>ValidateCheck.validateEmptyText(value, "please_enter_your_name"),
            labelText: getTranslated('order_id', context),),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          CustomTextFieldWidget(
            prefixIcon: Images.callIcon,
            controller: phoneNumberController,
            hintText: '123 1235 123',
            labelText: '${getTranslated('phone_number', context)}',),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          CustomTextFieldWidget(controller: emailNumberController,
            prefixIcon: Images.email,
            hintText: getTranslated('email', context),
            validator: (value) =>ValidateCheck.validateEmail(value),
            labelText: getTranslated('email', context),),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          CustomButton(buttonText: '${getTranslated('search_order', context)}'),


        ],),
      ),
    );
  }
}
