import 'package:flutter/material.dart';

TextStyle labelTextStyles = const TextStyle(
  fontSize: 15,
  color: Color.fromRGBO(153, 153, 153, 1),
);

TextStyle hintTextStyles = const TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(153, 153, 153, 1),
);

class CustomTextfield extends StatefulWidget {
  TextEditingController textController;
  String labelText;
  String hintText;

  CustomTextfield(
      {Key? key,
      required this.textController,
      required this.labelText,
      this.hintText = ''})
      : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        fillColor: Colors.grey[200],
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purpleAccent, width: 1.0),
        ),
        labelStyle: labelTextStyles,
        hintStyle: hintTextStyles,
      ),
    );
  }
}
