import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/theme.dart';
import '../widgets/show_date_bar.dart';
import '../widgets/show_task_bar.dart';
import '../widgets/show_tasks.dart';
import '../../controllers/task_controller.dart';
import '../../services/notivacation_services.dart';
import '../../utils/size_config.dart';
import '../../services/theme_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final _taskController = Get.put(TaskController());

  late NotifyHelper notifyHelper;

  @override
  void initState() {
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            ThemeServices().switchTheme();
          },
          icon: Icon(
            Get.isDarkMode
                ? Icons.wb_sunny_outlined
                : Icons.nightlight_round_outlined,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Clear Tasks",
                titleStyle: titleStyle.copyWith(color: white),
                middleText: 'Are you sure you need to clear all tasks..!',
                middleTextStyle: subTitleStyle.copyWith(color: white),
                backgroundColor: primaryClr.withOpacity(0.7),
                radius: 10,
                textCancel: " No ",
                cancelTextColor: Colors.white,
                // textConfirm: " YES ",
                // confirmTextColor: Colors.white,
                confirm: InkWell(
                  onTap: () {
                    Get.back();
                    notifyHelper.cancelAllScheduleNotification();
                    _taskController.deleteAllTask();
                  },
                  borderRadius: BorderRadius.circular(25),
                  highlightColor: primaryClr,
                  child: Container(
                    height: 35,
                    width: 65,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: white),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Center(
                      child: Text(
                        ' Yes ',
                        style: TextStyle(color: white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                onCancel: () {
                  Get.back();
                },
                // onConfirm: () {
                //   Get.back();
                //   notifyHelper.cancelAllScheduleNotification();
                //   _taskController.deleteAllTask();
                // },
                buttonColor: white,
              );
            },
            icon: const Icon(
              Icons.cleaning_services_rounded,
              color: primaryClr,
            ),
          ),
          CircleAvatar(
            backgroundImage: const AssetImage(
              'assets/images/abdo.png',
            ),
            radius: 22,
            backgroundColor: primaryClr.withOpacity(0.7),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: [
          ShowTaskBar(),
          const ShowDateBar(),
          ShowTasks(),

          // _showTaskBar(),
          // _showDateBar(),
          // _showTasks(),
        ],
      ),
    );
  }

