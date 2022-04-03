import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';

import '../../utils/theme.dart';
import '../widgets/button.dart';
import '../widgets/text_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now());
  String endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)));
  int selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String selectedRepeat = 'none';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryClr,
            size: 24,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: const AssetImage(
              'assets/images/abdo.png',
            ),
            radius: 22,
            backgroundColor: primaryClr.withOpacity(0.7),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Add Task',
              style: headingStyle,
            ),
            MyTextFormField(
              controller: titleController,
              hintText: 'Enter title here',
              title: 'Title',
            ),
            MyTextFormField(
              controller: noteController,
              hintText: 'Enter note here',
              title: 'Note',
            ),
            MyTextFormField(
              hintText: DateFormat.yMd().format(selectedDate),
              title: 'Date',
              suffixIcon: IconButton(
                onPressed: () => _getDateFromUser(),
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextFormField(
                    hintText: startTime,
                    title: 'Start Time',
                    suffixIcon: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: true),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: MyTextFormField(
                    hintText: endTime,
                    title: 'End Time',
                    suffixIcon: IconButton(
                      onPressed: () => _getTimeFromUser(isStartTime: false),
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            MyTextFormField(
              hintText: '$selectedRemind minutes early',
              title: 'Remind',
              suffixIcon: DropdownButton(
                dropdownColor: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
                items: remindList
                    .map(
                      (value) =>
                      DropdownMenuItem(
                        value: value,
                        child: Text(
                          '$value',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                )
                    .toList(),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                underline: Container(
                  height: 0,
                ),
                style: subTitleStyle,
                onChanged: (int? value) {
                  setState(() {
                    selectedRemind = int.parse(value.toString());
                  });
                },
              ),
            ),
            MyTextFormField(
              hintText: selectedRepeat,
              title: 'Repeat',
              suffixIcon: DropdownButton(
                dropdownColor: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
                items: repeatList
                    .map((value) =>
                    DropdownMenuItem(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ))
                    .toList(),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                underline: Container(
                  height: 0,
                ),
                elevation: 4,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRepeat = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildColor(),
                  MyButton(
                      onPressed: () {
                        addTasksToDB();
                      },
                      text: 'Create Task'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  bool validateDate() {
    if (titleController.text.isEmpty ||
        noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fields are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.5),
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void addTasksToDB() async {
    if (validateDate()) {
      int value = await taskController.addTasks(task: Task(
        title: titleController.text,
        note: noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(selectedDate),
        startTime: startTime,
        endTime: endTime,
        color: _selectedColor,
        remind: selectedRemind,
        repeat: selectedRepeat,
      ),);
      Get.back();
      taskController.getTasks();
      print('return value is : $value');
    }else{
      print('Error Occurred');
    }
  }

  Widget buildColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, top: 5),
                      child: CircleAvatar(
                        backgroundColor: index == 0
                            ? primaryClr
                            : index == 1
                                ? pinkClr
                                : orangeClr,
                        radius: 15,
                        child: _selectedColor == index
                            ? const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    if (_pickedDate != null) {
      setState(() => selectedDate = _pickedDate);
    } else {
      print('It\'s null or something is wrong');
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(
                const Duration(minutes: 15),
              ),
            ),
    );
    String _formattedTime = _pickedTime!.format(context);
    if (isStartTime) {
      setState(() => startTime = _formattedTime);
    } else if (!isStartTime) {
      setState(() => endTime = _formattedTime);
    } else {
      print('Time canceled or something is wrong');
    }
  }
}
