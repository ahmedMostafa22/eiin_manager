import 'package:eiin_manager/drug_provider.dart';
import 'package:eiin_manager/drugs_list.dart';
import 'package:eiin_manager/ingredient_tf.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'drug_model.dart';

class AddDrug extends StatefulWidget {
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

  bool loadingVisable = false;
  List<IngredientTextField> ingredients = [];
  //textfield controllers
  var _controllerTradeName = TextEditingController();
  var _controllerPrice = TextEditingController();
  var _controllerUnit = TextEditingController();
  var _controllerVolume = TextEditingController();
  var _controllerVolumeUnit = TextEditingController();
  var _controllerConcentration = TextEditingController();

  final _form = new GlobalKey<FormState>();

  Drug drug;
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _unitFocusNode.dispose();
    _concentrationFocusNode.dispose();
    _volumeFocusNode.dispose();
    _volumeUnitFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Drug',
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
                            textInputAction: TextInputAction.done,
                            decoration:
                                InputDecoration(labelText: 'Volume Unit'),
                            cursorColor: Theme.of(context).primaryColor,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Field content is not valid";
                              return null;
                            },
                          ),
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
                  child: Text('ADD', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    setState(() {
                      loadingVisable = true;
                    });
                    await _saveForm();
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
        if (element.text != null) ingredientTexts.add(element.text);
      });

      await Provider.of<DrugsProvider>(context, listen: false).addDrug(Drug(
          tradeName: _controllerTradeName.text,
          unit: _controllerUnit.text,
          volumeUnit: _controllerVolumeUnit.text,
          activeIngredients: ingredientTexts,
          concentration: double.parse(_controllerConcentration.text),
          price: double.parse(_controllerPrice.text),
          volume: double.parse(_controllerVolume.text)));

      Fluttertoast.showToast(
          msg: 'Drug added !',
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
}
