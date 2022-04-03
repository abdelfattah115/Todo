import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/utils/theme.dart';

import '../../utils/size_config.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    Key? key,
    required this.hintText,
    required this.title,
    this.controller,
    this.suffixIcon,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String hintText;
  final String title;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.only(left: 12),
            height: 52,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: TextField(
              controller: controller,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              style: subTitleStyle,
              autofocus: false,
              readOnly: suffixIcon != null ? true : false,
              decoration: InputDecoration(
                suffixIcon: suffixIcon ,
                hintText: hintText,
                hintStyle: subTitleStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.backgroundColor,
                    width: 0,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.theme.backgroundColor,
                    width: 0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
