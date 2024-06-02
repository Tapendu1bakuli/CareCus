import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/faq_category_model.dart';
import '../../../models/faq_model.dart';
import '../../../repositories/faq_repository.dart';
import '../../global_widgets/tab_bar_widget.dart';

class HelpController extends GetxController {
  FaqRepository _faqRepository;
  final faqCategories = <FaqCategory>[].obs;
  final faqs = <Faq>[].obs;
  TabBarController tabBarController;
  HelpController() {
    _faqRepository = new FaqRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshFaqs();
    tabBarController = Get.put(TabBarController(), tag: 'help', permanent: true);
    super.onInit();
  }

  Future refreshFaqs({bool showMessage, String categoryId}) async {
    getFaqCategories().then((value) async {
      await getFaqs(categoryId: categoryId);
      tabBarController.toggleSelected(faqCategories.elementAt(0).id);
    });
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "list_of_faqs_refreshed_successfully".tr));
    }
  }

  Future getFaqs({String categoryId}) async {
    try {
      if (categoryId == null) {
        faqs.assignAll(await _faqRepository.getFaqs(faqCategories.elementAt(0).id));
      } else {
        faqs.assignAll(await _faqRepository.getFaqs(categoryId));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFaqCategories() async {
    try {
      faqCategories.assignAll(await _faqRepository.getFaqCategories());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
