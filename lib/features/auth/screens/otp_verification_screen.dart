import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/controllers/order_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/reset_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  final String tempToken;
  final String mobileNumber;
  final String? email;
  final bool fromForgetPassword;
  final bool fromDigitalProduct;
  final int? orderId;

  const VerificationScreen(this.tempToken, this.mobileNumber, this.email,
      {super.key, this.fromForgetPassword = false,  this.fromDigitalProduct = false, this.orderId});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  int? _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = Provider.of<AuthController>(context, listen: false).resendTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds! - 1;
      if(_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }



  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    int minutes = (_seconds! / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');

    return Scaffold(

      body: Consumer<SplashController>(
          builder: (context, splashProvider, _) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Consumer<AuthController>(
                builder: (context, authProvider, child) => Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    widget.fromDigitalProduct? CustomAppBar(title: '${getTranslated('verify_otp', context)}'): const SizedBox(),
                    const SizedBox(height: 55),
                    Image.asset(Images.login, width: 100, height: 100,),
                    const SizedBox(height: 40),


                    Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Center(child: Text(widget.email == ''?
                      '${getTranslated('please_enter_4_digit_code', context)}\n${widget.mobileNumber}':
                      '${getTranslated('please_enter_4_digit_code', context)}\n${widget.email}',
                        textAlign: TextAlign.center,)),),


                    Padding(padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                      child: PinCodeTextField(
                        length: 4,
                        appContext: context,
                        obscureText: false,
                        showCursor: true,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          fieldHeight: 63,
                          fieldWidth: 55,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: ColorResources.colorMap[200],
                          selectedFillColor: Colors.white,
                          inactiveFillColor: ColorResources.getSearchBg(context),
                          inactiveColor: ColorResources.colorMap[200],
                          activeColor: ColorResources.colorMap[400],
                          activeFillColor: ColorResources.getSearchBg(context),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        backgroundColor: Colors.transparent,
                        enableActiveFill: true,
                        onChanged: authProvider.updateVerificationCode,
                        beforeTextPaste: (text) {
                          return true;
                        },
                      ),
                    ),


                    if(_seconds! <= 0)
                      Column(children: [
                        Center(child: Text(getTranslated('i_didnt_receive_the_code', context)!,)),


                        Center(child: InkWell(onTap: () {
                          if(widget.fromForgetPassword){
                            authProvider.forgetPassword(widget.mobileNumber).then((value) {
                              if (value.response?.statusCode == 200) {
                                _startTimer();
                              }
                            });
                          }
                          else if(widget.email!.isNotEmpty){
                            authProvider.sendOtpToEmail(widget.email!, widget.tempToken, resendOtp: true).then((value) {
                              if (value.response?.statusCode == 200) {
                                _startTimer();
                                showCustomSnackBar('${getTranslated('otp_resent_successfully', context)}', context, isError: false);
                              }
                            });
                          }else if(widget.fromDigitalProduct){
                            Provider.of<OrderDetailsController>(context, listen: false).resentDigitalProductOtp(orderId: widget.orderId).then((value) {
                              if (value.response?.statusCode == 200) {
                                _startTimer();
                                showCustomSnackBar('${getTranslated('otp_resent_successfully', context)}', context, isError: false);
                              }
                            });

                          }else{
                            authProvider.sendOtpToPhone(widget.mobileNumber,widget.tempToken, fromResend: true).then((value) {
                              if (value.isSuccess) {
                                _startTimer();
                                showCustomSnackBar('${getTranslated('otp_resent_successfully', context)}', context, isError: false);
                              }
                            });
                          }},
                          child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                              child: Text(getTranslated('resend_code', context)??"",
                                  style: robotoBold.copyWith(color: Theme.of(context).primaryColor)))))]),





                    if(_seconds! > 0)
                      Text('${getTranslated('resend_code', context)} ${getTranslated('after', context)} ${_seconds! > 0 ? '$minutesStr:${_seconds! % 60}' : ''} ${'Sec'}'),



                    const SizedBox(height: 48),

                    if(widget.fromDigitalProduct)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: CustomButton(buttonText: getTranslated('verify', context),
                          onTap: (){
                            Provider.of<OrderDetailsController>(context, listen: false).verifyDigitalProductOtp(orderId: widget.orderId!,
                                otp: authProvider.verificationCode).then((value) {
                              if(value.response?.statusCode == 200) {
                                Navigator.of(context).pop();
                              }else {
                                showCustomSnackBar(getTranslated('input_valid_otp', context), context, isError: true);
                              }});})),

                    if(!widget.fromDigitalProduct)
                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: authProvider.isEnableVerificationCode ? !authProvider.isPhoneNumberVerificationButtonLoading ?
                        CustomButton(buttonText: getTranslated('verify', context),

                          onTap: () {
                            bool phoneVerification = splashProvider.configModel?.forgotPasswordVerification =='phone';
                            if(phoneVerification && widget.fromForgetPassword){
                              authProvider.verifyOtpForResetPassword(widget.mobileNumber).then((value) {
                                if(value.response?.statusCode == 200) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (_) => ResetPasswordScreen(mobileNumber: widget.mobileNumber,
                                          otp: authProvider.verificationCode)), (route) => false);
                                }else {
                                  showCustomSnackBar(getTranslated('input_valid_otp', context), context, isError: true);
                                }
                              });
                            }else{
                              if(splashProvider.configModel?.phoneVerification??false){
                                authProvider.verifyPhone(widget.mobileNumber,widget.tempToken).then((value) {
                                  if(value.response?.statusCode == 200) {
                                    showCustomSnackBar(getTranslated('sign_up_successfully_now_login', context), context, isError: false);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false);
                                  }
                                });
                              }
                              else{
                                authProvider.verifyEmail(widget.email!,widget.tempToken).then((value) {
                                  if(value.response?.statusCode == 200) {
                                    showCustomSnackBar(getTranslated('sign_up_successfully_now_login', context), context, isError: false);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false);
                                  }
                                });
                              }
                            }
                          },
                        ):  Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                            : const SizedBox.shrink(),
                      )


                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
