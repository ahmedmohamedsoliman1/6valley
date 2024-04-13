import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/animated_custom_dialog_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/checkout/widgets/order_place_dialog_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddFundToWalletScreen extends StatefulWidget {
  final String url;
  const AddFundToWalletScreen({super.key, required this.url});
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<AddFundToWalletScreen> {
  String? selectedUrl;
  double value = 0.0;
  final bool _isLoading = true;

  late WebViewController controllerGlobal;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(context);
    if(Platform.isAndroid){
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        ));
      }
    }


    await browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(selectedUrl??'')),
    settings: InAppBrowserClassSettings(
    webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
    browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: Platform.isAndroid)));
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(title: const Text(''),backgroundColor: Theme.of(context).cardColor),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
          _isLoading ? Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
            ) : const SizedBox.shrink()])),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      Navigator.of(Get.context!).pop();
      showAnimatedDialog(Get.context!, OrderPlaceDialogWidget(
        icon: Icons.clear,
        title: getTranslated('payment_cancelled', Get.context!),
        description: getTranslated('your_payment_cancelled', Get.context!),
        isFailed: true,
      ), dismissible: false, willFlip: true);
      return Future.value(true);
    }
  }
}



class MyInAppBrowser extends InAppBrowser {

  final BuildContext context;

  MyInAppBrowser(this.context, {
    super.windowId,
    super.initialUserScripts,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
  }

  @override
  Future onLoadStart(url) async {
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      Navigator.of(context).pop();
      showAnimatedDialog(context, OrderPlaceDialogWidget(
        icon: Icons.clear,
        title: getTranslated('payment_failed', context),
        description: getTranslated('your_payment_failed', context),
        isFailed: true,
      ), dismissible: false, willFlip: true);
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
  }

  @override
  void onConsoleMessage(consoleMessage) {
  }

  void _pageRedirect(String url) {
    if(_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(AppConstants.baseUrl);
      bool isFailed = url.contains('fail') && url.contains(AppConstants.baseUrl);
      bool isCancel = url.contains('cancel') && url.contains(AppConstants.baseUrl);
      if(isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }
      if(isSuccess){
        Navigator.of(context).pop();
        showAnimatedDialog(context, OrderPlaceDialogWidget(icon: Icons.done,
          title: getTranslated('fund_added_into_wallet', context),
          description: getTranslated('your_fund_successfully_added_to_your_wallet', context),
        ), dismissible: false, willFlip: true);
      }else if(isFailed) {
        Navigator.of(context).pop();
        showAnimatedDialog(context, OrderPlaceDialogWidget(
          icon: Icons.clear, title: getTranslated('payment_failed', context),
          description: getTranslated('your_payment_failed', context),
          isFailed: true,), dismissible: false, willFlip: true);
      }else if(isCancel) {
        Navigator.of(context).pop();
        showAnimatedDialog(context, OrderPlaceDialogWidget(
          icon: Icons.clear,
          title: getTranslated('payment_cancelled', context),
          description: getTranslated('your_payment_cancelled', context),
          isFailed: true,
        ), dismissible: false, willFlip: true);
      }
    }
  }
}