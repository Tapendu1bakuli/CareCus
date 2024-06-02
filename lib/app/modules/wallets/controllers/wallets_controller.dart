import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/wallet_model.dart';
import '../../../models/wallet_transaction_model.dart';
import '../../../repositories/payment_repository.dart';

class WalletsController extends GetxController {
  final wallets = <Wallet>[].obs;
  final walletTransactions = <WalletTransaction>[].obs;
  final selectedWallet = new Wallet().obs;
  PaymentRepository _paymentRepository;
  Rx<bool> loading = false.obs;
  WalletsController() {
    _paymentRepository = new PaymentRepository();
  }

  @override
  void onInit() async {
    await refreshWallets();
    super.onInit();
  }

  Future refreshWallets({bool showMessage}) async {
    await getWallets();
    initSelectedWallet();
    await getWalletTransactions();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "list_of_wallets_refreshed_successfully".tr));
    }
  }

  Future getWallets() async {
    loading.value = true;
    try {
      wallets.assignAll(await _paymentRepository.getWallets());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }finally{
      loading.value = false;
    }
  }

  Future getWalletTransactions() async {
    loading.value = true;
    try {
      walletTransactions.assignAll(await _paymentRepository.getWalletTransactions(selectedWallet.value));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }finally{
      loading.value = false;
    }
  }

  void initSelectedWallet() {
    if (!selectedWallet.value.hasData && wallets.isNotEmpty) {
      selectedWallet.value = wallets.elementAt(0);
    }
  }
}
