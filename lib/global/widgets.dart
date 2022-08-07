// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../global/colors.dart';

Widget WidgetTextField(
    {required BuildContext context,
    required String label,
    required IconData? icon,
    required TextEditingController? controller,
    bool isPassword = false,
    TextInputType textInputType = TextInputType.text,
    bool checkUsername = false,
    String? svgPath,
    String? helperText,
    FormFieldValidator<String>? validator,
    bool enable = true,
    int? maxLenght,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged}) {
  return IntrinsicHeight(
    child: Row(
      children: [
        icon != null
            ? Icon(
                icon,
                size: 20,
              )
            : svgPath != null
                ? Image.asset(
                    svgPath,
                    width: 24,
                    height: 24,
                  )
                : const SizedBox.shrink(),
        icon != null || svgPath != null
            ? const SizedBox(
                width: 10,
              )
            : const SizedBox.shrink(),
        Flexible(
          child: TextFormField(
            controller: controller,
            textInputAction: TextInputAction.next,
            obscureText: isPassword,
            enableSuggestions: !isPassword,
            autocorrect: !isPassword,
            keyboardType: textInputType,
            onChanged: onChanged,
            autovalidateMode: AutovalidateMode.always,
            validator: validator,
            enabled: enable,
            maxLength: maxLenght,
            inputFormatters: inputFormatters,
            onFieldSubmitted: (string) {
              FocusScope.of(context).nextFocus();
            },
            decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
                isDense: true,
                helperText: helperText,
                counterText: "",
                helperStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: buttonColor, width: 1),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.white.withAlpha(100), width: 0.5),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.black.withAlpha(50), width: 0.5),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: redColor, width: 0.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: redColor, width: 1),
                    borderRadius: BorderRadius.circular(20)),
                errorStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: redColor)),
          ),
        ),
      ],
    ),
  );
}

PhysicalModel CardModel({required Widget child}) {
  return PhysicalModel(
    color: cardColor,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(20),
    child: child,
  );
}

ShaderMask WidgetShaderMask({required Text text}) {
  return ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: mainGradient,
    ).createShader(bounds),
    child: text,
  );
}

Widget CustomTextButton(
    {required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool enable = true,
    Color? background}) {
  RxBool showBorder = false.obs;
  return Obx(() => Container(
      decoration: BoxDecoration(
          color: background ?? const Color(0xff42BE65),
          borderRadius: BorderRadius.circular(16),
          border: showBorder.value
              ? Border.all(color: Colors.amber, width: 1)
              : Border.all(color: Colors.transparent, width: 1)),
      child: TextButton(
        onPressed: enable ? onPressed : null,
        onHover: (hovered) {
          showBorder.value = hovered;
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            )),
            padding: MaterialStateProperty.all(padding)),
        child: child,
      )));
}
