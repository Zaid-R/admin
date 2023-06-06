import 'package:flutter/material.dart';

class ItemDecoration extends StatelessWidget {
  Widget child;
  ItemDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Material(
            borderRadius: BorderRadius.circular(20),
            elevation: 5,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey[200],
                    borderRadius: BorderRadius.circular(20)),
                //margin: EdgeInsets.all(12),
                padding: const EdgeInsets.all(15),
                child: child)));
  }
}
