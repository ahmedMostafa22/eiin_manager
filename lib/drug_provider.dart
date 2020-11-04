import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eiin_manager/drug_model.dart';
import 'package:flutter/material.dart';

class DrugsProvider with ChangeNotifier {
  List<Drug> drugs = [];

  Future<void> fetchDrugs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Drugs").get();
    if (drugs.isEmpty)
      querySnapshot.docs.forEach((drugsData) {
        List<String> ingredients = [];
        drugsData['activeIngredients'].forEach((e) => ingredients.add(e));
        drugs.add(Drug(
            id: drugsData.id,
            tradeName: drugsData['tradeName'],
            unit: drugsData['unit'],
            volumeUnit: drugsData['volumeUnit'],
            activeIngredients: ingredients,
            concentration: drugsData['concentration'],
            price: drugsData['price'],
            volume: drugsData['volume']));
      });
    notifyListeners();
  }

  Future<void> addDrug(Drug drug) async {
    await FirebaseFirestore.instance.collection("Drugs").add({
      'concentration': drug.concentration,
      'tradeName': drug.tradeName,
      'unit': drug.unit,
      'volumeUnit': drug.volumeUnit,
      'price': drug.price,
      'volume': drug.volume,
      'activeIngredients': drug.activeIngredients
    }).then((value) {
      drug.id = value.id;
      drugs.add(drug);
      notifyListeners();
    });
  }
}
