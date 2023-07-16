import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Profile/EditProfile.dart';
import 'package:gp/Screens/Profile/FreelancerProfilePage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:gp/Screens/Profile/EditProfilePicture.dart';

import '../../Provider/myProvider.dart';

class clientProfile extends StatefulWidget {
  final bool myProfile;

  const clientProfile({Key? key, required this.myProfile}) : super(key: key);

  @override
  State<clientProfile> createState() => _clientProfileState();
}

class _clientProfileState extends State<clientProfile> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> visitedProfiles = [];

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
    visitHistory = await jsonResponse['visitList'];
    var name, type, username;

    for (int i = 0; i < visitHistory.length; i++) {
      name = await getNameByID(visitHistory[i]);
      type = await getTypeByID(visitHistory[i]);
      username = await getUsernameByID(visitHistory[i]);

      visitedProfiles.add(
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
    visitedProfiles = [];
    return SafeArea(
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            var height = MediaQuery.of(context).size.height;
            return Scaffold(
              backgroundColor: Colors.grey[300],
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(right: 8.0),
                    leading: widget.myProfile
                        ? null
                        : const BackButton(
                            color: Colors.black,
                          ),
                    trailing: widget.myProfile
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(editProfile.routeName);
                            },
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'OpenSans',
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Container(
                    height: height / 4,
                    decoration: const BoxDecoration(
                        // color: Colors.white,
                        ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          4,
                                  child: InkWell(
                                    onTap: () {
                                      if (widget.myProfile) {
                                        Navigator.of(context).pushNamed(editProfilePicture.routeName);

                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                        width: 120,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.myProfile
                                              ? Provider.of<myProvider>(context)
                                                  .fullName!
                                              : 'Sample Name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          widget.myProfile
                                              ? "@${Provider.of<myProvider>(context).username!}"
                                              : '@Sample Name',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white54,
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.history),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Visit History",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: height / 2 - 70,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: visitedProfiles.length,
                              itemBuilder: (context, index) => inkwellBuilder(
                                  visitedProfiles[index]['id'],
                                  visitedProfiles[index]['name'],
                                  "",
                                  visitedProfiles[index]['type'],
                                  visitedProfiles[index]['username'],
                                  context)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
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
                            fontSize: 14,
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
