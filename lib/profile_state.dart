import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fourth_year/all_flights.dart';
import 'package:fourth_year/profile_settings.dart';
import 'package:fourth_year/sign_up_state.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

import 'choose_flight.dart';
import 'my_flights.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Profile_State();
}

class Profile_State extends State<Profile> {
  List<Widget> pages = [
    ChooseFlight(),
    MyFlights(),
    AllFlights(),
    ProfileSettings()
  ];

  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  int _defaultPage = 0;

  String username = '';
  String email = '';

  TextEditingController? _enteredUserName;
  TextEditingController? _enteredEmail;


  void _deleteDataFromSharedPref() async {
    SharedPreferences _data = await SharedPreferences.getInstance();
    username = _data.get('u').toString();
    email = _data.get('e').toString();
    _data.clear();
    print(' ${username + email} deleted ');
  }

  void fetchImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    setState(() {
      pickedImage = File(image.path);
    });
  }


  @override
  void dispose() {
    super.dispose();
    _deleteDataFromSharedPref();
  }

  _getMyFlights() async {
    //what is base URL
//    ApiService apiService = ApiService(dio.Dio(), baseURL: '');
//    SharedPreferences _data = await SharedPreferences.getInstance();
//    String? token = _data.getString('t');
//    Map<String, dynamic> body = {'token': token};
//    var response = await apiService.my_flight(body);
  }

  _getAllFlights() async {
//    SharedPreferences _data = await SharedPreferences.getInstance();
//    String? _token = _data.getString('t');
//    //what is base URL
//    ApiService apiService = ApiService(dio.Dio(), baseURL: '');
//    var response = await apiService.get_all_flights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Traveller"),
      ),
      body: pages[_defaultPage],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (newIndex) {
          setState(() {
            _defaultPage = newIndex;
          });
        },
        currentIndex: _defaultPage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket), label: "Choose Flight"),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplanemode_active), label: "My Flights"),
          BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket_rounded), label: "All Flights"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: "Settings"),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 50,
                icon: pickedImage == null
                    ? const Icon(Icons.account_circle_outlined)
                    : Image.file(pickedImage!),
                onPressed: () async {
                  fetchImage();
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _defaultPage = 0;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Choose Flight"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _defaultPage = 1;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("My Flights"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _defaultPage = 2;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("All Flights"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _defaultPage = 3;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Settings"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('sign_up');
                },
                child: const Text(
                  "Sign out",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
