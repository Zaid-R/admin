// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:admin/model/checkbox_state.dart';
import 'package:admin/widgets/bottomNavBar.dart';

class AddCityPage extends StatefulWidget {
  final List<CheckBoxState> unselectedCities;
  const AddCityPage({
    Key? key,
    required this.unselectedCities,
  }) : super(key: key);

  @override
  State<AddCityPage> createState() => _AddCityPageState();
}

class _AddCityPageState extends State<AddCityPage> {
  var controller = TextEditingController();
  var isLoding = false;
  var citiesCollection = FirebaseFirestore.instance.collection('cities');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Add city'),
        centerTitle: true,
      ),
      body: isLoding?Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                color: Colors.indigo,
              )): ListView(
              children: [
                ...widget.unselectedCities
                    .map((e) => CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.indigo,
                          value: e.value,
                          onChanged: (newValue) => setState(() {
                            e.value = newValue!;
                          }),
                          title: Text(e.title.toString(),),
                        ))
                    .toList(),
                     Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(height: 3,color: Colors.grey[700],),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.4),
                      child: ElevatedButton(
                        onPressed: ()async{
                        setState(() {
                          isLoding = true;
                        });
                        var choosenCitiesDoc = await citiesCollection.doc('choosenCities').get();
                        var selected = choosenCitiesDoc['cities'];
                        var unselected = [];
                        for(int i =0;i<widget.unselectedCities.length;i++){
                          if(widget.unselectedCities[i].value){
                            selected.add(widget.unselectedCities[i].title);
                          }else{
                            unselected.add(widget.unselectedCities[i].title);
                          }
                        }
                        
                        await citiesCollection.doc('choosenCities').set({'cities':selected});
                        await citiesCollection.doc('unselectedCities').set({'cities':unselected});
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(_) => BottomNavBar(index: 2,),));
                      }, child: Text('Add')),
                    )
              ],
            )
          //  //}),
    );
  }
}
/*
Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blueGrey[50],
              child: ListView(
                children: [
                  ...cities
                      .map((e) => CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: e.value,
                            onChanged: (newValue) =>setState(() {
                               e.value = newValue!;
                            }),
                            title: Text(e.title),
                          ))
                      .toList(),
                      StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cities').snapshots(),
          builder: (_, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting ||
                isLoding) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.indigo,
              ));
            }
            var list = snapshots.data!.docs[0]['cities'];
            return ElevatedButton(onPressed: (){
             var newDataList = [];
             for(int i = 0;i<cities.length;i++){
              if(cities[i].value) {
                newDataList.add(cities[i].title);
              }
              FirebaseFirestore.instance.collection('cities')
              .doc('cities').set({'cities':newDataList});
             }
            }, child: const Text('Add'));
          }),
    
                ],
              ),
            ) 
      
 */