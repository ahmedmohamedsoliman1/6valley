import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/controllers/contact_us_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/contact_us/domain/models/contact_us_body.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthController>(context, listen: false).setCountryCode(CountryCode.fromCountryCode(Provider.of<SplashController>(context, listen: false).configModel!.countryCode!).dialCode!, notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(centerTitle: true,title: '${getTranslated('contact_us', context)}'),
      body: Consumer<AuthController>(
        builder: (context, authProvider, _) {
          return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
            child: SingleChildScrollView(
              child: Column(children: [

                SizedBox(width: MediaQuery.of(context).size.width/2,child: Image.asset(Images.contactUsBg)),
                CustomTextFieldWidget(prefixIcon: Images.user,
                controller: fullNameController,
                required: true,
                labelText: getTranslated('full_name', context),
                hintText: getTranslated('enter_full_name', context)),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                CustomTextFieldWidget(hintText: getTranslated('email', context),
                prefixIcon: Images.email,
                  required: true,
                labelText: getTranslated('email', context),
                controller: emailController),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                CustomTextFieldWidget(
                  hintText: getTranslated('enter_mobile_number', context),
                  labelText: getTranslated('enter_mobile_number', context),
                  controller: phoneController,
                  required: true,
                  showCodePicker: true,
                  countryDialCode: authProvider.countryDialCode,
                  onCountryChanged: (CountryCode countryCode) {
                    authProvider.countryDialCode = countryCode.dialCode!;
                    authProvider.setCountryCode(countryCode.dialCode!);
                  },
                  isAmount: true,
                  inputAction: TextInputAction.next,
                  inputType: TextInputType.phone),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                CustomTextFieldWidget(
                  required: true,
                  labelText: getTranslated('subject', context),
                  hintText: getTranslated('subject', context),
                controller: subjectController,),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                CustomTextFieldWidget(maxLines: 5,
                  required: true,
                  controller: messageController,
                  labelText: getTranslated('message', context),
                  hintText: getTranslated('message', context)),
              ],),
            ),
          );
        }
      ),
      bottomNavigationBar: Consumer<ContactUsController>(
        builder: (context, profileProvider, _) {
          return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CustomButton(buttonText: getTranslated('send_request', context),
            onTap: (){
              String name = fullNameController.text.trim();
              String email = emailController.text.trim();
              String phone = phoneController.text.trim();
              String subject = subjectController.text.trim();
              String message = messageController.text.trim();
              if(name.isEmpty){
                showCustomSnackBar('${getTranslated('name_is_required', context)}', context);
              } else if(email.isEmpty){
                showCustomSnackBar('${getTranslated('email_is_required', context)}', context);
              } else if(phone.isEmpty){
                showCustomSnackBar('${getTranslated('phone_is_required', context)}', context);
              }else if(subject.isEmpty){
                showCustomSnackBar('${getTranslated('subject_is_required', context)}', context);
              }else if(message.isEmpty){
                showCustomSnackBar('${getTranslated('message_is_required', context)}', context);
              }else{
                ContactUsBody contactUsBody = ContactUsBody(name: name, email: email, phone: phone, subject: subject, message: message);
                profileProvider.contactUs(contactUsBody).then((value){
                  fullNameController.clear();
                  emailController.clear();
                  phoneController.clear();
                  subjectController.clear();
                  messageController.clear();
                });
              }
            },),
          );
        }
      ),
    );
  }
}
