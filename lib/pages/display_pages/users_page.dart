// ignore_for_file: use_build_context_synchronously

import 'package:admin/pages/add_pages/add_user_page.dart';
import 'package:admin/widgets/AddButton.dart';
import 'package:admin/widgets/ItemDecoration.dart';
import 'package:admin/widgets/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth.dart';
import '../../widgets/inputField.dart';

class UsersPage extends StatefulWidget {
  UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  var bottomSheetBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(20), topRight: Radius.circular(20));
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (ctx, snapshots) {
        //Without this if error will show up for a second
        if (!snapshots.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var usersList = snapshots.data!.docs;
        var currentUserDoc = usersList
            .firstWhere((element) =>
                FirebaseAuth.instance.currentUser!.email == element['email'])
            .data();
        bool currentIsSpuerAdmin = currentUserDoc['isAdmin'] == 2;
        //.where((element) => !element['deleted']).toList()
        return Scaffold(
          //Add user button in AppBar
          appBar: buildAppBar(usersList),
          body: Container(
              color: Colors.blueGrey[50],
              child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (_, index) {
                    var userData = usersList[index].data();
                    var user = usersList[index];
                    return ItemDecoration(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //user info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('Username: ${userData['username']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Email: ${userData['email']}'),
                              ),
                              // ignore: unrelated_type_equality_checks
                              if (userData['isAdmin'] == 0 ||
                                  Provider.of<Auth>(context).hasSuperAdmin
                              // usersList.firstWhere((element) =>
                              //         element.id ==
                              //         FirebaseAuth.instance.currentUser!
                              //             .uid)['isAdmin'] ==2
                              )
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text('Password: ${userData['password']}'),
                                ),
                            ],
                          ),
                          Column(
                            children: [
                              if (userData['isAdmin'] != 0)
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  padding: const EdgeInsets.all(5),
                                  child: Text(userData['isAdmin'] == 1
                                      ? 'Admin'
                                      : 'Super admin'),
                                ),
                              const SizedBox(
                                height: 30,
                              ),
                              //Delete user
                              if (userData['isAdmin'] == 0 ||
                                  currentIsSpuerAdmin &&
                                      userData['isAdmin'] != 2)
                                ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red)),
                                    onPressed: () async {
                                      //delete the user from database
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.data()['email'])
                                          .delete();
                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => BottomNavBar(
                                      //         index: 1,
                                      //       ),
                                      //     ));
                                    },
                                    child: const Text(
                                      'Delete',
                                    )),
                            ],
                          )
                        ],
                      ),
                    );
                  })),
        );
      },
    );
  }

  AppBar buildAppBar(usersList) {
    return AppBar(actions: [
      AddButton(
          title: 'Add User',
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => AddUserPage(
                      usersList: usersList,
                    )));
          }),
    ]);
  }
}
