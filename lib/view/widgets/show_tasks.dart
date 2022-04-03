import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'show_date_bar.dart';
import '../../services/notivacation_services.dart';
import '../../models/task.dart';
import 'task_tile.dart';
import '../../controllers/task_controller.dart';
import '../../utils/size_config.dart';
import '../../utils/theme.dart';

class ShowTasks extends StatelessWidget {
  ShowTasks({Key? key}) : super(key: key);

  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (taskController.taskList.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: refreshIndicator,
            color: primaryClr,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (context, index) {
                var task = taskController.taskList[index];

                if (task.repeat == 'Daily' ||
                    task.date == DateFormat.yMd().format(ShowDateBar.selectedDate) ||
                    (task.repeat == 'Weekly' &&
                        ShowDateBar.selectedDate
                            .difference(
                            DateFormat.yMd().parse(task.date!))
                            .inDays %
                            7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(task.date!).day ==
                            ShowDateBar.selectedDate.day)) {
                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);

                  NotifyHelper().scheduledNotification(
                    int.parse(myTime.toString().split(':')[0]),
                    int.parse(myTime.toString().split(':')[1]),
                    task,
                  );
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => _showBottomSheet(context, task),
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: taskController.taskList.length,
            ),
          );
        } else {
          return AnimatedContainer(
            duration: const Duration(seconds: 2),
            child: RefreshIndicator(
              onRefresh: refreshIndicator,
              color: primaryClr,
              child: SingleChildScrollView(
                child: Wrap(
                  //this is dynamic it sometimes row and sometimes column according to you landscape
                  //alignment: WrapAlignment.center,          //this like mainAxis
                  crossAxisAlignment: WrapCrossAlignment.center,
                  //this is CrossAxis
                  direction: SizeConfig.orientation == Orientation.landscape
                      ? Axis.horizontal
                      : Axis.vertical,
                  children: [
                    SizeConfig.orientation == Orientation.landscape
                        ? const SizedBox(
                            height: 5,
                          )
                        : const SizedBox(
                            height: 120,
                          ),
                    SvgPicture.asset(
                      'assets/images/task.svg',
                      color: primaryClr.withOpacity(0.7),
                      height: 150,
                      semanticsLabel: 'Task',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "You don't have any tasks yet!\nAdd new tasks",
                      textAlign: TextAlign.center,
                      style: subTitleStyle,
                    ),
                    SizeConfig.orientation == Orientation.landscape
                        ? const SizedBox(
                            height: 10,
                          )
                        : const SizedBox(
                            height: 10,
                          ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  Future<void> refreshIndicator() async {
    return taskController.getTasks();
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8
              : task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39,
          color: Get.isDarkMode ? darkHeaderClr : white,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        NotifyHelper().cancelScheduleNotification(task);
                        taskController.markTaskComplete(task.id!);
                        Get.back();
                      },
                      clr: primaryClr,
                    ),
              task.isCompleted == 1
                  ? Container()
                  : Divider(
                      color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                      indent: 25,
                      endIndent: 25,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  NotifyHelper().cancelScheduleNotification(task);
                  taskController.deleteTask(task);
                  Get.back();
                },
                clr: Colors.red[300]!,
              ),
              Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                indent: 25,
                endIndent: 25,
              ),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
