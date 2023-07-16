import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gp/Screens/Home/HomePage.dart';
import 'package:gp/Screens/SignIn/ForgetPassword.dart';
import 'package:gp/Screens/SignUp/SignUpPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../Models/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Provider/myProvider.dart';
import '../Home/ExplorePage.dart';
import '../Home/FavouritesPage.dart';
import '../Home/HistoryPage.dart';
import '../Home/clientNotificationsPage.dart';
import '../Home/freelancerNotificationsPage.dart';
import '../Profile/profilePage.dart';

class SignInPage extends StatefulWidget {
  static const routeName = 'SignInRoute';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = false;
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  User user = User();
  final storage = const FlutterSecureStorage();

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



  Future loginUser() async {
    late bool correctInformation;
    var body = {'email': user.email, 'password': user.password};
    if (user.email.isNotEmpty && user.password.isNotEmpty) {
      var url = Uri.parse("http://10.0.2.2:8080/api/v1/auth/create");
      var res = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      var jsonResponse = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        var myToken = jsonResponse['access'];
        await storage.write(key: 'token', value: myToken);
        var refreshToken = jsonResponse['refresh'];
        await storage.write(key: 'refresh', value: refreshToken);
        correctInformation = true;
        fetchData();
      } else {
        if (!mounted) return;
        var errorMsg = jsonResponse['message'];
        var snackBar = SnackBar(
          content: Text(errorMsg!),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        correctInformation = false;
      }
    }
    print('Sign in token ${await storage.read(key: 'token')}');
    return correctInformation;
  }

  Future<void> fetchData() async {
    String username, fullName, id, mail, userType;
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/users/me");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    print(response.body);
    var jsonResponse = await jsonDecode(response.body);
    id = await jsonResponse['_id'];
    username = await jsonResponse['username'];
    fullName = await jsonResponse['fullName'];
    userType = await jsonResponse['userType'];
    mail = await jsonResponse['email'];
    if (!mounted) return;
    Provider.of<myProvider>(context, listen: false).changeUsername(username);
    Provider.of<myProvider>(context, listen: false).changeName(fullName);
    Provider.of<myProvider>(context, listen: false).changeID(id);
    Provider.of<myProvider>(context, listen: false).changeMail(mail);
    print(Provider
        .of<myProvider>(context, listen: false)
        .username);

    if (userType == 'CLIENT') {
      Provider.of<myProvider>(context, listen: false).selectType(false);
      Provider.of<myProvider>(context, listen: false).setAvailablePages(_clientPages);
    } else {
      Provider.of<myProvider>(context, listen: false).selectType(true);
      var freelancerType = await jsonResponse['freelancerType'];
      var phoneNum = await jsonResponse['phoneNum'];
      var hourlyRate = await jsonResponse['hourlyRate'];
      var description = await jsonResponse['description'];
      var rate = await jsonResponse['rate'];
      Provider.of<myProvider>(context, listen: false).selectFreelancingType(freelancerType);
      Provider.of<myProvider>(context, listen: false).changePhoneNum(phoneNum);
      Provider.of<myProvider>(context, listen: false).changeHourlyRate(hourlyRate);
      Provider.of<myProvider>(context, listen: false).changeDescription(description);
      Provider.of<myProvider>(context, listen: false).setRate(rate);
      Provider.of<myProvider>(context, listen: false).setAvailablePages(_freelancerPages);

    }
  }

  @override
  Widget build(BuildContext context) {
    bool proceed;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Welcome Back!",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0),
                          ),
                        ),
                        child: Column(children: [
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: TextField(
                                  controller: emailValue,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) => {user.email = value},
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Email'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: passwordValue,
                                        onChanged: (value) =>
                                        {user.password = value},
                                        style: const TextStyle(
                                            color: Colors.black),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Password'),
                                        obscureText: !isPasswordVisible,
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isPasswordVisible =
                                            !isPasswordVisible;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.visibility,
                                          size: 18,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                              minimumSize:
                              MaterialStateProperty.all(const Size(300, 35)),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () async {
                              var snackBar = const SnackBar(
                                content: Text('Loading...'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  snackBar);
                              proceed = await loginUser();
                              if (proceed) {
                                Navigator.of(context).pushNamed(
                                    HomePage.routeName);
                              }
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontFamily: 'Schyler',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 21),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Not a user? ",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(SignUpPage.routeName);
                                  },
                                  child: Text(
                                    "Click here to Sign Up",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurple[900],
                                    ),
                                  ),
                                ),
                              ]),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const forgetPassword(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
