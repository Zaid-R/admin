// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/auth.dart';
import '../../widgets/bottomNavBar.dart';
import '../../widgets/inputField.dart';

class AddUserPage extends StatefulWidget {
  final List usersList;
  const AddUserPage({
    Key? key,
    required this.usersList,
  }) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  bool isAdmin = true;
  bool isLoading = false;
  String _radioValue = '           ';

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
                      'Admin ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16),
                    ),
                    Checkbox(
                      value: isAdmin,
                      onChanged: (value) => setState(() {
                        isAdmin = !isAdmin;
                      }),
                    ),
                  ],
                ),
              ),
              //Email textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  title: 'Email',
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
                ),
              ),
              //password textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  title: 'Password',
                  inputType: TextInputType.text,
                  controller: passwordController,
                ),
              ),
              //username textField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  title: 'Username',
                  inputType: TextInputType.name,
                  controller: usernameController,
                ),
              ),
              if (!isAdmin)
                Column(
                  children: [
                    //Phone number textTextFormField
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InputField(
                        inputType: TextInputType.phone,
                        title: 'Phone number',
                        hint: '07 #### ####',
                        controller: phoneNumberController,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Select the city
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 50,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('cities')
                                .snapshots(),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              return ElevatedButton(
                                onPressed: () async {
                                  var doc = snapshot.data!.docs[0];
                                  var data = doc.data();
                                  List cities = data['cities'];
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                      context: ctx,
                                      builder: (_) => AlertDialog(
                                            content: StatefulBuilder(
                                                builder: (_, function) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: cities
                                                    .map((cityName) =>
                                                        RadioListTile(
                                                          title: Text(cityName
                                                              .toString()),
                                                          value: cityName,
                                                          groupValue:
                                                              _radioValue,
                                                          onChanged: (newName) {
                                                            //Change the _radioValue inside function to change the selected RadioButton
                                                            function(() =>
                                                                _radioValue =
                                                                    newName!);
                                                            //Change the _radioValue inside setState to change the city's name label  of choosen city
                                                            setState(() {
                                                              _radioValue =
                                                                  newName!;
                                                            });
                                                          },
                                                        ))
                                                    .toList(),
                                              );
                                            }),
                                          ));
                                },
                                child: const Text('Select your city',
                                    style: TextStyle(fontSize: 15)),
                              );
                            }),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500],
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              _radioValue,
                              style: const TextStyle(fontSize: 20),
                            ))
                      ],
                    ),
                  ],
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
                        //These if statements to enforce filling all fields properly
                        if (passwordController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            usernameController.text.isEmpty) {
                          setState(
                            () => warningMessage =
                                'Enter email and password and username',
                          );
                        } else if (!isAdmin &&
                            phoneNumberController.text.length != 10) {
                          setState(() => warningMessage =
                              'Phone number must be 10 digits');
                        } else if (!isAdmin &&
                            int.parse(phoneNumberController.text
                                    .substring(0, 2)) !=
                                7) {
                          setState(() => warningMessage =
                              'Phone number must start with 07');
                        } else if (!isAdmin &&
                            int.parse(phoneNumberController.text[2]) < 7) {
                          setState(() => warningMessage =
                              'Third digit of phone number must be 7,8 or 9');
                        } else if (!isAdmin && _radioValue.trim().isEmpty) {
                          setState(() => warningMessage =
                              'You should choose city for non admin user');
                        } else {
                          setState(() {
                            isLoading = true;
                          });

                          //If you add admin,login using new admin to adding its email to authentication,then sign out and login using the previous account
                          if (isAdmin) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(emailController.text.toLowerCase())
                                .set({
                              'email': emailController.text.toLowerCase(),
                              'password': passwordController.text,
                              'username': usernameController.text,
                              'isAdmin': 1,
                            });
                            // var currentUser =
                            //     FirebaseAuth.instance.currentUser!;
                            // FirebaseAuth.instance.signOut();
                            // //Add new user to authentication
                            // await Provider.of<Auth>(context, listen: false)
                            //     .authenticate(emailController.text,
                            //         passwordController.text, false);
                            // currentUser = FirebaseAuth.instance.currentUser!;
                            // FirebaseAuth.instance.signOut();
                            // // ignore: use_build_context_synchronously
                            // await Provider.of<Auth>(context, listen: false)
                            //     .authenticate(
                            //         currentUser.email!,
                            //         widget.usersList.firstWhere((element) =>
                            //             element.id ==
                            //             currentUser.uid)['password'],
                            //         true);
                          } else {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(emailController.text.toLowerCase())
                                .set({
                              'email': emailController.text.toLowerCase(),
                              'password': passwordController.text,
                              'username': usernameController.text,
                              'city': _radioValue,
                              'isAdmin': 0,
                              'phoneNumber': phoneNumberController.text,
                            });
                          }

                          setState(() {
                            emailController.text = '';
                            passwordController.text = '';
                            isLoading = false;
                          });
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(
                                  index: 1,
                                ),
                              ));
                        }
                        if (warningMessage.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(warningMessage)));
                        }
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
