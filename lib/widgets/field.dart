import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final String title;
  final double width;
  final String? Function(String?) validator;
  Function(String?)? onSaved;
  String? hint;
  TextInputType? inputType;
  TextEditingController? controller;
  bool? isObscureText;
  Field({
    Key? key,
    required this.title,
    required this.width,
    required this.validator,
    this.onSaved,
    this.hint,
    this.inputType,
    this.controller,
    this.isObscureText,
  }) : super(key: key);
// 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white
                  .withOpacity(1), //Color.fromRGBO(234, 149, 241, 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                controller: controller,
                obscureText: isObscureText ?? false,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                keyboardType: inputType,
                validator: validator,
                onSaved: onSaved,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
