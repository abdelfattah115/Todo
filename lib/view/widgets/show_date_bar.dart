import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/task_controller.dart';
import '../../utils/theme.dart';

class ShowDateBar extends StatefulWidget {
  const ShowDateBar({Key? key}) : super(key: key);

  static DateTime selectedDate = DateTime.now();
  @override
  State<ShowDateBar> createState() => _ShowDateBarState();
}

class _ShowDateBarState extends State<ShowDateBar> {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        top: 6,
        bottom: 6,
      ),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: ShowDateBar.selectedDate,
        selectedTextColor: white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        onDateChange: (newDate) {
          setState(() {
            ShowDateBar.selectedDate = newDate;
            taskController.getTasks();

          });
        },
      ),
    );
  }
}
