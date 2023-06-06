// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:admin/widgets/inputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var idController = TextEditingController();
  var doseController = TextEditingController();
  var scientificNameController = TextEditingController();
  bool isLiquid = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StatefulBuilder(builder: (context, setState) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.blueGrey[100],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Admin checkbox
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Liquid ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Checkbox(
                      value: isLiquid,
                      onChanged: (value) => setState(() {
                        isLiquid = !isLiquid;
                      }),
                    ),
                  ],
                ),
              ),
              //name textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  title: 'Name',
                  inputType: TextInputType.text,
                  controller: nameController,
                ),
              ),
              //Scientific name textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  title: 'Scientific name',
                  inputType: TextInputType.text,
                  controller: scientificNameController,
                ),
              ),
              //ID textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputField(
                      width: MediaQuery.of(context).size.width*0.6,
                      title: 'ID',
                      inputType: TextInputType.number,
                      controller: idController,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                                onPressed: () async {
                                  String? result;
                                  try {
                                    result =
                                        await FlutterBarcodeScanner.scanBarcode(
                                            '#FF0000',
                                            'Cancel',
                                            true,
                                            ScanMode.BARCODE);
                                    //if (!mounted) return;
                                    setState(() {
                                      idController.text = result!;
                                    });
                                  } on PlatformException {
                                    result = 'Failed to get platform version.';
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('Scan barcode'),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //price textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  inputType: TextInputType.number,
                  title: 'Price',
                  controller: priceController,
                ),
              ),
              //dose textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  inputType: TextInputType.text,
                  title: 'Dose usage',
                  controller: doseController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //divider
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Divider(
                  height: 3,
                  color: Colors.black,
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        String warningMessage = '';
                        if (nameController.text.isEmpty ||
                            idController.text.isEmpty ||
                            priceController.text.isEmpty ||
                            doseController.text.isEmpty ||
                            scientificNameController.text.isEmpty) {
                          setState(
                            () => warningMessage = 'Fill all fields',
                          );
                        } else {
                          FirebaseFirestore.instance
                              .collection('medicines')
                              .doc(nameController.text.trim())
                              .set({
                            'isLiquid': isLiquid,
                            'name': nameController.text.trim(),
                            'scientificName': scientificNameController.text.trim(),
                            'id': idController.text,
                            'price':double.parse(priceController.text.trim()),
                            'dose': doseController.text.trim(),
                            'pharmacies': [],
                          });
                          setState(() =>
                              warningMessage = 'Medicine added successfuly');
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: warningMessage.contains('added')
                                ? Colors.green[300]
                                : Colors.grey,
                            content: Text(
                              warningMessage,
                            )));
                      },
                      child: const Text('Add')),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      }),
    );
  }
}
