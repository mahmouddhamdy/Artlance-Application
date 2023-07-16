import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class updateHourlyRate extends StatelessWidget {
  updateHourlyRate({Key? key}) : super(key: key);
  final storage = const FlutterSecureStorage();

  TextEditingController newHourlyRate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: newHourlyRate,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'New hourly rate'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all(
                    const Size(50, 35),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () async {
                  await updateRate(context);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.7,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updateRate(BuildContext ctx) async {
    if (newHourlyRate.text.isNotEmpty) {
      var url = Uri.parse("http://10.0.2.2:8080/api/v1/users/me");
      var token = await storage.read(key: 'token');
      var response = await http.patch(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(
          {
            "hourlyRate": int.parse(newHourlyRate.text),
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        var snack = const SnackBar(
          content: Text('Hourly Rate Updated! '),
        );
        Future.delayed(const Duration(seconds: 1)).then(
          (_) {
            ScaffoldMessenger.of(ctx).showSnackBar(snack);
            Provider.of<myProvider>(ctx,listen: false).hourlyRate =
                int.parse(newHourlyRate.text);
          },
        );
      } else {
        var snack = const SnackBar(
          content: Text('An error has occurred'),
        );
        Future.delayed(const Duration(seconds: 1)).then(
          (_) {
            ScaffoldMessenger.of(ctx).showSnackBar(snack);
          },
        );
      }
    } else {
      var snack = const SnackBar(
        content: Text('Empty text field!'),
      );
      Future.delayed(const Duration(seconds: 1)).then(
        (_) {
          ScaffoldMessenger.of(ctx).showSnackBar(snack);
        },
      );
    }
  }
}
