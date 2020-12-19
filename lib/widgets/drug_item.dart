import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eiin_manager/models/drug_model.dart';
import 'package:eiin_manager/screens/add_drug_form.dart';
import 'package:flutter/material.dart';

class DrugListItem extends StatefulWidget {
  final Drug drug;

  DrugListItem({this.drug});

  @override
  _DrugListItemState createState() => _DrugListItemState();
}

class _DrugListItemState extends State<DrugListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        width: 4,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TrackRow("Trade Name:", widget.drug.tradeName),
                            TrackRow("Price:", widget.drug.price.toString()),
                            TrackRow("Concentration:",
                                widget.drug.concentration.toString()),
                            TrackRow("Volume:", widget.drug.volume.toString()),
                            TrackRow("Volume Unit:", widget.drug.volumeUnit),
                          ],
                        ),
                      ),
                      Column(children: [
                        RaisedButton(
                          child: Icon(
                            Icons.format_shapes,
                            color: Colors.white,
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () async {
                            await showModalBottomSheet<void>(
                                context: context,
                                builder: (context) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListView.builder(
                                          itemCount: widget
                                              .drug.activeIngredients.length,
                                          itemBuilder: (context, i) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                i.toString() + ' - ',
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              Text(
                                                widget
                                                    .drug.activeIngredients[i],
                                                style: TextStyle(fontSize: 22),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                        ),
                        RaisedButton(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            color: Colors.green,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) =>
                                      AddDrug(drugForEdit: widget.drug)));
                            }),
                        RaisedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (c) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 16,
                                            ),
                                            RaisedButton(
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                color: Colors.red,
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("Drugs")
                                                      .doc(widget.drug.id)
                                                      .delete();
                                                  int drugCount;
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('DrugCounter')
                                                      .doc('count')
                                                      .get()
                                                      .then((value) =>
                                                          drugCount = value
                                                              .data()['count']);
                                                  drugCount--;
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('DrugCounter')
                                                      .doc('count')
                                                      .update(
                                                          {'count': drugCount});
                                                  Navigator.of(c).pop();
                                                }),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            RaisedButton(
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                color: Colors.white,
                                                onPressed: () async {
                                                  Navigator.of(c).pop();
                                                })
                                          ],
                                        ),
                                      ));
                            },
                            color: Colors.red,
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ))
                      ]),
                      SizedBox(width: 4)
                    ],
                  ),
                ])));
  }
}

class TrackRow extends StatelessWidget {
  final String label;
  final String name;

  TrackRow(this.label, this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(color: Colors.cyan),
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
