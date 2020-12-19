import 'package:eiin_manager/models/drug_model.dart';
import 'package:eiin_manager/providers/drug_provider.dart';
import 'package:eiin_manager/widgets/drug_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Drug> searchResult = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrugsProvider>(
        create: (_) => DrugsProvider(),
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(labelText: 'Search'),
                            textInputAction: TextInputAction.search,
                            cursorColor: Theme.of(context).primaryColor,
                            onFieldSubmitted: (_) async {
                              setState(() {
                                loading = true;
                              });
                              searchResult = await Provider.of<DrugsProvider>(
                                      context,
                                      listen: false)
                                  .searchByName(_searchController.text.trim());
                              setState(() {
                                loading = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            searchResult = await Provider.of<DrugsProvider>(
                                    context,
                                    listen: false)
                                .searchByName(_searchController.text.trim());
                            setState(() {
                              loading = false;
                            });
                          },
                          color: Theme.of(context).primaryColor,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: ListView.builder(
                            itemBuilder: (context, i) =>
                                DrugListItem(drug: searchResult[i]),
                            itemCount: searchResult.length,
                          ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
