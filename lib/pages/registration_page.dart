import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../model/auth.dart';
import '../widgets/field.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

//Sit dolor veniam veniam exercitation do ipsum ex aute eiusmod. Deserunt aute ullamco laboris fugiat esse. Amet sunt officia cillum proident ut aliquip anim laboris laboris. Excepteur ullamco consectetur culpa fugiat mollit magna eiusmod. Laboris non cillum est ad minim commodo ex nulla nulla cupidatat pariatur occaecat tempor ullamco. Quis proident irure tempor elit. Minim Lorem nisi ullamco ad cupidatat ex deserunt proident laboris pariatur anim ipsum nulla incididunt.

class _RegistrationPageState extends State<RegistrationPage> {
  Color myPurple = const Color.fromRGBO(93, 63, 211, 1);
  final Map<String, String?> _authData = {
    "email": "",
    "password": "",
  };

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextStyle linkTextStyle = TextStyle(
        color: myPurple,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        wordSpacing: 2);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: myPurple,
          title: const Text('Pharmacy In Pocket (Admin)'),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey.shade300,
                  myPurple,
                ]),
          ),
          alignment: Alignment.center,
          //Container to stand out the from of registration
          child:
              //Use material to add elevation for form container
              Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Material(
              elevation: 10,
              //To avoid bad corners give the same borderRadius for material and container
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20)),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Field(
                            title: 'Email',
                            isObscureText: false,
                            inputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null &&
                                  (value.isEmpty || !value.contains('@'))) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                            onSaved: (newValue) => setState(
                                () => _authData['email'] = newValue!.trim()),
                            width: screenWidth * 0.6),
                        Field(
                            title: 'Password',
                            isObscureText: true,
                            inputType: TextInputType.text,
                            controller: _passwordController,
                            validator: (value) {
                              if (value != null) {
                                if (value.isEmpty || value.length <= 5) {
                                  return 'Password should be at least 6 digits';
                                }
                                //Complete this after dealing with database
                                /* else if (authMode == authMode.signUp&&value!= passwordInDB) {
                            return 'Wrong password';
                          } */
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              setState(() {
                                _authData['password'] = newValue;
                              });
                            },
                            width: screenWidth * 0.6),

                        //Display forgot password only in login page
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Forgot password?',
                            style: linkTextStyle,
                          ),
                        ),
                        const Divider(
                            thickness: 2, color: Colors.grey, height: 50),
                        !Provider.of<Auth>(context).isLoading
                            ? ElevatedButton(
                                onPressed: _submit,
                                style: const ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromRGBO(93, 63, 211, 1))),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Log in',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            : CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An error occurred'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay'),
                )
              ],
            ));
  }

  void _submit() async {
    //make sure the data is valid
    if (!_formKey.currentState!.validate()) return;
    //save the data after passing the condition successfully
    _formKey.currentState!.save();
    //

    try {
      var authProvider = Provider.of<Auth>(context, listen: false);
      authProvider.setIsLoading(true);
      var gottenUserDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_authData['email'].toString())
          .get();
      // .doc(_authData['email']!).get();
      bool userExistsAsDoc = gottenUserDoc.exists;
      bool userExistsAsAuth = (await FirebaseAuth.instance
              .fetchSignInMethodsForEmail(_authData['email']!))
          .isNotEmpty;
      if (!userExistsAsDoc && userExistsAsAuth) {
        throw 'Your account has been deleted.';
      } else if (userExistsAsDoc && !userExistsAsAuth) {
        int userRank = gottenUserDoc.data()!['isAdmin'];
        if (userRank == 0) {
          throw 'You are not admin';
        }
        //Sign up when this user is admin, but added by another admin
        else if (userRank == 1 &&
            (await FirebaseAuth.instance
                    .fetchSignInMethodsForEmail(_authData['email']!))
                .isEmpty) {
          authProvider.authenticate(
              _authData['email']!, _authData['password']!, false, true);
        }
      } else {
        await authProvider.authenticate(
            _authData['email']!, _authData['password']!, true, false);
      }
    } catch (e) {
      Provider.of<Auth>(context, listen: false)
                        .setIsLoading(false);
      _showErrorDialog(e.toString());
    }
  }
}
