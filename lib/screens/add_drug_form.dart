import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eiin_manager/models/drug_model.dart';
import 'package:eiin_manager/screens/drugs_list.dart';
import 'package:eiin_manager/screens/search_screen.dart';
import 'package:eiin_manager/widgets/ingredient_tf.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddDrug extends StatefulWidget {
  final Drug drugForEdit;

  const AddDrug({this.drugForEdit});
  @override
  _AddDrugState createState() => _AddDrugState();
}

class _AddDrugState extends State<AddDrug> {
  //focus nodes
  final _priceFocusNode = FocusNode();
  final _unitFocusNode = FocusNode();
  final _concentrationFocusNode = FocusNode();
  final _volumeFocusNode = FocusNode();
  final _volumeUnitFocusNode = FocusNode();
  var _dosageFocusNode = FocusNode();
  var _dosageFormFocusNode = FocusNode();
  var _routeOfAdminstrationFocusNode = FocusNode();
  var _clinicalDescriptionFocusNode = FocusNode();
  var _contradictionsFocusNode = FocusNode();
  var _interactionsFocusNode = FocusNode();
  bool loadingVisable = false;
  List<IngredientTextField> ingredients = [];

  //textfield controllers
  var _controllerTradeName = TextEditingController();
  var _controllerPrice = TextEditingController();
  var _controllerUnit = TextEditingController();
  var _controllerVolume = TextEditingController();
  var _controllerVolumeUnit = TextEditingController();
  var _controllerConcentration = TextEditingController();
  var _controllerDosage = TextEditingController();
  var _controllerDosageForm = TextEditingController();
  var _controllerRouteOfAdminstration = TextEditingController();
  var _controllerClinicalDescription = TextEditingController();
  var _controllerContradictions = TextEditingController();
  var _controllerInteractions = TextEditingController();
  final _form = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if (widget.drugForEdit != null) {
      _controllerTradeName.text = widget.drugForEdit.tradeName;
      _controllerPrice.text = widget.drugForEdit.price.toString();
      _controllerUnit.text = widget.drugForEdit.unit;
      _controllerVolume.text = widget.drugForEdit.volume.toString();
      _controllerVolumeUnit.text = widget.drugForEdit.volumeUnit;
      _controllerConcentration.text =
          widget.drugForEdit.concentration.toString();
      _controllerDosage.text = widget.drugForEdit.dose;
      _controllerDosageForm.text = widget.drugForEdit.dosageForm;
      _controllerRouteOfAdminstration.text =
          widget.drugForEdit.routeOfAdminstration;
      _controllerClinicalDescription.text =
          widget.drugForEdit.clinicalDescription;
      _controllerContradictions.text = widget.drugForEdit.contradictons;
      _controllerInteractions.text = widget.drugForEdit.interactions;
      widget.drugForEdit.activeIngredients
          .forEach((e) => ingredients.add(IngredientTextField(initialText: e)));
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _unitFocusNode.dispose();
    _concentrationFocusNode.dispose();
    _volumeFocusNode.dispose();
    _volumeUnitFocusNode.dispose();
    _dosageFormFocusNode.dispose();
    _dosageFocusNode.dispose();
    _clinicalDescriptionFocusNode.dispose();
    _contradictionsFocusNode.dispose();
    _interactionsFocusNode.dispose();
    _routeOfAdminstrationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.drugForEdit == null ? 'Add Drug' : 'Update Drug',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DrugsList()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                )),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: Row(
              children: [
                Container(
                  height: 500,
                  width: 400,
                  child: ListView(children: [
                    Container(
                      width: 400,
                      height: 500,
                      child: ListView(
                        children: <Widget>[
                          TextFormField(
                            controller: _controllerTradeName,
                            decoration:
                                InputDecoration(labelText: 'Trade Name'),
                            textInputAction: TextInputAction.next,
                            cursorColor: Theme.of(context).primaryColor,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_priceFocusNode);
                            },
                            validator: (val) {
                              if (val.isEmpty) return "Field can't be empty";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerPrice,
                            decoration: InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.next,
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_concentrationFocusNode);
                            },
                            validator: (val) {
                              if (val.isEmpty ||
                                  double.tryParse(val) == null ||
                                  double.parse(val) < 0.0)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerConcentration,
                            focusNode: _concentrationFocusNode,
                            textInputAction: TextInputAction.next,
                            cursorColor: Theme.of(context).primaryColor,
                            decoration:
                                InputDecoration(labelText: 'Concentration'),
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_unitFocusNode);
                            },
                            validator: (val) {
                              if (val.isEmpty ||
                                  double.tryParse(val) == null ||
                                  double.parse(val) < 0.0)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerUnit,
                            decoration: InputDecoration(labelText: 'Unit'),
                            focusNode: _unitFocusNode,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_volumeFocusNode);
                            },
                            validator: (val) {
                              if (val.isEmpty) return "Field can't be empty";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerVolume,
                            focusNode: _volumeFocusNode,
                            decoration: InputDecoration(labelText: 'Volume'),
                            keyboardType: TextInputType.number,
                            cursorColor: Theme.of(context).primaryColor,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_volumeUnitFocusNode);
                            },
                            validator: (val) {
                              if (val.isEmpty ||
                                  double.tryParse(val) == null ||
                                  double.parse(val) < 0.0)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerVolumeUnit,
                            focusNode: _volumeUnitFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_clinicalDescriptionFocusNode);
                            },
                            decoration:
                                InputDecoration(labelText: 'Volume Unit'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          ///////////////////////
                          TextFormField(
                            controller: _controllerClinicalDescription,
                            focusNode: _clinicalDescriptionFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_interactionsFocusNode);
                            },
                            decoration: InputDecoration(
                                labelText: 'Clinical Description'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerInteractions,
                            focusNode: _interactionsFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_contradictionsFocusNode);
                            },
                            decoration:
                                InputDecoration(labelText: 'Interactions'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerContradictions,
                            focusNode: _contradictionsFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_dosageFocusNode);
                            },
                            decoration:
                                InputDecoration(labelText: 'Contradictions'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerDosage,
                            focusNode: _dosageFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_dosageFormFocusNode);
                            },
                            decoration: InputDecoration(labelText: 'Dosage'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerDosageForm,
                            focusNode: _dosageFormFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_routeOfAdminstrationFocusNode);
                            },
                            decoration:
                                InputDecoration(labelText: 'Dosage Form'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _controllerRouteOfAdminstration,
                            focusNode: _routeOfAdminstrationFocusNode,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: 'Route Of Adminstration'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
                          ///////////////////////
                          SizedBox(height: 8),
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                ingredients.add(IngredientTextField());
                              });
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: ListView.builder(
                                  itemCount: ingredients.length,
                                  itemBuilder: (context, i) => ingredients[i])),
                          loadingVisable
                              ? LinearProgressIndicator(
                                  backgroundColor: Colors.cyan[100],
                                )
                              : MaterialButton(
                                  color: Theme.of(context).primaryColor,
                                  child: Text('ADD',
                                      style: TextStyle(color: Colors.white)),
                                  onPressed: () async {
                                    setState(() {
                                      loadingVisable = true;
                                    });
                                    await _saveForm();
                                    setState(() {
                                      loadingVisable = false;
                                    });
                                  },
                                ),
                        ],
                      ),
                    ),
                  ]),
                ),
                Container(
                  width: 200,
                ),
                MaterialButton(
                  height: 100,
                  minWidth: 100,
                  color: Theme.of(context).primaryColor,
                  child: Text(widget.drugForEdit == null ? 'ADD' : 'UPDATE',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      loadingVisable = true;
                    });
                    await _saveForm();
                    setState(() {
                      loadingVisable = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }

  _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      List<String> ingredientTexts = [];

      ingredients.forEach((element) {
        if (element.controller.text != null)
          ingredientTexts.add(element.controller.text);
      });
      if (widget.drugForEdit == null)
        await addDrug(Drug(
            tradeName: _controllerTradeName.text,
            unit: _controllerUnit.text,
            volumeUnit: _controllerVolumeUnit.text,
            activeIngredients: ingredientTexts,
            concentration: double.parse(_controllerConcentration.text),
            price: double.parse(_controllerPrice.text),
            volume: double.parse(_controllerVolume.text),
            dose: _controllerDosage.text,
            dosageForm: _controllerDosageForm.text,
            interactions: _controllerInteractions.text,
            contradictons: _controllerContradictions.text,
            clinicalDescription: _controllerClinicalDescription.text,
            routeOfAdminstration: _controllerClinicalDescription.text));
      else {
        await updateDrug(Drug(
            id: widget.drugForEdit.id,
            tradeName: _controllerTradeName.text,
            unit: _controllerUnit.text,
            volumeUnit: _controllerVolumeUnit.text,
            activeIngredients: ingredientTexts,
            concentration: double.parse(_controllerConcentration.text),
            price: double.parse(_controllerPrice.text),
            volume: double.parse(_controllerVolume.text),
            dose: _controllerDosage.text,
            dosageForm: _controllerDosageForm.text,
            interactions: _controllerInteractions.text,
            contradictons: _controllerContradictions.text,
            clinicalDescription: _controllerClinicalDescription.text,
            routeOfAdminstration: _controllerClinicalDescription.text));
        Navigator.of(context).pop();
      }

      Fluttertoast.showToast(
          msg: widget.drugForEdit != null ? 'Drug Edited !' : 'Drug Added !',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);

      // clearing textfields
      _controllerTradeName.clear();
      _controllerPrice.clear();
      _controllerConcentration.clear();
      _controllerUnit.clear();
      _controllerVolume.clear();
      _controllerVolumeUnit.clear();
      _controllerDosageForm.clear();
      _controllerDosage.clear();
      _controllerInteractions.clear();
      _controllerContradictions.clear();
      _controllerClinicalDescription.clear();
      _controllerRouteOfAdminstration.clear();
      setState(() {
        ingredients.clear();
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Please fill the form correctly.',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    }
    setState(() {
      loadingVisable = false;
    });
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
    int drugCount;
    await FirebaseFirestore.instance
        .collection('DrugCounter')
        .doc('count')
        .get()
        .then((value) => drugCount = value.data()['count']);
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
                }));
  }
}
