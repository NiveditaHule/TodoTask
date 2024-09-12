import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resource/color.dart';
import '../resource/styles.dart';


class MyTextField extends StatelessWidget {
  final type;
  final controller;
  final String hintText;
  final hintStyle;
  final bool obscureText;
  final Widget? suffixIcon;
  Function(String) onChange;
  String? Function(String?)? validator;
  MyTextField(
      {super.key,
        required this.controller,
        required this.hintText,
        required this.obscureText,
        required this.onChange,
        this.validator,
        this.type,
        this.hintStyle,
        this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: validator,
        controller: controller,
        onChanged: onChange,
        obscureText: obscureText,
        keyboardType: type ?? TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: suffixIcon ?? null,
          contentPadding:
          EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
          hintText: hintText,
          errorStyle: Styles.errorstyle,
          isDense: true,
          hintStyle: hintStyle ?? Styles.hintstyle,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ));
  }
}