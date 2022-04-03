import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../utils/theme.dart';
import '../screens/add_task_screen.dart';
import 'button.dart';

class ShowTaskBar extends StatelessWidget {
  ShowTaskBar({Key? key}) : super(key: key);

  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(
                  DateTime.now(),
                ),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            text: '+ Add Task',
            onPressed: () {
              Get.to(() => const AddTaskScreen());
              taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }
}
