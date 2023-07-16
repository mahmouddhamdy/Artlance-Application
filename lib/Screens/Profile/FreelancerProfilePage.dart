import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Profile/Packages/packages.dart';
import 'package:gp/Screens/Profile/profileTabsMenu.dart';
import 'package:gp/Screens/Profile/EditProfile.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:gp/Screens/Profile/EditProfilePicture.dart';

import '../../Provider/myProvider.dart';
import '../Messaging/MessagingScreen.dart';

class FreelancerProfilePage extends StatefulWidget {
  static const routeName = 'freelancerProfileRoute';
  final bool myProfile;
  String? id;

  FreelancerProfilePage({Key? key, required this.myProfile, this.id})
      : super(key: key);

  @override
  State<FreelancerProfilePage> createState() => _FreelancerProfilePageState();
}

class _FreelancerProfilePageState extends State<FreelancerProfilePage> {
  bool? isLiked;
  String? username, name, mail, profilePic, phoneNum, type, description;
  int? hourlyRate;
  final storage = const FlutterSecureStorage();
  List<dynamic> messages = [];
  var rate;
  List<Map<String, dynamic>> images = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: getAttributes(),
        builder: (context, snapshot) {
          if (name == null || username == null || mail == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
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
                        : null,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 4,
                            child: InkWell(
                              onTap: () {
                                if (widget.myProfile) {
                                  Navigator.of(context)
                                      .pushNamed(editProfilePicture.routeName);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    type!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  widget.myProfile
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () async {
                                                messages = await createChat();
                                                if (!mounted) return;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MessagingScreen(
                                                      messages: messages,
                                                      id: widget.id!,
                                                      name: name!,
                                                      type: type!,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Icon(Icons.message),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                if (isLiked == false) {
                                                  addToFavList();
                                                } else {
                                                  removeFromFavList();
                                                }
                                                setState(() {
                                                  isLiked = !isLiked!;
                                                });
                                              },
                                              child: isLiked == true
                                                  ? const Icon(Icons.favorite)
                                                  : const Icon(
                                                      Icons.favorite_border),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    onPressed: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => packages(
                                            id: widget.id!,
                                            myProfile: widget.myProfile,
                                          ),
                                        ),
                                      ),
                                    },
                                    child: const Text('See Packages'),
                                  ),
                                  rate != null
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          onPressed: () {},
                                          child: SizedBox(
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "$rate/5",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  widget.myProfile
                                      ? Container()
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          onPressed: () async {
                                            var success =
                                                await createBookingOrder();
                                            if (success!) {
                                              var snackBar2 = const SnackBar(
                                                content:
                                                    Text('Request submitted!'),
                                              );
                                              Future.delayed(const Duration(
                                                      seconds: 1))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar2);
                                              });
                                            } else {
                                              var snackBar2 = const SnackBar(
                                                content: Text(
                                                    'An error has occurred'),
                                              );
                                              Future.delayed(const Duration(
                                                      seconds: 2))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar2);
                                              });
                                            }
                                          },
                                          child: const Text('Book'),
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 15.0, right: 15.0),
                    child: profileTabsMenu(
                      hourlyRate: hourlyRate!,
                      mail: mail!,
                      description:description!,
                      id: widget.id,
                      images: images,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  getAttributes() async {
    if (!(Provider.of<myProvider>(context, listen: false).isFreelancer!)) {
      await getAttributesByID();
    } else {
      username = Provider.of<myProvider>(context, listen: false).username!;
      name = Provider.of<myProvider>(context, listen: false).fullName!;
      mail = Provider.of<myProvider>(context, listen: false).email!;
      hourlyRate = Provider.of<myProvider>(context, listen: false).hourlyRate!;
      phoneNum = Provider.of<myProvider>(context, listen: false).phoneNum!;
      type = Provider.of<myProvider>(context, listen: false).freelancerType;
      description = Provider.of<myProvider>(context, listen: false).description;
      widget.id = Provider.of<myProvider>(context, listen: false).id;
      rate = Provider.of<myProvider>(context, listen: false).rate;
    }

    images = await fetchImages();
    await addToVisitList();
    await fetchUserData();

  }

  getAttributesByID() async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/${widget.id}");
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);

    name = await jsonResponse['fullName'];
    username = await jsonResponse['username'];
    mail = await jsonResponse['email'];
    type = await jsonResponse['freelancerType'];
    phoneNum = await jsonResponse['phoneNum'];
    hourlyRate = await jsonResponse['hourlyRate'];
    description = await jsonResponse['description'];
    rate = await jsonResponse['rate'];

  }

  fetchImages() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/portfolio/${widget.id}');
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    List<dynamic> responseList = jsonDecode(response.body);
    images = [];
    for (var obj in responseList) {
      images.add(Map<String, dynamic>.from(obj));
    }
    return images;
  }

  createChat() async {
    List<dynamic> messages = [];
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/create');
    var token = await storage.read(key: 'token');

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
        'senderId': Provider.of<myProvider>(context, listen: false).id!,
      },
      body: jsonEncode({
        'id': widget.id,
      }),
    );
    messages = await fetchMessages();
    return messages;
  }

  fetchMessages() async {
    messages = [];
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/${widget.id}');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );

    Map<dynamic, dynamic> responseList = jsonDecode(response.body);
    messages = responseList['messages'];
    return messages;
  }

  addToFavList() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/clients/fav');
    var token = await storage.read(key: 'token');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
      body: jsonEncode({
        'id': widget.id,
      }),
    );
  }

  removeFromFavList() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/clients/fav/${widget.id}');
    var token = await storage.read(key: 'token');
    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
  }

  fetchUserData() async {
    if (!widget.myProfile) {
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

      var likedList = await jsonResponse['favList'];
      for (int i = 0; i < likedList.length; i++) {
        if (widget.id == likedList[i]) {
          isLiked = true;
        } else {
          isLiked = false;
        }
      }
      if (likedList.length == 0) {
        isLiked = false;
      }
    }
  }

  addToVisitList() async {
    if (!Provider.of<myProvider>(context, listen: false).isFreelancer!) {
      var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/visit");
      var token = await storage.read(key: 'token');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer ${token!}",
        },
        body: jsonEncode(
          {
            'id': widget.id,
          },
        ),
      );
    }
  }

  Future<bool?> createBookingOrder() async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/orders/create");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
      body: jsonEncode(
        {'to': widget.id},
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