// _showTaskBar() => Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 10, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 DateFormat.yMMMMd().format(
//                   DateTime.now(),
//                 ),
//                 style: subHeadingStyle,
//               ),
//               Text(
//                 'Today',
//                 style: headingStyle,
//               ),
//             ],
//           ),
//           MyButton(
//             text: '+ Add Task',
//             onPressed: () {
//               Get.to(() => const AddTaskScreen());
//               _taskController.getTasks();
//             },
//           ),
//         ],
//       ),
//     );
//
// _showDateBar() => Container(
//       margin: const EdgeInsets.only(
//         left: 20,
//         top: 6,
//         bottom: 6,
//       ),
//       child: DatePicker(
//         DateTime.now(),
//         width: 70,
//         height: 100,
//         initialSelectedDate: DateTime.now(),
//         selectedTextColor: white,
//         selectionColor: primaryClr,
//         dayTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//         monthTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//         dateTextStyle: GoogleFonts.lato(
//           textStyle: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey,
//           ),
//         ),
//         onDateChange: (newDate) {
//           setState(() {
//             _selectedDate = newDate;
//           });
//         },
//       ),
//     );
//
// Future<void> refreshIndicator() async {
//   return _taskController.getTasks();
// }
//
// _showTasks() => Expanded(
//       child: Obx(() {
//         if (_taskController.taskList.isEmpty) {
//           return _noTaskMsg();
//         } else {
//           return RefreshIndicator(
//             onRefresh: refreshIndicator,
//             color: primaryClr,
//             child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: SizeConfig.orientation == Orientation.landscape
//                   ? Axis.horizontal
//                   : Axis.vertical,
//               itemBuilder: (context, index) {
//                 var task = _taskController.taskList[index];
//
//                 if (task.repeat == 'Daily' ||
//                     task.date == DateFormat.yMd().format(_selectedDate) ||
//                     (task.repeat == 'Weekly' &&
//                         _selectedDate
//                                     .difference(
//                                         DateFormat.yMd().parse(task.date!))
//                                     .inDays %
//                                 7 ==
//                             0) ||
//                     (task.repeat == 'Monthly' &&
//                         DateFormat.yMd().parse(task.date!).day ==
//                             _selectedDate.day)) {
//                   var date = DateFormat.jm().parse(task.startTime!);
//                   var myTime = DateFormat('HH:mm').format(date);
//
//                   notifyHelper.scheduledNotification(
//                     int.parse(myTime.toString().split(':')[0]),
//                     int.parse(myTime.toString().split(':')[1]),
//                     task,
//                   );
//                   return AnimationConfiguration.staggeredList(
//                     position: index,
//                     duration: const Duration(milliseconds: 1000),
//                     child: SlideAnimation(
//                       horizontalOffset: 300,
//                       child: FadeInAnimation(
//                         child: GestureDetector(
//                           onTap: () => _showBottomSheet(context, task),
//                           child: TaskTile(task),
//                         ),
//                       ),
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//               itemCount: _taskController.taskList.length,
//             ),
//           );
//         }
//       }),
//     );
//
// _noTaskMsg() => Stack(
//       children: [
//         AnimatedPositioned(
//           duration: const Duration(
//             milliseconds: 2000,
//           ),
//           child: RefreshIndicator(
//             onRefresh: refreshIndicator,
//             color: primaryClr,
//             child: SingleChildScrollView(
//               child: Wrap(
//                 alignment: WrapAlignment.center,
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 direction: SizeConfig.orientation == Orientation.landscape
//                     ? Axis.horizontal
//                     : Axis.vertical,
//                 children: [
//                   SizeConfig.orientation == Orientation.landscape
//                       ? const SizedBox(
//                           height: 6,
//                         )
//                       : const SizedBox(
//                           height: 200,
//                         ),
//                   SvgPicture.asset(
//                     'assets/images/task.svg',
//                     color: primaryClr.withOpacity(0.5),
//                     height: 150,
//                     semanticsLabel: 'Task',
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 10,
//                     ),
//                     child: Text(
//                       'You do not have any task yet!\n Add new task to make your days productive.',
//                       style: subTitleStyle,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizeConfig.orientation == Orientation.landscape
//                       ? const SizedBox(
//                           height: 120,
//                         )
//                       : const SizedBox(
//                           height: 180,
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//
// _showBottomSheet(BuildContext context, Task task) {
//   Get.bottomSheet(
//     SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.only(top: 4),
//         width: SizeConfig.screenWidth,
//         height: (SizeConfig.orientation == Orientation.landscape)
//             ? task.isCompleted == 1
//                 ? SizeConfig.screenHeight * 0.6
//                 : SizeConfig.screenHeight * 0.8
//             : task.isCompleted == 1
//                 ? SizeConfig.screenHeight * 0.30
//                 : SizeConfig.screenHeight * 0.39,
//         color: Get.isDarkMode ? darkHeaderClr : white,
//         child: Column(
//           children: [
//             Flexible(
//               child: Container(
//                 width: 120,
//                 height: 6,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             task.isCompleted == 1
//                 ? Container()
//                 : _buildBottomSheet(
//                     label: 'Task Completed',
//                     onTap: () {
//                       notifyHelper.cancelScheduleNotification(task);
//                       _taskController.markTaskComplete(task.id!);
//                       Get.back();
//                     },
//                     clr: primaryClr,
//                   ),
//             task.isCompleted == 1
//                 ? Container()
//                 : Divider(
//                     color: Get.isDarkMode ? Colors.grey : darkGreyClr,
//                     indent: 25,
//                     endIndent: 25,
//                   ),
//             _buildBottomSheet(
//               label: 'Delete Task',
//               onTap: () {
//                 notifyHelper.cancelScheduleNotification(task);
//                 _taskController.deleteTask(task);
//                 Get.back();
//               },
//               clr: Colors.red[300]!,
//             ),
//             Divider(
//               color: Get.isDarkMode ? Colors.grey : darkGreyClr,
//               indent: 25,
//               endIndent: 25,
//             ),
//             _buildBottomSheet(
//               label: 'Cancel',
//               onTap: () {
//                 Get.back();
//               },
//               clr: primaryClr,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// _buildBottomSheet({
//   required String label,
//   required Function() onTap,
//   required Color clr,
//   bool isClose = false,
// }) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       height: 65,
//       width: SizeConfig.screenWidth * 0.9,
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 2,
//           color: isClose
//               ? Get.isDarkMode
//                   ? Colors.grey[600]!
//                   : Colors.grey[300]!
//               : clr,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         color: isClose ? Colors.transparent : clr,
//       ),
//       child: Center(
//         child: Text(
//           label,
//           style:
//               isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
//         ),
//       ),
//     ),
//   );
// }
}
