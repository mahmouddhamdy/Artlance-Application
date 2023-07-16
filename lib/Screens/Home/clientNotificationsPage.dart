import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class clientNotificationsPage extends StatefulWidget {
  const clientNotificationsPage({Key? key}) : super(key: key);

  @override
  State<clientNotificationsPage> createState() =>
      _clientNotificationsPageState();
}

class _clientNotificationsPageState extends State<clientNotificationsPage> {
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
                  Notifications[index]["provider"],
                  Notifications[index]["state"],
                  Notifications[index]["provider_id"],
                );
              },
            );
          }),
    );
  }

  notificationBuilder(
      String orderID, String name, String status, String providerID) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: 20.0 * 0.75),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You have a $status request from $name',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      status == 'In progress'
                          ? const SizedBox(
                              height: 10,
                            )
                          : Container(),
                      status == 'In progress'
                          ? Text(
                              'Click the tick mark to mark request as completed',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontFamily: 'OpenSans',
                                color: Colors.black.withOpacity(0.7),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              status == 'In progress'
                  ? IconButton(
                      onPressed: () async {
                        var completed = await completeOrder(providerID);
                        if (completed!) {
                          var snackBar2 = const SnackBar(
                            content: Text('Request marked as completed! '),
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
                      icon: const Icon(Icons.check_circle_outline),
                    )
                  : Container(),
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
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/orders/me");

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
      var name = await getNameByID(obj['to']);
      Notifications.add(
        {
          '_id': Map<String, dynamic>.from(obj)['_id'],
          'state': Map<String, dynamic>.from(obj)['state'],
          'provider': name,
          'provider_id': obj['to'],
        },
      );
    }
  }

  getNameByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/$id");
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

  completeOrder(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/orders/complete");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
      body: jsonEncode(
        {
          'to': id,
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
