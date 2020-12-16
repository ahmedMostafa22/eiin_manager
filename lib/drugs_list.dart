import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eiin_manager/drug_item.dart';
import 'package:eiin_manager/drug_model.dart';
import 'package:flutter/material.dart';

class DrugsList extends StatefulWidget {
  @override
  _DrugsListState createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Drugs List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: fetchDrugs(),
          builder: (c, s) {
            if (s.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    drugs.length.toString(),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: ListView.builder(
                      itemCount: drugs.length,
                      itemBuilder: (context, i) => DrugListItem(
                        drug: drugs[i],
                      ),
                    ),
                  ),
                ],
              );
          }),
    );
  }
}
