
abstract class WalletServiceInterface {

  Future<dynamic> getWalletTransactionList(int offset, String type);

  Future<dynamic> addFundToWallet(String amount, String paymentMethod);

  Future<dynamic> getWalletBonusBannerList();
}