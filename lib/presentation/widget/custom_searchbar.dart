import 'package:flutter/material.dart';

class CustomSearchbar extends StatelessWidget {
  const CustomSearchbar(
      {super.key,
      required this.controller,
      required this.label,
      required this.onChangedFunction});
  final TextEditingController controller;
  final String label;
  final Function onChangedFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: TextField(
          cursorColor: Colors.black54,
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            label: Text(label),
            labelStyle: const TextStyle(
              letterSpacing: 0.2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black54),
            ),
          ),
          onChanged: (text) {
            onChangedFunction(text);
          },
        ),
      ),
    );
  }
}
