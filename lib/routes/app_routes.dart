import 'package:get/get.dart';
import '../presentation/pages/home_page.dart';
import '../presentation/pages/note_form_page.dart';
import '../presentation/controllers/note_controller.dart';

class AppRoutes {
  static const home = '/';
  static const noteForm = '/noteForm';

  static List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => HomePage(),
      binding: BindingsBuilder(() {
        Get.put(NoteController());
      }),
    ),
    GetPage(
      name: noteForm,
      page: () => NoteFormPage(),
    ),
  ];
}
