import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Profile/updateReview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Provider/myProvider.dart';

class reviewsPage extends StatefulWidget {
  final String? id;

  reviewsPage({super.key, required this.id});

  @override
  State<reviewsPage> createState() => _reviewsPageState();
}

class _reviewsPageState extends State<reviewsPage> {
  final storage = const FlutterSecureStorage();

  List<Map<String, dynamic>> reviews = [];

  fetchReviews() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/reviews/${widget.id}');
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    reviews = [];
    List<dynamic> list = jsonDecode(response.body);
    for (var obj in list) {
      var name = await getNameByID(obj['from']);
      reviews.add(
        {
          '_id': Map<String, dynamic>.from(obj)['_id'],
          'content': Map<String, dynamic>.from(obj)['content'],
          'from': name,
          'sender_id': obj['from'],
          'sentiment': Map<String, dynamic>.from(obj)['sentiment'],
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchReviews(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            shadowColor: Colors.blueGrey.withOpacity(0),
            backgroundColor: Colors.black.withOpacity(0.05),
            leading: const BackButton(color: Colors.black),
            title: const Text(
              "All Reviews",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          body: reviews.isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/EmptyList.png'),
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "No Reviews found",
                        style: TextStyle(
                            fontFamily: 'Schyler',
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 25,
                            letterSpacing: 0.2),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return buildReview(
                        context,
                        reviews[index]['_id'],
                        reviews[index]['from'],
                        reviews[index]['sender_id'],
                        reviews[index]['content'],
                        reviews[index]['sentiment']);
                  },
                ),
        );
      },
    );
  }

  Widget buildReview(BuildContext ctx, String reviewID, String reviewerName,
      String reviewerID, String reviewText, int sentiment) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      color: Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    reviewerName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  children: [
                    sentiment == 1
                        ? Container(
                            decoration: BoxDecoration(
                              //  color: Colors.green,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.black,
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(reviewText),
          ),
          reviewerID == Provider.of<myProvider>(ctx, listen: false).id
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => updateReview(
                              reviewID: reviewID,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                        size: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await deleteReview(reviewID, ctx);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.blueGrey,
                        size: 16,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
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

  deleteReview(String reviewID, BuildContext ctx) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/reviews/$reviewID');
    var token = await storage.read(key: 'token');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Package Deleted!'),
        duration: Duration(seconds: 1),
      );
      Future.delayed(const Duration(seconds: 1)).then((_) {
        ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
      });
      setState(() {});
    }
  }
}
