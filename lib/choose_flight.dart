import 'dart:convert';
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseFlight extends StatefulWidget {
  @override
  _ChooseFlightState createState() => _ChooseFlightState();
}

class _ChooseFlightState extends State<ChooseFlight> {
  SharedPreferences? _data;
  var countriesName = [];
  var loadingData = false;
  final DateTime _dt = DateTime.utc(DateTime.now().year);

//  final DateTime _dt = DateFormat.y().format(DateTime.now()) as DateTime;
  String selectedDate = DateFormat.yMMMMEEEEd().format(DateTime.now());
  TextEditingController priceController = TextEditingController();
  Map _alldata = {};
  var _selectedFromCountry, _selectedToCountry;

  Future<void> _getFromAndToCountries() async {
    showToast(
      'waiting for data .. be patient',
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
    );

    print("inside _getFromAndToCountries");
    const url = "https://api.first.org/data/v1/countries";
    try {
      setState(() {
        loadingData = true;
      });
      var _returnedCountry = await http.get(
        Uri.parse(
          url,
        ),
      );
      _alldata = jsonDecode(_returnedCountry.body);
      var _allCountries = _alldata['data'];
      _allCountries.forEach((key, value) {
//        print(value['country']);
        countriesName.add(value['country']);
      });
      showToast(
        'click "From" and "To" to select a country',
        duration: const Duration(seconds: 3),
        position: ToastPosition.bottom,
      );
    } catch (error) {
      print("$error");
    } finally {
      setState(() {
        loadingData = false;
      });
    }
  }

  @override
  void initState() {
    if (countriesName.isEmpty) {
      print("Inside INIT if");
      _getFromAndToCountries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingData == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: _selectedFromCountry,
                    hint: const Text(
                      "From",
                      style: TextStyle(fontSize: 20),
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _selectedFromCountry = newVal;
                      });
                    },
                    items: countriesName.map((element) {
                      return DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButton(
                    value: _selectedToCountry,
                    hint: const Text(
                      "To",
                      style: TextStyle(fontSize: 20),
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _selectedToCountry = newVal;
                      });
                    },
                    items: countriesName.map((element) {
                      return DropdownMenuItem(
                        value: element,
                        child: Text(element),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: _dt,
                        firstDate: _dt,
                        lastDate: DateTime.utc(DateTime.now().year + 2),
                      ).then((value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          selectedDate = DateFormat.yMd().format(value);
                        });
                      });
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(fontSize: 20),
                      hintText: selectedDate,
                      suffixIcon: const Icon(
                        Icons.date_range,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Price",
                      hintStyle: TextStyle(fontSize: 20),
                      enabled: true,
                      suffixIcon: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextButton(
                    child: const Text(
                      "Search",
                      style: TextStyle(color: Colors.blue, fontSize: 25),
                    ),
                    onPressed: () async {
                      setState(() {
                        loadingData = true;
                      });
                      print("loading data");
                      _data = await SharedPreferences.getInstance();
                      String _token = _data!.getString('t')!;
                      print(_token);
                      Map<String, dynamic> data = {
                        "from": _selectedFromCountry.toString(),
                        "to": _selectedToCountry.toString(),
                        "flightDate": selectedDate,
                        "PriceOfTheFlight": priceController
                      };
                      await DioHelpers.chooseFlight(
                        url: "/user/choose",
                        token: _token,
                        data: data,
                      ).then((value) {
                        setState(() {
                          loadingData = false;
                        });
                        print(value.data);

                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: const Text('flightFound'),
                                content: Text(
                                  'travel ID : #${value.data['flightFound'][0]['_id']} \n'
                                  'from ${value.data['flightFound'][0]['from']} \n'
                                  'to ${value.data['flightFound'][0]['to']} \n'
                                  'price : ${value.data['flightFound'][0]['price']}',
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'create ticket',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'cancel',
                                    ),
                                  ),
                                ],
                              );
                            });
                      }).catchError((error) {
                        print(error.toString());
                      });
//                print(response.data);
//                      print("data is here");
                    },
                  )
                ],
              ),
            ),
          );
  }
}
