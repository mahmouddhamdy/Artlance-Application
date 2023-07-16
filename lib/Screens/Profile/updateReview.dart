import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class updateReview extends StatelessWidget {
  final String reviewID;

  updateReview({Key? key, required this.reviewID}) : super(key: key);
  TextEditingController newReviewText = TextEditingController();
  final storage = const FlutterSecureStorage();

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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: TextField(
                    maxLength: 75,
                    controller: newReviewText,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Update your review..'),
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
                  var updated = await publishUpdate();
                  if (updated!) {
                    var snackBar2 = const SnackBar(
                      content: Text('Review Updated! '),
                    );
                    Future.delayed(
                        const Duration(seconds: 1))
                        .then((_) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar2);
                    });
                  } else {
                    var snackBar2 = const SnackBar(
                      content: Text(
                          "An error has occurred!"),
                    );
                    Future.delayed(
                        const Duration(seconds: 2))
                        .then(
                          (_) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar2);
                      },
                    );
                  }
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

  publishUpdate() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/reviews/$reviewID');
    var token = await storage.read(key: 'token');
    var response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
      body: jsonEncode(
        {
          'content': newReviewText.text,
        },
      ),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 203 ||
        response.statusCode == 204) {
      return true;
    } else {
      return false;
    }

  }
}
