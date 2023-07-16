import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class addPackage extends StatelessWidget {
  addPackage({Key? key}) : super(key: key);
  TextEditingController packageNumber = TextEditingController();
  TextEditingController packageDescription = TextEditingController();
  TextEditingController packagePrice = TextEditingController();
  final storage = const FlutterSecureStorage();


  createPackage(BuildContext context) async {
    if (packageNumber.text.isNotEmpty && packageDescription.text.isNotEmpty && packageNumber.text.isNotEmpty) {
      var url = Uri.parse('http://10.0.2.2:8080/api/v1/packages/');
      var token = await storage.read(key: 'token');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer ${token!}",
        },
        body: jsonEncode(
          {
            'photosNum': int.parse(packageNumber.text),
            'description' :packageDescription.text,
            'price':int.parse(packagePrice.text),
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 203) {
        var snackBar = const SnackBar(
          content: Text('Package added!'),
          duration: Duration(seconds: 1),
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } );
      }
      else {
        var jsonResponse = await jsonDecode(response.body);
        String error = await jsonResponse['message'];
        var snackBar = SnackBar(
          content: Text(error),
          duration: Duration(seconds: 1),
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } );
      }
    }
    else {
      var snackBar = const SnackBar(
        content: Text('All fields are required!'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }


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
                    controller: packageNumber,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Number of photos ..'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                    controller: packageDescription,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Package Description..'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                    controller: packagePrice,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Package Price..'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                )),
                minimumSize: MaterialStateProperty.all(const Size(150, 35)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                var snackBar = const SnackBar(
                  content: Text('Adding...'),
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                await createPackage(context);
              },
              child: const Text(
                "Add",
                style: TextStyle(
                    fontFamily: 'Schyler',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 21),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
