
import 'package:eiin_manager/providers/drug_provider.dart';
import 'package:eiin_manager/widgets/drug_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrugsList extends StatefulWidget {
  @override
  _DrugsListState createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  var future;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    future = Provider.of<DrugsProvider>(context, listen: false)
        .getDrugsCount()
        .then((value) =>
            Provider.of<DrugsProvider>(context, listen: false).fetchDrugs());
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
          future: future,
          builder: (c, s) {
            if (s.connectionState != ConnectionState.waiting)
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Provider.of<DrugsProvider>(context, listen: false)
                                .drugCount
                                .toString() +
                            ' Drugs',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          setState(() {
                            isLoading = true;
                          });
                          drugsProvider
                              .fetchDrugs()
                              .then((value) => setState(() {
                                    isLoading = false;
                                  }));
                        }
                      },
                      child: ListView.builder(
                        itemCount: drugsProvider.drugs.length,
                        itemBuilder: (context, index) {
                          return DrugListItem(
                            drug: drugsProvider.drugs[index],
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: isLoading ? 50.0 : 0,
                    color: Colors.transparent,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
