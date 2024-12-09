import 'package:flutter/material.dart';

// CustomTextField1 widget
class CustomTextField1 extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType type;
  final FormFieldValidator<String>? validator;
  final bool isObscure; // Changed to final for immutability
  final bool isEnabled; // Changed to final for immutability
  final Widget? prefixIcon; // Allows any widget as prefix

  const CustomTextField1({
    Key? key,
    this.controller,
    this.hintText,
    required this.type,
    this.validator,
    this.isObscure = false, // Default value
    this.isEnabled = true,  // Default value
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      padding: const EdgeInsets.only(top: 5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        obscureText: isObscure,
        keyboardType: type,
        validator: validator,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          prefixIcon: prefixIcon, // Prefix icon properly handled
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.deepPurple,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.black38,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
