import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eiin_manager/models/drug_model.dart';
import 'package:flutter/material.dart';

class DrugsProvider with ChangeNotifier {
  List<Drug> drugs = [];
  int limit = 0, drugCount;

  Future<void> fetchDrugs() async {
    drugs.clear();
    limit += 25;
    int i = 1;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Drugs").limit(limit).get();
    querySnapshot.docs.forEach((drugsData) {
      print(i);
      i++;
      List<String> ingredients = [];
      drugsData['activeIngredients'].forEach((e) => ingredients.add(e));
      drugs.add(Drug(
        id: drugsData.id,
        tradeName: drugsData['tradeName'],
        unit: drugsData['unit'],
        volumeUnit: drugsData['volumeUnit'],
        activeIngredients: ingredients,
        concentration: double.parse(drugsData['concentration'].toString()),
        price: double.parse(drugsData['price'].toString()),
        volume: double.parse(drugsData['volume'].toString()),
        routeOfAdminstration: drugsData['routeOfAdminstration'] ?? 'none',
        interactions: drugsData['interactions'] ?? 'none',
        clinicalDescription: drugsData['clinicalDescription'] ?? 'none',
        contradictons: drugsData['contradictons'] ?? 'none',
        dose: drugsData['dose'] ?? 'none',
        dosageForm: drugsData['dosageForm'] ?? 'none',
      ));
    });
    notifyListeners();
  }

  Future<List<Drug>> searchByName(String name) async {
    List<Drug> res = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Drugs")
        .where('tradeName', isEqualTo: name)
        .get();
    querySnapshot.docs.forEach((drugsData) {
      List<String> ingredients = [];
      drugsData['activeIngredients'].forEach((e) => ingredients.add(e));
      res.add(Drug(
        id: drugsData.id,
        tradeName: drugsData['tradeName'],
        unit: drugsData['unit'],
        volumeUnit: drugsData['volumeUnit'],
        activeIngredients: ingredients,
        concentration: double.parse(drugsData['concentration'].toString()),
        price: double.parse(drugsData['price'].toString()),
        volume: double.parse(drugsData['volume'].toString()),
        routeOfAdminstration: drugsData['routeOfAdminstration'] ?? 'none',
        interactions: drugsData['interactions'] ?? 'none',
        clinicalDescription: drugsData['clinicalDescription'] ?? 'none',
        contradictons: drugsData['contradictons'] ?? 'none',
        dose: drugsData['dose'] ?? 'none',
        dosageForm: drugsData['dosageForm'] ?? 'none',
      ));
    });
    return res;
  }

  getDrugsCount() async {
    await FirebaseFirestore.instance
        .collection('DrugCounter')
        .doc('count')
        .get()
        .then((value) => drugCount = value.data()['count'])
        .then((value) => notifyListeners());
  }

  updateDrug(Drug drug) async {
    await FirebaseFirestore.instance.collection("Drugs").doc(drug.id).update({
      'concentration': drug.concentration,
      'tradeName': drug.tradeName,
      'unit': drug.unit,
      'volumeUnit': drug.volumeUnit,
      'price': drug.price,
      'volume': drug.volume,
      'activeIngredients': drug.activeIngredients,
      'dosageForm': drug.dosageForm,
      'dose': drug.dose,
      'interactions': drug.interactions,
      'contradictons': drug.contradictons,
      'routeOfAdminstration': drug.routeOfAdminstration,
      'clinicalDescription': drug.clinicalDescription
    });
  }

  Future<void> addDrug(Drug drug) async {
    drugCount++;
    await FirebaseFirestore.instance
        .collection('DrugCounter')
        .doc('count')
        .update({'count': drugCount}).then(
            (value) => FirebaseFirestore.instance.collection("Drugs").add({
                  'concentration': drug.concentration,
                  'tradeName': drug.tradeName,
                  'unit': drug.unit,
                  'volumeUnit': drug.volumeUnit,
                  'price': drug.price,
                  'volume': drug.volume,
                  'activeIngredients': drug.activeIngredients,
                  'dosageForm': drug.dosageForm,
                  'dose': drug.dose,
                  'interactions': drug.interactions,
                  'contradictons': drug.contradictons,
                  'routeOfAdminstration': drug.routeOfAdminstration,
                  'clinicalDescription': drug.clinicalDescription
                }).then((value) {
                  drug.id = value.id;
                  drugs.add(drug);
                  notifyListeners();
                }));
  }
}
