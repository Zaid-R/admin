import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
   InputField(
      {Key? key,
      required this.title,
      this.inputType,
      this.hint,
      this.controller,
      this.width})
      : super(key: key);
  TextInputType? inputType;
  double? width;
  final String title;
  final String? hint;
  final TextEditingController? controller;
  
  var subTitleStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16) ;
  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder underlineBorder = const UnderlineInputBorder(
        borderSide: BorderSide(
      color: Colors.white,
      width: 0,
    ));
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
        fontWeight: FontWeight.bold,
        color:  Colors.black,
        fontSize: 16),
          ),
          Container(
              width: this.width,
              height: 52,
              padding: const EdgeInsets.only(left: 14),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey[800]!,
                  )),
              child: 
              TextFormField(
                style: subTitleStyle,
                keyboardType: inputType,
                cursorColor: Colors.grey.shade700,
                controller: controller,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subTitleStyle,
                  border: InputBorder.none
                ),
              )),
        ],
      ),
    );
  }
}
