import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:gp/Screens/Home/HistoryPage.dart';
import 'package:provider/provider.dart';
import '../Profile/profilePage.dart';
import 'ExplorePage.dart';
import 'FavouritesPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'clientNotificationsPage.dart';
import 'freelancerNotificationsPage.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'HomePageRoute';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  late String username;
  late String fullName;
  late String id;
  final List<Widget> _clientPages = [
    const ExplorePage(),
    const FavouritesPage(),
    const clientNotificationsPage(),
    const historyPage(),
    const profilePage(
      myProfile: true,
    ),
  ];

  final List<Widget> _freelancerPages = [
    const historyPage(),
    const freelancerNotificationsPage(),
    const profilePage(
      myProfile: true,
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (Provider.of<myProvider>(context, listen: true).isFreelancer ==
                null) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                bottomNavigationBar: GNav(
                    activeColor: Colors.black,
                    color: Colors.blueGrey,
                    curve: Curves.decelerate,
                    backgroundColor: const Color(0x00ffffff),
                    tabMargin: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      bottom: 5.0,
                    ),
                    tabBackgroundColor: Colors.white.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    iconSize: 25,
                    onTabChange: (value) {
                      Provider.of<myProvider>(context, listen: false)
                          .changeIndex(value);
                    },
                    tabs: Provider.of<myProvider>(context, listen: true)
                            .isFreelancer!
                        ? const [
                            GButton(
                              icon: (Icons.chat),
                              iconSize: 20,
                            ),
                            GButton(
                              icon: Icons.notifications,
                              iconSize: 25,
                            ),
                            GButton(
                              icon: Icons.person,
                              iconSize: 25,
                            )
                          ]
                        : const [
                            GButton(
                              icon: (Icons.home),
                              iconSize: 25,
                            ),
                            GButton(
                              icon: (Icons.favorite),
                              iconSize: 25,
                            ),
                            GButton(
                              icon: Icons.notifications,
                              iconSize: 25,
                            ),
                            GButton(
                              icon: (Icons.mark_chat_unread),
                              iconSize: 20,
                            ),
                            GButton(
                              icon: Icons.person,
                              iconSize: 25,
                            )
                          ]),
                body: Provider.of<myProvider>(context, listen: false)
                        .availablePages?[
                    Provider.of<myProvider>(context).homePageIndex],
              );
            }
          }),
    );
  }

  Future<void> fetchData() async {
    if (Provider.of<myProvider>(context, listen: false).isFreelancer == null) {
      String username, fullName, id, mail, userType;
      var url = Uri.parse("http://10.0.2.2:8080/api/v1/users/me");
      var token = await storage.read(key: 'token');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 401 || response.statusCode == 403) {
        await refreshToken();
        await fetchData();
      } else {
        var jsonResponse = await jsonDecode(response.body);
        id = await jsonResponse['_id'];
        username = await jsonResponse['username'];
        fullName = await jsonResponse['fullName'];
        userType = await jsonResponse['userType'];
        mail = await jsonResponse['email'];
        if (!mounted) return;

        Provider.of<myProvider>(context, listen: false)
            .changeUsername(username);
        Provider.of<myProvider>(context, listen: false).changeName(fullName);
        Provider.of<myProvider>(context, listen: false).changeID(id);
        Provider.of<myProvider>(context, listen: false).changeMail(mail);

        if (userType == 'CLIENT') {
          Provider.of<myProvider>(context, listen: false).selectType(false);
          Provider.of<myProvider>(context, listen: false)
              .setAvailablePages(_clientPages);
        } else {
          Provider.of<myProvider>(context, listen: false).selectType(true);
          var freelancerType = await jsonResponse['freelancerType'];
          var phoneNum = await jsonResponse['phoneNum'];
          var hourlyRate = await jsonResponse['hourlyRate'];
          var description = await jsonResponse['description'];
          var rate = await jsonResponse['rate'];
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Provider.of<myProvider>(context, listen: false)
                .selectFreelancingType(freelancerType);
            Provider.of<myProvider>(context, listen: false)
                .changePhoneNum(phoneNum);
            Provider.of<myProvider>(context, listen: false)
                .changeHourlyRate(hourlyRate);
            Provider.of<myProvider>(context, listen: false).setRate(rate);

            Provider.of<myProvider>(context, listen: false)
                .changeDescription(description);
            Provider.of<myProvider>(context, listen: false)
                .setAvailablePages(_freelancerPages);
          });
        }
      }
    }
  }
  Future<void> refreshToken() async {
    String? refreshToken = await storage.read(key: 'refresh');
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/auth/refresh");

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${await storage.read(key: 'token')}",
      },
      body: jsonEncode(
        {
          'token': refreshToken,
        },
      ),
    );
    var jsonResponse = jsonDecode(response.body);
    var myToken = jsonResponse['access'];
    await storage.write(key: 'token', value: myToken);
    refreshToken = jsonResponse['refresh'];
    await storage.write(key: 'refresh', value: refreshToken);
  }
}
