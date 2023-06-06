import 'package:admin/widgets/AddButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/checkbox_state.dart';
import '../../widgets/ItemDecoration.dart';
import '../add_pages/add_city_page.dart';

class CitiesPage extends StatefulWidget {
  CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  bool isLoading = false;
  var citiesCollection = FirebaseFirestore.instance.collection('cities');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        AddButton(
          title: 'Add city',
          onTap: () async {
            var unselectedCitiesDoc =
                await citiesCollection.doc('unselectedCities').get();
            List unselectedCities = unselectedCitiesDoc['cities'];
            if (unselectedCities.isNotEmpty) {
              List<CheckBoxState> cities = [];
              for (int i = 0; i < unselectedCities.length; i++) {
                cities.add(CheckBoxState(title: unselectedCities[i]));
              }
              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddCityPage(
                            unselectedCities: cities,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All cities have been added')));
            }
          },
        )
      ]),
      body: Container(
        color: Colors.blueGrey[50],
        child: StreamBuilder(
          stream: citiesCollection.snapshots(),
          builder: (ctx, snapshot) {
            //Without this if error will show up for a second
            if (!snapshot.hasData || isLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.indigo,
              ));
            }
            List citiesList = snapshot.data!.docs[0]['cities'];
            return ListView(children: [
              ...citiesList
                  .map((city) => ItemDecoration(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            city,
                            style: TextStyle(fontSize: 20),
                          ),
                          ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.orangeAccent)),
                              onPressed: () async {
                                setState(() => isLoading = true);
                                var unselectedCitiesDoc = await citiesCollection
                                    .doc('unselectedCities')
                                    .get();
                                List unselectedCities =
                                    unselectedCitiesDoc['cities'];
                                unselectedCities.add(city);
                                await citiesCollection
                                    .doc('unselectedCities')
                                    .set({'cities': unselectedCities});

                                List selectedCities = citiesList;
                                selectedCities.remove(city);
                                await citiesCollection
                                    .doc('choosenCities')
                                    .set({'cities': selectedCities});

                                setState(() => isLoading = false);
                              },
                              child: const Text(
                                'Hide',
                              ))
                        ],
                      )))
                  .toList(),
            ]);
          },
        ),
      ),
    );
  }
}
