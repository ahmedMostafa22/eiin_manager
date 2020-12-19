import 'package:flutter/material.dart';

class Drug {
  String id,
      tradeName,
      unit,
      volumeUnit,
      dose = 'none',
      dosageForm = 'none',
      routeOfAdminstration = 'none',
      clinicalDescription = 'none',
      contradictons = 'none',
      interactions = 'none';
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
      @required this.volume,
      @required this.dose,
      @required this.dosageForm,
      @required this.routeOfAdminstration,
      @required this.clinicalDescription,
      @required this.contradictons,
      @required this.interactions});
}
