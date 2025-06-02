import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/sqlite_service.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';

class NoteController extends GetxController {
  final SqliteService _sqliteService = Get.find<SqliteService>();
  
  RxList<Map<String, dynamic>> notes = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<NoteSortBy> currentSort = NoteSortBy.dateDesc.obs;
  final RxString selectedCategory = 'All'.obs;
  Map<String, dynamic>? lastDeletedNote;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }

  void setSortBy(NoteSortBy sortBy) {
    currentSort.value = sortBy;
    fetchNotes();
  }

  List<Map<String, dynamic>> get filteredNotes {
    return notes.where((note) {
      final matchesSearch = note['title'].toString().toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );
      
      final matchesCategory = selectedCategory.value == 'All' ||
          note['category'] == selectedCategory.value;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await _sqliteService.fetchNotes(sortBy: currentSort.value);
    notes.value = fetchedNotes;
  }

  Future<void> addNote(Map<String, dynamic> note) async {
    await _sqliteService.insertNote(note);
    fetchNotes();
  }

  Future<void> updateNote(Map<String, dynamic> note) async {
    await _sqliteService.updateNote(note);
    fetchNotes();
  }

  Future<bool> deleteNote(int id) async {
    final noteToDelete = await _sqliteService.getNote(id);
    if (noteToDelete != null) {
      lastDeletedNote = noteToDelete;
      await _sqliteService.deleteNote(id);
      fetchNotes();
      
      Get.snackbar(
        'Note Deleted',
        'The note has been deleted',
        backgroundColor: Get.isDarkMode ? Constants.darkCardFillColor : Constants.lightCardFillColor,
        colorText: Get.isDarkMode ? Constants.darkTextColor : Constants.lightTextColor,
        mainButton: TextButton(
          onPressed: () => undoDelete(),
          child: Text(
            'UNDO',
            style: TextStyle(
              color: Get.isDarkMode ? Constants.darkSecondary : Constants.lightSecondary,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      );
      return true;
    }
    return false;
  }

  Future<void> undoDelete() async {
    if (lastDeletedNote != null) {
      await _sqliteService.restoreNote(lastDeletedNote!);
      lastDeletedNote = null;
      fetchNotes();
      
      Get.snackbar(
        'Note Restored',
        'The note has been restored successfully',
        backgroundColor: Get.isDarkMode ? Constants.darkCardFillColor : Constants.lightCardFillColor,
        colorText: Get.isDarkMode ? Constants.darkTextColor : Constants.lightTextColor,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
