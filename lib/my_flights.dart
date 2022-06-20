import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/response/dio_helpers.dart';

class MyFlights extends StatefulWidget {
  @override
  _MyFlightsState createState() => _MyFlightsState();
}

class _MyFlightsState extends State<MyFlights> {
  List myTravels = [];
  SharedPreferences? _data;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    loadMyTravells();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: myTravels.length,
            itemBuilder: (context, index) {
              return myTravels[index].isEmpty
                  ? const Center(
                      child: Text(
                        'You Have Not Travel Yet By Any Flight',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    )
                  : Card(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Ticket : ${index + 1} \n'
                            'From : ${myTravels[index]['from']} \n'
                            'To : ${myTravels[index]['to']} \n'
                            'CredentialNumber : ${myTravels[index]['credentialNumber']}',
                            style: const TextStyle(fontSize: 25),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  String url = '/user/ticket/myFlights/';
                                  _data = await SharedPreferences.getInstance();
                                  String token =
                                      _data!.getString('t').toString();
                                  Map<String, dynamic> data = {
                                    'flightId': myTravels[index]['flightID'],
                                  };
                                  await DioHelpers.ticketInfo(
                                          url: url, token: token, data: data)
                                      .then((value) {
                                    print(value.data);
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text("Ticket Information"),
                                            content: Text(
                                                'price :${value.data[0]['price']} \$\n'
                                                'date :${value.data[0]['flightDate']}'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('OK'))
                                            ],
                                          );
                                        });
                                  }).catchError((error) {
                                    print(error);
                                  });
                                },
                                child: const Text('get more information'),
                              ),
                              IconButton(
                                onPressed: () async {
                                  String url = "/user/ticket/";
                                  _data = await SharedPreferences.getInstance();
                                  String token =
                                      _data!.getString('t').toString();
                                  String ticketId = myTravels[index]['_id'];
                                  await DioHelpers.deleteTicket(
                                          url: url,
                                          token: token,
                                          tickedId: ticketId)
                                      .then((value) {
                                    loadMyTravells();
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          )
                        ],
                      ),
                    ));
            },
          );
  }

  void loadMyTravells() async {
    setState(() {
      isLoading = true;
    });

    print('button clicked .. loading data');
    SharedPreferences _data = await SharedPreferences.getInstance();
    String _token = _data.get('t').toString();
    await DioHelpers.myFlights(
      token: _token,
      url: '/user/ticket/myFlights',
    ).then((value) {
      setState(() {
        isLoading = false;
      });
      myTravels = value.data['myFlights'][0]['tickets'];
      print(value.data['myFlights'][0]['tickets']);
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print(error);
    });
    print('data is here');
  }
}
