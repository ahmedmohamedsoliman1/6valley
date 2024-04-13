import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/success_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/otp_verification_screen.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _key = GlobalKey();
  final TextEditingController _numberController = TextEditingController();
  final FocusNode _numberFocus = FocusNode();
  String? _countryDialCode = '+880';

  @override
  void initState() {
    _countryDialCode = CountryCode.fromCountryCode(
        Provider.of<SplashController>(context, listen: false).configModel!.countryCode!).dialCode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,

      appBar: CustomAppBar(title: getTranslated('forget_password', context)),
      body: Consumer<AuthController>(
        builder: (context, authProvider,_) {
          return Consumer<SplashController>(
            builder: (context, splashProvider, _) {
              return ListView(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), children: [
                Center(child: Padding(padding: const EdgeInsets.all(50),
                    child: Image.asset(Images.logoWithNameImage, height: 150, width: 150))),
                Text(getTranslated('forget_password', context)!, style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),


                Row(children: [
                  Expanded(flex: 1, child: Divider(thickness: 1,
                      color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.2,
                      color: Theme.of(context).primaryColor))]),

                splashProvider.configModel!.forgotPasswordVerification == "phone"?
                Text(getTranslated('enter_phone_number_for_password_reset', context)!,
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeDefault)):
                Text(getTranslated('enter_email_for_password_reset', context)!,
                    style: titilliumRegular.copyWith(color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeDefault)),
                const SizedBox(height: Dimensions.paddingSizeLarge),




                splashProvider.configModel!.forgotPasswordVerification == "phone"?
                Container(margin: const EdgeInsets.only(top: Dimensions.marginSizeSmall),
                  child: CustomTextFieldWidget(
                    hintText: getTranslated('enter_mobile_number', context),
                    controller: _numberController,
                    focusNode: _numberFocus,
                    showCodePicker: true,
                    countryDialCode: authProvider.countryDialCode,
                    onCountryChanged: (CountryCode countryCode) {
                      authProvider.countryDialCode = countryCode.dialCode!;
                      authProvider.setCountryCode(countryCode.dialCode!);
                    },
                    isAmount: true,
                    validator: (value)=> ValidateCheck.validateEmptyText(value, "phone_must_be_required"),
                    inputAction: TextInputAction.next,
                    inputType: TextInputType.phone)) :

                CustomTextFieldWidget(
                  controller: _controller,
                  labelText: getTranslated('email', context),
                  hintText: getTranslated('enter_your_email', context),
                  inputAction: TextInputAction.done,
                  inputType: TextInputType.emailAddress),
                const SizedBox(height: 100),


                Builder(builder: (context) => !authProvider.isLoading ?
                  CustomButton(buttonText: splashProvider.configModel!.forgotPasswordVerification == "phone"?
                    getTranslated('send_otp', context):getTranslated('send_email', context),
                    onTap: () {
                      if(splashProvider.configModel!.forgotPasswordVerification == "phone"){
                        if(_numberController.text.isEmpty) {
                          showCustomSnackBar(getTranslated('phone_must_be_required', context), context);

                        }else{
                          authProvider.forgetPassword(_countryDialCode!+_numberController.text.trim()).then((value) {
                            if(value.response?.statusCode == 200) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                  builder: (_) => VerificationScreen('',
                                      _countryDialCode! +_numberController.text.trim(),'', fromForgetPassword: true)),
                                      (route) => false);
                            }else {
                              showCustomSnackBar(getTranslated('input_valid_phone_number', context), context);
                            }
                          });
                        }

                      }else{
                        if(_controller.text.isEmpty) {
                          showCustomSnackBar(getTranslated('email_is_required', context), context);
                        }
                        else {
                          authProvider.forgetPassword(_controller.text).then((value) {
                            if(value.response?.statusCode == 200) {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              _controller.clear();

                              showAnimatedDialog(context, SuccessDialog(
                                icon: Icons.send,
                                title: getTranslated('sent', context),
                                description: getTranslated('recovery_link_sent', context),
                                rotateAngle: 5.5,
                              ), dismissible: false);
                            }
                          });
                        }
                      }


                    },
                  ) : Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                ),
              ]);
            }
          );
        }
      ),
    );
  }
}

