// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:admin/widgets/AddButton.dart';
import 'package:admin/widgets/pharmacy.dart';

import '../add_pages/add_pharmacy_page.dart';

class PharmaciesPage extends StatefulWidget {
  String? nameOfpharmacyShouldBeDeleted;
  PharmaciesPage({
    Key? key,
    this.nameOfpharmacyShouldBeDeleted,
  }) : super(key: key);
  
  @override
  State<PharmaciesPage> createState() => _PharmaciesPageState();
}

class _PharmaciesPageState extends State<PharmaciesPage> {
  void delete(String pharmacyName)async{
      await FirebaseFirestore.instance.collection('pharmacies').doc(pharmacyName).delete();
  }
  @override
  void initState() {
    super.initState();
    if(widget.nameOfpharmacyShouldBeDeleted!=null){
      delete(widget.nameOfpharmacyShouldBeDeleted!);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        AddButton(
            title: 'Add pharmacy',
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddPharmacyPage()));
            }),
      ]),
      body: Container(
        color: Colors.blueGrey[50],
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('pharmacies').snapshots(),
          builder: (ctx, snapshot) {
            //Without this if error will show up for a second
            if (snapshot.connectionState == ConnectionState.waiting||snapshot.data==null) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.indigo,
              ));
            }
            final pharmaciesList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: pharmaciesList.length,
                itemBuilder: (_, index) {
                  var pharmacy = pharmaciesList[index];
                  //pharmacy
                  return Pharmacy(pharmacy: pharmacy.data());
                });
          },
        ),
      ),
    );
  }
}
