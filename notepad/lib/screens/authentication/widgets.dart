import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget otpBox(
    TextEditingController otpController,
    FocusNode node,
    FocusNode? nextNode,
    FocusNode? previousNode,
    Color enableBorderColor,
    Color errorBorderColor,
    Color focusedBorderColor,
    double borderRadius) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (nextNode != null) {
                nextNode.requestFocus();
              }
            } else {
              if (previousNode != null) {
                previousNode.requestFocus();
              }
            }
          },
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1)
          ],
          // This fixes the keyboard type to be number only
          controller: otpController,
          focusNode: node,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(color: enableBorderColor, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(color: focusedBorderColor, width: 1)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(color: errorBorderColor, width: 1)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: BorderSide(color: errorBorderColor, width: 1)),
          )),
    ),
  );
}

Widget smallHeight() {
  return const SizedBox(height: 8);
}

Widget largeHeight() {
  return const SizedBox(height: 25);
}
