import 'package:flutter/material.dart';

class MyFormTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final String label;
  final bool obscureText; // Flag to determine if it's a password field
  final String? Function(String?) validator;

  const MyFormTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.keyboardType,
    required this.label,
    required this.keyboardAction,
    this.obscureText = false,
    required this.validator,
  });

  @override
  State<MyFormTextField> createState() => _MyFormTextFieldState();
}

class _MyFormTextFieldState extends State<MyFormTextField> {
  bool _visibility = true; // For password field

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      obscureText: widget.obscureText ? _visibility : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.keyboardAction,
      maxLines: 1,
      autocorrect: false,
      onChanged: (value) {
        widget.controller.text = value;
      },
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        fillColor: Theme.of(context).colorScheme.background,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _visibility ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () {
                  setState(() {
                    _visibility = !_visibility;
                  });
                },
              )
            : null,
      ),
    );
  }
}