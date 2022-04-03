import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/view/screens/home_screen.dart';

import '../../utils/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, required this.payload}) : super(key: key);

  final String payload;

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  String _payLoad = '';

  @override
  void initState() {
    super.initState();
    _payLoad = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.off(() => const HomeScreen());
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryClr,
          ),
        ),
        title: Text(
          _payLoad.split('|')[0],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Get.isDarkMode ? white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Text(
                  'Hello, Abdel fattah ',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Get.isDarkMode ? Colors.white : darkGreyClr,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'You have a new reminder',
                  style: TextStyle(
                    fontSize: 18,
                    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: bluishClr,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.text_format,
                            size: 35,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Title',
                            style: headingStyle.copyWith(
                              color: white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payLoad.split('|')[0],
                        style: titleStyle.copyWith(
                          color: white,
                        ),
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Description',
                            style: subHeadingStyle.copyWith(
                              color: white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payLoad.split('|')[1],
                        style: titleStyle.copyWith(
                            color: white, fontWeight: FontWeight.w100),
                        textAlign: TextAlign.justify,
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                        height: 30,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 28,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Date',
                            style: subHeadingStyle.copyWith(
                              color: white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _payLoad.split('|')[2],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
