import 'package:flutter/material.dart';

class Drug {
  String id, tradeName, unit, volumeUnit;
  List<String> activeIngredients;
  double concentration, price, volume;

  Drug(
      {@required this.tradeName,
      @required this.unit,
      this.id,
      @required this.volumeUnit,
      @required this.activeIngredients,
      @required this.concentration,
      @required this.price,
      @required this.volume});
}
