// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:admin/model/checkbox_state.dart';

import '../display_pages/pharmacy_page.dart';

class AddMedicineToPharmacy extends StatefulWidget {
  List<CheckBoxState> medicines;
  String pharmacyName;
  AddMedicineToPharmacy({
    Key? key,
    required this.medicines,
    required this.pharmacyName,
  }) : super(key: key);

  @override
  State<AddMedicineToPharmacy> createState() => _AddMedicineToPharmacyState();
}

class _AddMedicineToPharmacyState extends State<AddMedicineToPharmacy> {

  bool isAdding = false;
  //Apply search on local list not on the list which I get from another class,so I can avoid error in listView
  List<CheckBoxState> listViewMedicines=[];
  @override
  void initState() {
    super.initState();
    listViewMedicines = widget.medicines;
  }
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              //Select all button
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ElevatedButton(
                    onPressed: () {
                      widget.medicines.forEach((element) {
                        setState(() => element.value = true);
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('select all'),
                    )),
              ),
              //Search field
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: searchController,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Theme.of(context).primaryColor)),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.grey)),
                        hintText: 'Search using name...'),
                    onChanged: (value) => setState(() {
                      if(value.isNotEmpty) {
                        listViewMedicines = widget.medicines.where((medicine) => medicine.title.toLowerCase().contains(value.toLowerCase())).toList();
                      }else{
                        listViewMedicines = widget.medicines;
                      }
                    }),
                  ),
                ),
              ),
              //Scan button
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: () async {
                      String? result;
                      try {
                        result = await FlutterBarcodeScanner.scanBarcode(
                            '#FF0000', 'Cancel', true, ScanMode.BARCODE);
                        //if (!mounted) return;
                        setState(() {
                          searchController.text = result!;
                          var medicien = widget.medicines.firstWhereOrNull((element) => element.subTitle.toString().compareTo(result!)==0);
                          listViewMedicines = medicien==null?[]:[medicien];
                        });
                      } on PlatformException {
                        result = 'Failed to get platform version.';
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text('Scan barcode'),
                    )),
              )
            ],
          ),
          Divider(
            thickness: 3,
            color: Colors.grey[600],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
               physics: const BouncingScrollPhysics(),
              itemCount: listViewMedicines.length,
              itemBuilder: (context, index) {
                Widget checkboxListTile = CheckboxListTile(
                  value: listViewMedicines[index].value,
                  title: Text(listViewMedicines[index].title),
                  subtitle: Text(listViewMedicines[index].subTitle!),
                  onChanged: (value) =>
                      setState(() => listViewMedicines[index].value = value!),
                );
                return checkboxListTile;
              },
            ),
          ),
          isAdding
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          //sharp corners
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)))),
                      onPressed: () async {
                        setState(() => isAdding = true);
                        var pharmacyDocSnapshot = FirebaseFirestore.instance
                            .collection('pharmacies')
                            .doc(widget.pharmacyName);
                        //
                        DocumentSnapshot<Map<String, dynamic>> gotPharmacyDoc =
                            await pharmacyDocSnapshot.get();
                        //
                        List medicines = gotPharmacyDoc.data()!['medicines'];
                        //
                        DocumentSnapshot<Map<String, dynamic>> pharmacyDoc =
                            await FirebaseFirestore.instance
                                .collection('pharmacies')
                                .doc(widget.pharmacyName)
                                .get();
                        for (int i = 0; i < widget.medicines.length; i++) {
                          if (widget.medicines[i].value) {
                            //Adding the name of pharmacy to list of pharmacies of the medicine
                            //1) get the doc medicine
                            DocumentReference<Map<String, dynamic>> doc =
                                FirebaseFirestore.instance
                                    .collection('medicines')
                                    .doc(widget.medicines[i].title);
                            DocumentSnapshot<Map<String, dynamic>>
                                gotMedicineDoc = await doc.get();
                            List? pharmacies;
                            //2)Make sure the data of this doc isn't null
                            if (gotMedicineDoc.data() != null) {
                              setState(()=>pharmacies = gotMedicineDoc.data()!['pharmacies']);
                              pharmacies!.add(widget.pharmacyName);
                            } else {
                              setState(()=>pharmacies = [widget.pharmacyName]);
                            }
                            doc.update({
                              'pharmacies': pharmacies
                            }).whenComplete(() => print(
                                'Done adding the name of pharmacy to list of pharmacies of the medicine'));

                            //
                            //Adding the name of medicine to list of medicines of the pharmacy
                            medicines.add({
                              'name': gotMedicineDoc['name'],
                              'price': gotMedicineDoc['price']
                            });
                          }
                        }
                        //Update list of medicines of pharmacy after adding all medicines
                        pharmacyDocSnapshot.update({
                          'medicines': medicines
                        }).whenComplete(() => print(
                            'Done adding the name of medicine to list of medicines of the pharmacy'));
                        //
                        setState(() => isAdding = false);
                        //
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => PharmacyPage(
                            pharmacy: pharmacyDoc.data()!,
                          ),
                        ));
                      },
                      child: const Text('Add')))
        ],
      ),
    );
  }
}
