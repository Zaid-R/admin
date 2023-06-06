// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:admin/widgets/AddButton.dart';
import 'package:admin/widgets/ItemDecoration.dart';
import 'package:admin/widgets/Medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../add_pages/add_medicine_page.dart';

class MedicinesPage extends StatefulWidget {
  MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  var bottomSheetBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('medicines').snapshots(),
      builder: (ctx, snapshots) {
        //Without this if error will show up for a second
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var medicines = snapshots.data!.docs;
        //.where((element) => !element['deleted']).toList()
        return Scaffold(
          //Add user button in AppBar
          appBar: buildAppBar(),
          body: Container(
              color: Colors.blueGrey[50],
              child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (_, index) {
                    var medicine = medicines[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Medicine(medicine: medicine.data()),
                      )),
                      child: ItemDecoration(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //user info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Name: ${medicine['name']}',softWrap: true,maxLines: 2,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('ID: ${medicine['id']}'),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      'Scientific name: ${medicine['scientificName']}',softWrap:true,maxLines:2,overflow:TextOverflow.ellipsis,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                //Delete medicine
                                ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red)),
                                    onPressed: () async {
                                      //delete the user from database
                                      await FirebaseFirestore.instance
                                          .collection('medicines')
                                          .doc(medicine.id)
                                          .delete();
                                    },
                                    child: const Text(
                                      'Delete',
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(actions: [
      AddButton(
          title: 'Add medicine',
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddMedicinePage()));
          }),
    ]);
  }
}
