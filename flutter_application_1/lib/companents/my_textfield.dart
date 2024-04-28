import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final TextInputType? inputType;
  final int? maxLines;
  final TextAlign? textAlign;
  final Widget? suffixIcon;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.inputType,
    this.maxLines,
    this.textAlign,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: inputType,
        maxLines: obscureText ? 1 : maxLines,
        style: TextStyle(
          fontSize: 14.0,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          labelText: hintText,

          prefixIcon: icon,
          suffixIcon: suffixIcon, 
        ),
        textAlign: textAlign ?? TextAlign.start,
      ),
    );
  }
}
