import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddItemTextField extends StatelessWidget {
  const AddItemTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isMultiline = false,
    this.isNumber = true,
  });
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isMultiline;
  final bool isNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(5),
          TextField(
            controller: controller,
            maxLines: isMultiline ? 6 : 1,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          ),
        ],
      ),
    );
  }
}
