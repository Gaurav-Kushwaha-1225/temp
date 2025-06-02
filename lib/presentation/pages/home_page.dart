import 'package:blogexplorer/presentation/controllers/note_controller.dart';
import 'package:blogexplorer/presentation/widgets/custom_app_bar.dart';
import 'package:blogexplorer/utils/constants.dart';
import 'package:blogexplorer/utils/enums.dart';
import 'package:blogexplorer/utils/extensions.dart';
import 'package:blogexplorer/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NoteController noteController = Get.find<NoteController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final RxString selectedCategory = 'All'.obs;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.notes, 'label': 'All'},
    {'icon': Icons.work, 'label': 'Work'},
    {'icon': Icons.personal_video, 'label': 'Personal'},
    {'icon': Icons.shopping_cart, 'label': 'Shopping'},
    {'icon': Icons.book, 'label': 'Study'},
    {'icon': Icons.favorite, 'label': 'Health'},
    {'icon': Icons.money, 'label': 'Finance'},
  ];

  final List<Map<String, dynamic>> sortOptions = [
    {'icon': Icons.access_time, 'label': 'Latest First', 'sort': NoteSortBy.dateDesc},
    {'icon': Icons.access_time_filled, 'label': 'Oldest First', 'sort': NoteSortBy.dateAsc},
    {'icon': Icons.sort_by_alpha, 'label': 'Title (A-Z)', 'sort': NoteSortBy.titleAsc},
    {'icon': Icons.sort_by_alpha_rounded, 'label': 'Title (Z-A)', 'sort': NoteSortBy.titleDesc},
  ];

  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Constants.lightCardFillColor
          : Constants.darkCardFillColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort Notes',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightTextColor
                    : Constants.darkTextColor,
              ),
            ),
            const SizedBox(height: 20),
            ...sortOptions.map((option) => Obx(() => Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: noteController.currentSort.value == (option['sort'] as NoteSortBy)
                    ? (Theme.of(context).brightness == Brightness.light
                        ? Constants.lightSecondary.withOpacity(0.1)
                        : Constants.darkSecondary.withOpacity(0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  option['icon'] as IconData,
                  color: noteController.currentSort.value == (option['sort'] as NoteSortBy)
                      ? (Theme.of(context).brightness == Brightness.light
                          ? Constants.lightSecondary
                          : Constants.darkSecondary)
                      : Theme.of(context).brightness == Brightness.light
                          ? Constants.lightTextColor.withOpacity(0.7)
                          : Constants.darkTextColor.withOpacity(0.7),
                ),
                title: Text(
                  option['label'] as String,
                  style: GoogleFonts.urbanist(
                    color: noteController.currentSort.value == (option['sort'] as NoteSortBy)
                        ? (Theme.of(context).brightness == Brightness.light
                            ? Constants.lightSecondary
                            : Constants.darkSecondary)
                        : Theme.of(context).brightness == Brightness.light
                            ? Constants.lightTextColor
                            : Constants.darkTextColor,
                    fontWeight: noteController.currentSort.value == (option['sort'] as NoteSortBy)
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: noteController.currentSort.value == (option['sort'] as NoteSortBy)
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightSecondary
                            : Constants.darkSecondary,
                      )
                    : null,
                onTap: () {
                  noteController.setSortBy(option['sort'] as NoteSortBy);
                  Navigator.pop(context);
                },
              ),
            ))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        text: "Note Explorer",
        leadingFunc: () => _showSortMenu(context),
        leadingIcon: Icons.sort,
        actions: [
          Obx(() => Container(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(
                    themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.lightSecondary
                        : Constants.darkSecondary,
                  ),
                  onPressed: () {
                    themeController.toggleTheme();
                    Get.changeThemeMode(
                      themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Constants.lightCardFillColor
                  : Constants.darkCardFillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightBorderColor
                    : Constants.darkBorderColor,
              ),
            ),
            child: TextField(
              autofocus: false,
              focusNode: FocusNode(),
              onChanged: (value) => noteController.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: GoogleFonts.urbanist(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.lightTextColor.withOpacity(0.5)
                      : Constants.darkTextColor.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Constants.lightSecondary
                      : Constants.darkSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),

          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Obx(() => GestureDetector(
                      onTap: () {
                        selectedCategory.value = categories[index]['label'];
                        noteController
                            .setSelectedCategory(categories[index]['label']);
                      },
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: selectedCategory.value ==
                                  categories[index]['label']
                              ? (Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.lightSecondary
                                  : Constants.darkSecondary)
                              : (Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.lightSecondary.withOpacity(0.1)
                                  : Constants.darkSecondary.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              categories[index]['icon'],
                              color: selectedCategory.value ==
                                      categories[index]['label']
                                  ? Colors.white
                                  : (Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Constants.lightSecondary
                                      : Constants.darkSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categories[index]['label'],
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selectedCategory.value ==
                                        categories[index]['label']
                                    ? Colors.white
                                    : (Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Constants.lightSecondary
                                        : Constants.darkSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          ),

          Expanded(
            child: Obx(() {
              final filteredNotes = noteController.filteredNotes;
              if (filteredNotes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 64,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightSecondary
                            : Constants.darkSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        noteController.notes.isEmpty
                            ? 'No notes available'
                            : 'No matching notes found',
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Constants.lightTextColor
                                  : Constants.darkTextColor,
                        ),
                      ),
                      if (noteController.searchQuery.isNotEmpty ||
                          noteController.selectedCategory.value != 'All')
                        TextButton(
                          onPressed: () {
                            noteController.setSearchQuery('');
                            noteController.setSelectedCategory('All');
                            selectedCategory.value = 'All';
                          },
                          child: Text(
                            'Clear filters',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Constants.lightSecondary
                                  : Constants.darkSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Dismissible(
                    key: Key(note['id'].toString()),
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) => _showDeleteDialog(context, note),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightCardFillColor
                            : Constants.darkCardFillColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Constants.lightBorderColor
                              : Constants.darkBorderColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            title: Text(
                              note['title'],
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Constants.lightTextColor
                                    : Constants.darkTextColor,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    note['content'],
                                    style: GoogleFonts.urbanist(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Constants.lightTextColor
                                              .withOpacity(0.7)
                                          : Constants.darkTextColor
                                              .withOpacity(0.7),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: (Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Constants.lightSecondary
                                                : Constants.darkSecondary)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        note['category'] ?? 'Uncategorized',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Constants.lightSecondary
                                              : Constants.darkSecondary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      note['updatedAt'].toString().toRelativeTime(),
                                      style: GoogleFonts.urbanist(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Constants.lightTextColor.withOpacity(0.5)
                                            : Constants.darkTextColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () =>
                                Get.toNamed('/noteForm', arguments: note),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/noteForm'),
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Constants.lightSecondary
            : Constants.darkSecondary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<bool> _showDeleteDialog(BuildContext context, Map<String, dynamic> note) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Constants.lightCardFillColor
            : Constants.darkCardFillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Note',
          style: GoogleFonts.urbanist(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.lightTextColor
                : Constants.darkTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this note?',
          style: GoogleFonts.urbanist(
            color: Theme.of(context).brightness == Brightness.light
                ? Constants.lightTextColor.withOpacity(0.7)
                : Constants.darkTextColor.withOpacity(0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.lightSecondary
                    : Constants.darkSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.urbanist(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      return await noteController.deleteNote(note['id']);
    }
    return false;
  }
}
