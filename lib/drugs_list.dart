import 'package:eiin_manager/drug_item.dart';
import 'package:eiin_manager/drug_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrugsList extends StatefulWidget {
  @override
  _DrugsListState createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  var _future;
  @override
  void initState() {
    super.initState();
    _future = Provider.of<DrugsProvider>(context, listen: false).fetchDrugs();
  }

  @override
  Widget build(BuildContext context) {
    final drugsProvider = Provider.of<DrugsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Drugs List',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else
              return ListView.builder(
                itemCount: drugsProvider.drugs.length,
                itemBuilder: (context, i) => DrugListItem(
                  drug: drugsProvider.drugs[i],
                ),
              );
          }),
    );
  }
}
