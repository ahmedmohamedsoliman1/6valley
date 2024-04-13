import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:provider/provider.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String mobileNumber;
  final String otp;
  const ResetPasswordScreen({super.key,required this.mobileNumber,required this.otp});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _confirmPasswordNode = FocusNode();
  GlobalKey<FormState>? _formKeyReset;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }


  void resetPassword() async {
      String password = _passwordController!.text.trim();
      String confirmPassword = _confirmPasswordController!.text.trim();

      if (password.isEmpty) {
        showCustomSnackBar(getTranslated('password_must_be_required', context), context);
      } else if (confirmPassword.isEmpty) {
        showCustomSnackBar(getTranslated('confirm_password_must_be_required', context), context);
      }else if (password != confirmPassword) {
        showCustomSnackBar(getTranslated('password_did_not_match', context), context);
      } else {
        Provider.of<AuthController>(context, listen: false).resetPassword(widget.mobileNumber,widget.otp, password, confirmPassword);
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: _formKeyReset,
        child: ListView(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall), children: [
            Padding(padding: const EdgeInsets.all(50),
              child: Image.asset(Images.logoWithNameImage, height: 150, width: 200),),

            Padding(padding: const EdgeInsets.all(Dimensions.marginSizeLarge),
              child: Text(getTranslated('password_reset', context)!, style: titilliumSemiBold)),

            Container(margin: const EdgeInsets.only(
                left: Dimensions.marginSizeLarge,
                right: Dimensions.marginSizeLarge,
                bottom: Dimensions.marginSizeSmall),
                child: CustomTextFieldWidget(
                  hintText: getTranslated('new_password', context),
                  focusNode: _newPasswordNode,
                  nextFocus: _confirmPasswordNode,
                  isPassword: true,
                  controller: _passwordController)),


            Container(margin: const EdgeInsets.only(
                left: Dimensions.marginSizeLarge,
                right: Dimensions.marginSizeLarge,
                bottom: Dimensions.marginSizeDefault),
                child: CustomTextFieldWidget(
                  isPassword: true,
                  hintText: getTranslated('confirm_password', context),
                  inputAction: TextInputAction.done,
                  focusNode: _confirmPasswordNode,
                  controller: _confirmPasswordController)),


            Container(margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: Provider.of<AuthController>(context).isLoading ?
              Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                  : CustomButton(onTap: resetPassword, buttonText: getTranslated('reset_password', context))),

          ],
        ),
      ),
    );
  }
}
