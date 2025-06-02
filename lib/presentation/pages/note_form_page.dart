import 'package:blogexplorer/presentation/widgets/custom_app_bar.dart';
import 'package:blogexplorer/utils/constants.dart';
import 'package:blogexplorer/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/note_controller.dart';

class NoteFormPage extends StatelessWidget {
  NoteFormPage({super.key});

  final NoteController noteController = Get.find<NoteController>();
  final _formKey = GlobalKey<FormState>();
  final RxString selectedCategory = 'Personal'.obs;

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.work, 'label': 'Work'},
    {'icon': Icons.personal_video, 'label': 'Personal'},
    {'icon': Icons.shopping_cart, 'label': 'Shopping'},
    {'icon': Icons.book, 'label': 'Study'},
    {'icon': Icons.favorite, 'label': 'Health'},
    {'icon': Icons.money, 'label': 'Finance'},
  ];

  @override
  Widget build(BuildContext context) {
    final note = Get.arguments;
    final titleController = TextEditingController(text: note?['title'] ?? '');
    final contentController = TextEditingController(text: note?['content'] ?? '');
    
    if (note != null && note['category'] != null) {
      selectedCategory.value = note['category'];
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        text: note == null ? 'Add Note' : 'Edit Note',
        leadingFunc: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note != null) ...[
                  Text(
                    'Last Updated: ${note['updatedAt'].toString().toFormattedDateTime()}',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.lightTextColor.withOpacity(0.6)
                          : Constants.darkTextColor.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    'Created: ${note['createdAt'].toString().toFormattedDateTime()}',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.lightTextColor.withOpacity(0.6)
                          : Constants.darkTextColor.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Text(
                  'Select Category',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.lightTextColor
                        : Constants.darkTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Obx(() => GestureDetector(
                            onTap: () =>
                                selectedCategory.value = categories[index]['label'],
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
                const SizedBox(height: 24),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Note Title',
                    hintStyle: GoogleFonts.urbanist(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.lightTextColor.withOpacity(0.5)
                          : Constants.darkTextColor.withOpacity(0.5),
                    ),
                    errorStyle: GoogleFonts.urbanist(
                      color: Colors.red.shade400,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightBorderColor
                            : Constants.darkBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightBorderColor
                            : Constants.darkBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightSecondary
                            : Constants.darkSecondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade400),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade400),
                    ),
                  ),
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.lightTextColor
                        : Constants.darkTextColor,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Title cannot be empty' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Note Content',
                    hintStyle: GoogleFonts.urbanist(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Constants.lightTextColor.withOpacity(0.5)
                          : Constants.darkTextColor.withOpacity(0.5),
                    ),
                    errorStyle: GoogleFonts.urbanist(
                      color: Colors.red.shade400,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightBorderColor
                            : Constants.darkBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightBorderColor
                            : Constants.darkBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Constants.lightSecondary
                            : Constants.darkSecondary,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade400),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade400),
                    ),
                  ),
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Constants.lightTextColor
                        : Constants.darkTextColor,
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Content cannot be empty' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final noteData = {
                if (note != null) 'id': note['id'],
                'title': titleController.text,
                'content': contentController.text,
                'category': selectedCategory.value,
              };

              if (note != null) {
                noteController.updateNote(noteData);
              } else {
                noteController.addNote(noteData);
              }
              Get.back();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Constants.lightSecondary
                : Constants.darkSecondary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            note == null ? 'Add Note' : 'Save Changes',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
