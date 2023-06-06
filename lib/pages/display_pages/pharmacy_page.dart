// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:io';

import 'package:admin/model/checkbox_state.dart';
import 'package:admin/widgets/AddButton.dart';
import 'package:admin/widgets/bottomNavBar.dart';
import 'package:admin/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../widgets/ItemDecoration.dart';
import '../../widgets/inputField.dart';
import '../add_pages/add_medicine_to_Pharmacy.dart';

class PharmacyPage extends StatefulWidget {
  final Map<String, dynamic> pharmacy;
  const PharmacyPage({
    Key? key,
    required this.pharmacy,
  }) : super(key: key);

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  String _radioValue = '';
  bool isLoadingUpateButton = false;
  bool isLoadingAddButton = false;
  var nameController = TextEditingController();
  var medicineNameController = TextEditingController();
  var priceController = TextEditingController();
  var bottomSheetBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20));

  File? image;
  //Uint8List? webImage;
  void _pickImage(var pickedImage) async {
    setState(() {
      image = pickedImage;
    });
  }

  var pharmaciesCollection =
      FirebaseFirestore.instance.collection('pharmacies');

  @override
  void initState() {
    super.initState();
    nameController.text = widget.pharmacy['name'];
  }

  @override
  Widget build(BuildContext context) {
    //bool deletingThisDocAndAddNewOne = false;
    var photoName;
    var url;
    setState(() {});
    return Scaffold(
        appBar: AppBar(actions: [
          AddButton(
              title: 'Add medicine',
              onTap: () async {
                List<CheckBoxState> medicines = [];
                var medicinesCollection = await FirebaseFirestore.instance
                    .collection('medicines')
                    .get();
                var medicinesDocs = medicinesCollection.docs;
                for (int i = 0; i < medicinesDocs.length; i++) {
                  var doc = medicinesDocs[i];
                  var data = doc.data();
                  List? pharmacies = data['pharmacies'];
                  if (pharmacies == null ||
                      !pharmacies
                          .contains(widget.pharmacy['name'].toString())) {
                    medicines.add(CheckBoxState(
                      title: data['name'].toString(),
                      subTitle: data['id'].toString(),
                    ));
                  }
                }
                print(medicines);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => AddMedicineToPharmacy(
                    medicines: medicines,
                    pharmacyName: widget.pharmacy['name'],
                  ),
                ));
              }),
        ]),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.blueGrey[200],
              //height: MediaQuery.of(context).size.height*0.25,
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          UserImagePicker(
                            imagePickFn: _pickImage,
                          ),
                          VerticalDivider(
                            width: 20,
                            thickness: 2,
                            color: Colors.grey[600],
                          ),
                          Column(
                            children: [
                              //Input field of name
                              InputField(
                                controller: nameController,
                                title: 'Pharmacy name',
                                width: 200,
                              ),
                              //Choose location
                              ItemDecoration(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Location: ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(_radioValue,
                                            style:
                                                const TextStyle(fontSize: 20))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //Select city
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('cities')
                                            .snapshots(),
                                        builder: (_, snapshots) {
                                          if (snapshots.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.indigo));
                                          }
                                          List cities =
                                              snapshots.data!.docs[0]['cities'];
                                          return ElevatedButton(
                                            onPressed: () => showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                      content: StatefulBuilder(
                                                          builder:
                                                              (_, function) {
                                                        return SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.3,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                              children: cities
                                                                  .map((city) =>
                                                                      RadioListTile(
                                                                        title: Text(
                                                                            city.toString()),
                                                                        value: city
                                                                            .toString(),
                                                                        groupValue:
                                                                            _radioValue,
                                                                        onChanged:
                                                                            (newName) {
                                                                          //Change the _radioValue inside function to change the selected RadioButton
                                                                          function(() =>
                                                                              _radioValue = newName!);
                                                                          //Change the _radioValue inside setState to change the city's name label  of choosen city
                                                                          setState(
                                                                              () {
                                                                            _radioValue =
                                                                                newName!;
                                                                          });
                                                                        },
                                                                      ))
                                                                  .toList(),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    )),
                                            child: const Text('Select city',
                                                style: TextStyle(fontSize: 15)),
                                          );
                                        })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey[600],
                  ),
                  //Update button
                  isLoadingUpateButton
                      ? const CircularProgressIndicator(
                          color: Colors.indigo,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            bool nameChanged = false;
                            int nameComparison = nameController.text
                                .compareTo(widget.pharmacy['name'].toString());
                            int cityComparison = _radioValue.compareTo(
                                widget.pharmacy['location'].toString());
                            Map<Object, Object> updateMap = {};
                            var pharmacyDoc = await pharmaciesCollection
                                .doc(nameController.text);
                            if (image == null &&
                                (nameController.text.isEmpty ||
                                    nameComparison == 0) &&
                                (_radioValue.isEmpty || cityComparison == 0)) {
                              //If there is no new data to update
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You can\'t update using empty or same values')));
                            } else {
                              setState(() {
                                isLoadingUpateButton = true;
                              });

                              if (image != null) {
                                photoName = nameController.text;
                                //If you wanna update the photo, so delete the old one
                                await FirebaseStorage.instance
                                    .ref()
                                    .child('user_image')
                                    .child('${widget.pharmacy['name']}.jpg')
                                    .delete();
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('user_image')
                                    .child('$photoName.jpg');

                                await ref.putFile(image!);

                                url = await ref.getDownloadURL();
                                setState(() {
                                  updateMap['imageUrl'] = url;
                                });
                              }
                              if (nameController.text.isNotEmpty &&
                                  nameComparison != 0) {
                                setState(() {
                                  nameChanged = true;
                                  updateMap['name'] = nameController.text;
                                });
                              }
                              if (_radioValue.isNotEmpty &&
                                  cityComparison != 0) {
                                setState(() {
                                  updateMap['location'] = _radioValue;
                                });
                              }
                              if (nameChanged) {
                                // setState(() {
                                //   deletingThisDocAndAddNewOne = true;
                                // });
                                await pharmacyDoc.set({
                                  'location': _radioValue.isEmpty
                                      ? widget.pharmacy['location']
                                      : _radioValue,
                                  'name': nameController.text,
                                  'medicines': widget.pharmacy['medicines'],
                                  'imageUrl':
                                      url ?? widget.pharmacy['imageUrl'],
                                });
                                await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomNavBar(
                                            nameOfpharmacyShouldBeDeleted:
                                                widget.pharmacy['name'])));
                                return;
                              } else {
                                await pharmacyDoc.update(updateMap);
                              }

                              setState(() {
                                isLoadingUpateButton = false;
                              });
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BottomNavBar()));
                            }
                          },
                          child: const Text('Update'))
                ],
              ),
            ),
            //To display the medicines of this pharmacy
            StreamBuilder(
                stream: pharmaciesCollection.snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  var pharmacy = snapshot.data!.docs.firstWhereOrNull((element) => element.data()['name'].toString().compareTo(widget.pharmacy['name'].toString())==0,);
                  return Expanded(
                    child: ListView(
                        children: [
                          ...pharmacy!.data()['medicines']
                              .map((medicine) => ItemDecoration(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              medicine['name'],
                                              softWrap: true,
                                              maxLines: 2,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child:
                                                Text('${medicine['price']} JD'),
                                          )
                                        ],
                                      ),
                                      //delete medicine
                                      ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.red)),
                                          onPressed: () async {
                                            //Delete pharmacy from medicine
                                            var doc = await FirebaseFirestore
                                                .instance
                                                .collection('medicines')
                                                .doc(medicine['name'])
                                                .get();
                                            List pharmacies =
                                                doc.data()!['pharmacies'];
                                  
                                            pharmacies
                                                .remove(pharmacy['name']);
                                            await FirebaseFirestore.instance
                                                .collection('medicines')
                                                .doc(medicine['name'])
                                                .update({
                                              'pharmacies': pharmacies
                                            }).whenComplete(() => print(
                                                    'Done deleting the name of pharmacy from list of pharmacies of the medicine'));
                                            //Delete medicine from pharmacy
                                            List list =pharmacy['medicines'];
                                            list.removeWhere((element) =>
                                                element['name'] ==
                                                medicine['name']);
                                            await pharmaciesCollection
                                                .doc(pharmacy['name'])
                                                .update({
                                              'medicines': list
                                            }).whenComplete(() => print(
                                                    'Done deleting the medicine from list of medicines of the pharmacy'));
                                          },
                                          child: const Text(
                                            'Delete',
                                          ))
                                    ],
                                  )))
                              .toList()
                        ],
                      ),
                  );
                }),
          ],
        ));
  }
}
