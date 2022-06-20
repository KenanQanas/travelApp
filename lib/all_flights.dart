import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/entity/flight_entity.dart';

class AllFlights extends StatefulWidget {
  @override
  _AllFlightsState createState() => _AllFlightsState();
}

class _AllFlightsState extends State<AllFlights> {
  bool isLoading = false;
  List allFLights = [];

  @override
  void initState() {
    loadAllFlights();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: allFLights.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Travel Id : # ${allFLights[index]['_id']}\n'
                        'From : ${allFLights[index]['from']}\n'
                        'To : ${allFLights[index]['to']}\n'
                        'Cost : ${allFLights[index]['price']}\n'
                        'Flight Date : ${allFLights[index]['flightDate']}\n',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Text(
                                  'Travel No. ${allFLights[index]['_id']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                    'Are you need to travel from ${allFLights[index]['from']} \n to '
                                    '${allFLights[index]['to']} \n with ${allFLights[index]['price']}  \n in '
                                    '${allFLights[index]['flightDate']} ?'),
                                contentPadding: const EdgeInsets.all(20),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      String url = '/user/ticket/';
                                      SharedPreferences _data =
                                          await SharedPreferences.getInstance();
                                      String? token = _data.getString('t');
                                      Map<String, dynamic> body = {
                                        "credentialNumber": 821231
                                      };
                                      Map<String, dynamic> details = {
                                        "from": allFLights[index]['from'],
                                        "to": allFLights[index]['to'],
                                        "flightID": allFLights[index]['_id']
                                      };
                                      await DioHelpers.createTicket(
                                              url: url,
                                              token: token,
                                              body: body,
                                              details: details)
                                          .then((value) {
                                        print(value.data);
                                        if (value.statusCode == 201) {
                                          showToast(value.data['msg']);
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    },
                                    child: const Text(
                                      'OK',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          'create a Ticket',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void loadAllFlights() async {
    setState(() {
      isLoading = true;
    });
    await DioHelpers.getAllFlights(url: "/user").then((value) {
      print(value.data['AllFlights']);
      allFLights = value.data['AllFlights'];
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      isLoading = false;
      print(error.toString());
    });
  }
}
