import 'dart:io';
import 'dart:typed_data';

import 'package:admin/widgets/ItemDecoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../widgets/bottomNavBar.dart';
import '../../widgets/inputField.dart';
import '../../widgets/user_image_picker.dart';

class AddPharmacyPage extends StatefulWidget {
  const AddPharmacyPage({super.key});

  @override
  State<AddPharmacyPage> createState() => _AddPharmacyPageState();
}

class _AddPharmacyPageState extends State<AddPharmacyPage> {
  var nameController = TextEditingController();
  var _radioValue = 'Amman';
  bool isLoading = false;
  File? image;
  //Uint8List? webImage;
  void _pickImage(var pickedImage) async {
    setState(() {
        image = pickedImage;
    });
  }

  // void _pickWebImage(var pickedImage) async {
  //   setState(() {
  //     webImage = pickedImage;
  //   });
  // }
  var decoration = BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[200],
              );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Add pharmacy'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset:false,
      body: Container(
        color: Colors.blueGrey[50],
        child: Column(
          children: [
            const SizedBox(height: 20,),
            ItemDecoration(child: InputField(
                width: MediaQuery.of(context).size.width,
                title: 'Pharmacy name',
                controller: nameController,
                inputType: TextInputType.name,
              )),
            const SizedBox(
              height: 10,
            ),
            ItemDecoration(child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Location: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(_radioValue, style: const TextStyle(fontSize: 20))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('cities')
                          .snapshots(),
                      builder: (_, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.indigo));
                        }
                        List cities = snapshots.data!.docs[0]['cities'] ;
                        return ElevatedButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content:
                                        StatefulBuilder(builder: (_, function) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height*0.3,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: cities
                                                .map((city) => RadioListTile(
                                                      title: Text(city.toString()),
                                                      value: city.toString(),
                                                      groupValue: _radioValue,
                                                      onChanged: (newName) {
                                                        //Change the _radioValue inside function to change the selected RadioButton
                                                        function(() =>
                                                            _radioValue = newName!);
                                                        //Change the _radioValue inside setState to change the city's name label  of choosen city
                                                        setState(() {
                                                          _radioValue = newName!;
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
            const SizedBox(
              height: 10,
            ),
            ItemDecoration(child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.3),
              child: UserImagePicker(imagePickFn: _pickImage),
            )),
            Padding(
                      padding:  const EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(height: 3,color: Colors.grey[700],),
                    ),
            //Add button
            isLoading?CircularProgressIndicator(): ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  var pharmacyName = nameController.text.trim();
                  if (pharmacyName.isNotEmpty &&image!=null) {
                    var url;
                     try {
// Waits till the file is uploaded then stores the download url
                   
                      final ref = FirebaseStorage.instance
                          .ref()
                          .child('user_image')
                          .child('${nameController.text}.jpg');
                      
                      await ref.putFile(image!);

                      url = await ref.getDownloadURL();
                    } catch (e) {
                      print('Error is :'+e.toString());
                    }

                    await FirebaseFirestore.instance
                        .collection('pharmacies')
                        .doc(pharmacyName)
                        .set({
                      'name': pharmacyName,
                      'location': _radioValue,
                      'imageUrl': url,
                      'medicines': [],
                    });
                    await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BottomNavBar(),
                        ));
                  } else if (image!=null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Image Selected")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('City name can\'t be empty')));
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 18),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
