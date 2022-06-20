import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fourth_year/network/entity/traveller_entity.dart';
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class Log_In extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Log_In_State();
}

class Log_In_State extends State<Log_In> {
  late SharedPreferences _data;

  var _obsecuredText = true;
  var _iconState = const Icon(Icons.visibility);

  final TextEditingController _enteredEmail = TextEditingController();
  final TextEditingController _enteredPassword = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Log in Page"),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white10,
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _enteredEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(
                          "E-mail",
                          style: TextStyle(fontSize: 25),
                        ),
                        suffixIcon: Icon(
                          (Icons.email_rounded),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _enteredPassword,
                      obscureText: _obsecuredText,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: IconButton(
                          color: Colors.black,
                          icon: _iconState,
                          onPressed: () {
                            setState(() {
                              _obsecuredText = !_obsecuredText;
                              _iconState = _obsecuredText == true
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off);
                            });
                          },
                        ),
                        label: const Text(
                          "password",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_enteredPassword.text.isEmpty ||
                            _enteredEmail.text.isEmpty) {
                          showToast('Please Fill All Fields',
                              duration: const Duration(seconds: 3),
                              position: ToastPosition.bottom);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          Map<String, dynamic> log_in_data = {
                            "email": _enteredEmail.text,
                            "password": _enteredPassword.text
                          };
                          await DioHelpers.logIn(
                                  url: "/auth/login", logInData: log_in_data)
                              .then((value) async {
                            print(value.statusCode);
                            if (value.statusCode == 200) {
                              _data = await SharedPreferences.getInstance();

                              TravellerEntity traveller =
                                  TravellerEntity.fromJson(
                                      value.data['userInfo']);
                              String _token = value.data['token'];
                              String _id = value.data['userInfo']['_id'];

                              print(traveller.email);
                              print(traveller.userName);
                              print(traveller.email);
                              print(traveller.password);
                              print(traveller.phone_number.toString());
                              print(value.data['token']);
                              print(value.data['userInfo']['_id']);

                              _data.setString('f', traveller.fullname);
                              _data.setString('u', traveller.userName);
                              _data.setString('e', traveller.email);
                              _data.setString('p', traveller.password);
                              _data.setString(
                                  'pn', traveller.phone_number.toString());
                              _data.setString('t', value.data['token']);
                              _data.setString(
                                  'id', value.data['userInfo']['_id']);

                              Navigator.of(context)
                                  .pushReplacementNamed('profile');
                            } else if (value.statusCode == 401) {
                              showToast(
                                value.data['message'],
                                position: ToastPosition.bottom,
                                duration: const Duration(seconds: 3),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                            print('catching error');
                            print(error.toString());
                          });
                        }
                      },
                      child: const Text(
                        "log in",
                        style: TextStyle(color: Colors.blue, fontSize: 25),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No Account? ",
                          style: TextStyle(fontSize: 25),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('sign_up');
                          },
                          child: const Text(
                            'SignUp',
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
