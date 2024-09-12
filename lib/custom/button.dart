import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resource/color.dart';
import '../resource/pixels.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({
    required this.onTap,
    this.borderRadius,
    this.buttonColor,
    this.border,
    this.textColor,
    required this.buttonText,
    Key? key,
  }) : super(key: key);
  VoidCallback onTap;
  Color? buttonColor;
  double? borderRadius;
  Color? textColor;
  String buttonText;
  bool? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin:EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.fromLTRB(
          Pixel.pixel_16, Pixel.pixel_10, Pixel.pixel_16, Pixel.pixel_10),
      //width: ,
      decoration: BoxDecoration(
        color: buttonColor ?? AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? Pixel.pixel_0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            //  padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor,
                    fontSize: Pixel.pixel_16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}