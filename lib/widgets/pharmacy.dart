// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin/pages/display_pages/pharmacy_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/display_pages/medicines_page.dart';
import 'ItemDecoration.dart';

class Pharmacy extends StatelessWidget {
  final Map<String, dynamic> pharmacy;
  const Pharmacy({
    Key? key,
    required this.pharmacy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PharmacyPage(pharmacy: pharmacy),
            )),
        child: ItemDecoration(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //pharmacy image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      pharmacy['imageUrl'],
                      fit: BoxFit.scaleDown,
                    )),
              ),
              //pharmacy info
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LimitedBox(
                      maxWidth: 150,
                      child: Text(
                        pharmacy['name'] +
                            (pharmacy['name']
                                    .toString()
                                    .toLowerCase()
                                    .contains('pharmacy')
                                ? ''
                                : ' pharmacy'),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  Text(pharmacy['location']),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                      onPressed: () async {
                        //Delete the name of this pharmacy from list of pharmacies in each medicine doc in medicines collection
                        var x = await FirebaseFirestore.instance
                            .collection('medicines')
                            .get();
                        var list = x.docs;
                        for (int i = 0; i < list.length; i++) {
                          var medicinePharmacies =
                              list[i]['pharmacies'];
                          if (medicinePharmacies
                              .contains(pharmacy['name'].toString())) {
                            medicinePharmacies
                                .remove(pharmacy['name'].toString());
                            await FirebaseFirestore.instance
                                .collection('medicines')
                                .doc(list[i]['name'])
                                .update({'pharmacies': medicinePharmacies});
                          }
                        }

                        //Delete the photo of this pharmacy
                        await FirebaseStorage.instance
                            .ref()
                            .child('user_image')
                            .child('${pharmacy['name']}.jpg')
                            .delete();
                        
                        //Delete the document of this pharmacy
                        await FirebaseFirestore.instance
                            .collection('pharmacies')
                            .doc(pharmacy['name'])
                            .delete();
                      },
                      child: const Text(
                        'Delete',
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStatePropertyAll(Colors.amber[700])),
                  //     onPressed: () async {},
                  //     child: const Text(
                  //       'Edit',
                  //     ))
                ],
              )
            ],
          ),
        ));
  }
}
