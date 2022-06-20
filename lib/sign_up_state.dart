import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:fourth_year/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oktoast/oktoast.dart';
import 'network/entity/traveller_entity.dart';

class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => sign_up_state();
}

class sign_up_state extends State<sign_up> {
  bool isLoading = false;
  var _obsecuredText = true;
  var _iconState = const Icon(Icons.visibility);
  final _enteredFullName = TextEditingController();
  final _enteredUserName = TextEditingController();
  final _enteredEmail = TextEditingController();
  final _enteredPasswored = TextEditingController();
  final _enteredPhone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign up Page"),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white10,
              padding: const EdgeInsets.all(25),
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _enteredFullName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                            (Icons.account_circle_outlined),
                            color: Colors.black,
                          ),
                          label: Text(
                            "Full Name",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _enteredUserName,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(
                              (Icons.drive_file_rename_outline_outlined),
                              color: Colors.black),
                          label: Text(
                            "Username",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _enteredEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon:
                              Icon((Icons.email_rounded), color: Colors.black),
                          label: Text(
                            "E-mail",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _enteredPasswored,
                      obscureText: _obsecuredText,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: IconButton(
                              icon: _iconState,
                              onPressed: () {
                                setState(() {
                                  _obsecuredText = !_obsecuredText;
                                  _iconState = _obsecuredText == true
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off);
                                });
                              },
                              color: Colors.black),
                          label: const Text(
                            "Password",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _enteredPhone,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: Icon(Icons.phone, color: Colors.black),
                          label: Text(
                            "Phone Number",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      child: const Text(
                        "save",
                        style: TextStyle(fontSize: 25, color: Colors.blue),
                      ),
                      onPressed: () async {
                        if (_enteredFullName.text.isEmpty ||
                            _enteredUserName.text.isEmpty ||
                            _enteredEmail.text.isEmpty ||
                            _enteredPasswored.text.isEmpty ||
                            _enteredPhone.text.isEmpty) {
                          showToast(
                            'Please Fill All Fields',
                            duration: const Duration(seconds: 3),
                            position: ToastPosition.bottom,
                          );
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          TravellerEntity traveller = TravellerEntity(
                            fullname: _enteredFullName.text,
                            userName: _enteredUserName.text,
                            email: _enteredEmail.text,
                            password: _enteredPasswored.text,
                            phone_number: int.parse(_enteredPhone.text),
                          );

                          Map<String, dynamic> Sign_up_data =
                              traveller.toJson(traveller);

//                    print("downloading data");
                          await DioHelpers.signUp(
                            signUpData: Sign_up_data,
                            url: "/auth/sign-up",
                          ).then(
                            (value) async {
                              print(value.data);
                              if (value.statusCode == 201) {
                                SharedPreferences _data =
                                    await SharedPreferences.getInstance();
                                print("created Shared Preference to save data");
                                _data.setString('f', _enteredFullName.text);
                                _data.setString('u', _enteredUserName.text);
                                _data.setString('e', _enteredEmail.text);
                                _data.setString('p', _enteredPasswored.text);
                                _data.setString('pn', _enteredPhone.text);
                                _data.setString('t', value.data['token']);
                                _data.setString('id', value.data['user_id']);
                                print("Data Saved Successfully");
                                Navigator.of(context)
                                    .pushReplacementNamed('profile');
                              }
                              else  {
                                setState(() {
                                  isLoading = false;
                                });
                                print(value.data['message']);
                                showToast(value.data['message'],
                                    duration: const Duration(seconds: 5),
                                    position: ToastPosition.bottom);
                              }
                            },
                          ).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });

                            print(error.toString());
                            showToast('error , check your internet connection');
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'have an account? ',
                          style: TextStyle(fontSize: 25),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('log_in');
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
