import 'package:flutter/material.dart';

class SignTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final String? errorText;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? icon;
  final FocusNode? focusNode;

  const SignTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.controller,
    this.textInputAction,
    this.onChange,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.icon,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double space = 8;
    return Column(
      children: [
        const SizedBox(height: space),
        TextField(
          focusNode: focusNode,
          obscureText: obscureText,
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          autofillHints: null,
          keyboardType: keyboardType,
          textInputAction: textInputAction ?? TextInputAction.next,
          onChanged: (value) => onChange?.call(value),
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            icon: icon,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: const OutlineInputBorder(),
            labelText: label,
            hintText: hint,
            errorText: errorText,
          ),
        ),
        const SizedBox(height: space),
      ],
    );
  }
}
