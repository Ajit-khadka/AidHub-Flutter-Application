// ignore_for_file: sized_box_for_whitespace, avoid_types_as_parameter_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import '../utils/app_color.dart';

Widget myText({text, style, textAlign}) {
  return Text(
    text,
    style: style,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

Widget myTextField(
    {text,
    icon,
    bool,
    TextEditingController? controller,
    Function? validator}) {
  return Container(
    height: 45,
    child: TextFormField(
      validator: (input) => validator!(input),
      obscureText: bool,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 5),
          errorStyle: const TextStyle(fontSize: 0),
          hintStyle: TextStyle(
            color: AppColors.genderTextColor,
          ),
          hintText: text,
          prefixIcon: icon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
    ),
  );
}

Widget elevatedButton({text, Function? onpress}) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(254, 109, 115, 1)),
    ),
    onPressed: () {
      onpress!();
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget iconTitleContainer(
    {text,
    path,
    Function? onPress,
    bool isReadOnly = false,
    TextInputType type = TextInputType.text,
    TextEditingController? controller,
    Function? validator,
    double width = 150,
    double height = 40}) {
  return Container(
    // padding: EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(width: 0.1, color: AppColors.genderTextColor),
    ),
    width: width,
    height: height,
    child: TextFormField(
      validator: (String? input) => validator!(input!),
      controller: controller,
      keyboardType: type,
      readOnly: isReadOnly,
      onTap: () {
        onPress!();
      },
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 0),
        contentPadding: const EdgeInsets.only(top: 3),
        prefixIcon: Container(
          child: path,
        ),
        hintText: text,
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.genderTextColor,
        ),
        border: isReadOnly
            ? OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffA6A6A6)),
                borderRadius: BorderRadius.circular(8))
            : OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
