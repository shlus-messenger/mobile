import 'package:flutter/material.dart';

enum InputType {
  text,
  password,
  email    
}

class Input extends StatefulWidget {

  final String? placeholder;
  final String? subscription;
  final Icon? prefixIcon;
  final InputType? type;
  final TextEditingController? controller;

  Input({
    this.placeholder,
    this.prefixIcon,
    this.subscription,
    this.type = InputType.text,
    this.controller,
  });

  @override
  State<Input> createState() => _InputState();

  
}

class _InputState extends State<Input> {

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.subscription != null)
            Text(
              widget.subscription!
            ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade400
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue
                )
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.type == InputType.password
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: _isPasswordVisible ? Icon(Icons.visibility_off_outlined) : Icon(Icons.visibility_outlined),
                )
                : null
              ,
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500
              ),
            ),
            controller: widget.controller,
            obscureText: widget.type == InputType.password && !_isPasswordVisible,
          ),
        ],
      )
    ); 
  }

}