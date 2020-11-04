import 'package:flutter/material.dart';
import 'drug_model.dart';

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
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        width: 4,
                      ),
                      Column(
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
                      Spacer(),
                      RaisedButton(
                        child: Text(
                          'Show Ingredients',
                          style: TextStyle(color: Colors.white),
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
                                              widget.drug.activeIngredients[i],
                                              style: TextStyle(fontSize: 22),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                        },
                      ),
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
