import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class InputComponent extends StatefulWidget {

  final placeholder;

  const InputComponent({
    super.key,
    required this.placeholder
  });

  @override
  State<InputComponent> createState() => _InputComponentState();

}

class _InputComponentState extends State<InputComponent> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: widget.placeholder,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade900,
            width: 0.1.w
          ),
          borderRadius: BorderRadius.circular(10.r)
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(10.r)
        ),
      ),
      autofocus: false,
    );
  }
}