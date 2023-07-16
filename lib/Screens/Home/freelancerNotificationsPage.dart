import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class freelancerNotificationsPage extends StatefulWidget {
  const freelancerNotificationsPage({Key? key}) : super(key: key);

  @override
  State<freelancerNotificationsPage> createState() =>
      _freelancerNotificationsPageState();
}

class _freelancerNotificationsPageState
    extends State<freelancerNotificationsPage> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> Notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.black.withOpacity(0.05),
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: FutureBuilder(
          future: fetchNotifications(),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: Notifications.length,
              itemBuilder: (context, index) {
                return notificationBuilder(
                  Notifications[index]['_id'],
                  Notifications[index]["from"],
                  Notifications[index]["state"],
                  Notifications[index]["sender_id"],
                );
              },
            );
          }),
    );
  }

  notificationBuilder(
      String orderID, String name, String status, String senderID) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 20.0 * 0.75, bottom: 20.0 * 0.75),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(7),
                ),
                constraints: const BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                child: const SizedBox(
                  width: 1,
                  height: 1,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'You have a $status request \n from $name',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                  status == 'Pending'
                      ? IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            var completed = await acceptRequest(senderID);
                            if (completed!) {
                              var snackBar2 = const SnackBar(
                                content: Text('Request marked as accepted! '),
                              );
                              Future.delayed(const Duration(seconds: 1)).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar2);
                              });
                            } else {
                              var snackBar2 = const SnackBar(
                                content: Text('An error has occurred'),
                              );
                              Future.delayed(const Duration(seconds: 2)).then(
                                    (_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar2);
                                },
                              );
                            }
                            setState(() {});
                          },
                        )
                      : Container(),
                  status == 'Pending'
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () async {
                            var completed = await rejectRequest(senderID);
                            if (completed!) {
                              var snackBar2 = const SnackBar(
                                content: Text('Request marked as rejected! '),
                              );
                              Future.delayed(const Duration(seconds: 1)).then((_) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar2);
                              });
                            } else {
                              var snackBar2 = const SnackBar(
                                content: Text('An error has occurred'),
                              );
                              Future.delayed(const Duration(seconds: 2)).then(
                                    (_) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar2);
                                },
                              );
                            }
                            setState(() {});
                          },
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Divider(
            color: Colors.grey.withOpacity(0.3),
          ),
        )
      ],
    );
  }

  fetchNotifications() async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/orders/me");

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
    );
    Notifications = [];
    List<dynamic> list = jsonDecode(response.body);
    for (var obj in list) {
      var name = await getNameByID(obj['from']);
      Notifications.add(
        {
          '_id': Map<String, dynamic>.from(obj)['_id'],
          'state': Map<String, dynamic>.from(obj)['state'],
          'from': name,
          'sender_id': obj['from'],
        },
      );
    }
    print(Notifications);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return true;
    }
    return false;
  }

  getNameByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/$id");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var name = await jsonResponse['fullName'];
    return name;
  }

  acceptRequest(String senderID) async {
    var url =
        Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/orders/accept");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
      body: jsonEncode(
        {
          'from': senderID,
        },
      ),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return true;
    }
    return false;
  }

  rejectRequest(String senderID) async {
    var url =
        Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/orders/refuse");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
      body: jsonEncode(
        {
          'from': senderID,
        },
      ),
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return true;
    }
    return false;
  }
}
