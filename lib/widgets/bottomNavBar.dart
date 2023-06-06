// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_jap_icons/map_icons_icons.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';

import 'package:admin/pages/display_pages/medicines_page.dart';
import 'package:admin/pages/display_pages/profile_page.dart';

import '../pages/display_pages/cities_page.dart';
import '../pages/display_pages/pharmacies_page.dart';
import '../pages/display_pages/users_page.dart';

class BottomNavBar extends StatefulWidget {
  int index;
  String? nameOfpharmacyShouldBeDeleted;
  BottomNavBar({
    Key? key,
    this.index =0,
    this.nameOfpharmacyShouldBeDeleted,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List pages =[];
  @override
  void initState() {
    super.initState();
    pages =    [PharmaciesPage(nameOfpharmacyShouldBeDeleted:widget.nameOfpharmacyShouldBeDeleted), UsersPage(), CitiesPage(),MedicinesPage(),const ProfilePage(),];
  }

  //int _selectedPageIndex = widget.index??0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[widget.index],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        child: BottomNavigationBar(
          backgroundColor: Colors.indigo,
            onTap: (index) => setState(() => widget.index = index),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black87,
            currentIndex: widget.index,
            selectedFontSize: 15,
            unselectedIconTheme: const IconThemeData(size: 25),
            selectedIconTheme: const IconThemeData(size: 30),
            type: BottomNavigationBarType.fixed,
            items:  const [
              BottomNavigationBarItem(
                icon: Icon(MedicalIcons.i_billing),
                label: 'Pharmacies',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_search_sharp),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(MapIcons.city_hall),
                label: 'Cities',
              ),
              
              BottomNavigationBarItem(
                icon: Icon(Icons.medication),
                label: 'Medicines',
              ),BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }
}
