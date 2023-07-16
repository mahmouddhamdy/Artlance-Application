import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Messaging/MessagingScreen.dart';
import '../Profile/FreelancerProfilePage.dart';
import 'package:http/http.dart' as http;

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> favourites = [];

  fetchData() async {
    List visitHistory = [];
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/users/me");
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    visitHistory = await jsonResponse['favList'];
    var name, type, username;

    for (int i = 0; i < visitHistory.length; i++) {
      name = await getNameByID(visitHistory[i]);
      type = await getTypeByID(visitHistory[i]);
      username = await getUsernameByID(visitHistory[i]);

      favourites.add(
        {
          'id': '${visitHistory[i]}',
          'name': name,
          'type': type,
          'username': username
        },
      );
    }
  }

  getNameByID(String id) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/$id');
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

  getUsernameByID(String id) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/$id');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var username = await jsonResponse['username'];
    return username;
  }

  getTypeByID(String id) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/$id');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var type = await jsonResponse['freelancerType'];
    return type;
  }

  @override
  Widget build(BuildContext context) {
    favourites = [];
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          print(favourites);
          return Scaffold(
            appBar: AppBar(
              shadowColor: Colors.blueGrey.withOpacity(0),
              backgroundColor: Colors.black.withOpacity(0.05),
              leading: const BackButton(color: Colors.black),
              title: const Text(
                "Favourites",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            body: favourites.length == 0
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
                          "No freelancers found",
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 25,
                              letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: favourites.length,
                        itemBuilder: (context, index) => inkwellBuilder(
                            favourites[index]['id'],
                            favourites[index]['name'],
                            "",
                            favourites[index]['type'],
                            favourites[index]['username'],
                            context)),
                  ),
          );
        });
  }

  Widget inkwellBuilder(String id, String name, String imgPath, String type,
      String username, BuildContext ctx) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Future.delayed(const Duration(seconds: 1)).then(
                  (_) {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (ctx) => FreelancerProfilePage(
                      myProfile: false,
                      id: id,
                    ),
                  ),
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(ctx).size.width / 2 - 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(ctx).size.width / 2 - 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        textAlign: TextAlign.center,
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100,minWidth: 50),
                      child: Text(
                        '@$username',
                        style: Theme.of(ctx).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100,minWidth: 50),
                      child: Text(
                        type,
                        style: Theme.of(ctx).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
          child: Divider(
            color: Colors.black.withOpacity(0.8),
            height: 50,
          ),
        ),
      ],
    );
  }
}
