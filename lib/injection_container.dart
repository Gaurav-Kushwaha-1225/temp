import 'package:get/get.dart';

import 'data/datasources/sqlite_service.dart';
import 'presentation/controllers/note_controller.dart';


void initInjection(){
  try{
    Get.put(SqliteService());

    Get.put(NoteController());

  } catch (e){
    rethrow;
  }
}