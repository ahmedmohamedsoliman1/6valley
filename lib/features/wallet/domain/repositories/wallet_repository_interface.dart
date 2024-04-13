import 'package:flutter_sixvalley_ecommerce/interface/repo_interface.dart';

abstract class WalletRepositoryInterface<T> extends RepositoryInterface{

  Future<dynamic> getWalletTransactionList(int offset, String type);

  Future<dynamic> addFundToWallet(String amount, String paymentMethod);

  Future<dynamic> getWalletBonusBannerList();
}