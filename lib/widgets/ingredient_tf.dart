import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IngredientTextField extends StatefulWidget {
  String initialText;
  var controller = TextEditingController();

  IngredientTextField({Key key, this.initialText}) : super(key: key);

  @override
  _IngredientTextFieldState createState() => _IngredientTextFieldState();
}

class _IngredientTextFieldState extends State<IngredientTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(labelText: 'Ingredient'),
      cursorColor: Theme.of(context).primaryColor,
    );
  }
}
