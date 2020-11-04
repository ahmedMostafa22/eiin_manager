import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IngredientTextField extends StatelessWidget {
  String text;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: 'Ingredient'),
      cursorColor: Theme.of(context).primaryColor,
      onChanged: (val) => text = val,
    );
  }
}
