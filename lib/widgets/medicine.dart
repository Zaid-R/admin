// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

class Medicine extends StatelessWidget {
  Map<String, dynamic> medicine;
  Medicine({
    Key? key,
    required this.medicine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey[100],
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildField('Name: ${medicine['name']}'),
                buildField('ID: ${medicine['id']}'),
                buildField('Scientific name: ${medicine['scientificName']}'),
                buildField('Price: ${medicine['price']}'),
                buildField('Dose usage: ${medicine['dose']}'),
                buildField('${medicine['isLiquid']?'Liquid':'Solid'} medicine')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
      ),
    );
  }
}
