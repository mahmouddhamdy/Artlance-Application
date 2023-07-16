import 'package:flutter/material.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:gp/Screens/Home/HistoryPage.dart';
import 'package:gp/Screens/Profile/EditProfilePicture.dart';
import 'package:gp/Screens/Profile/EditProfile.dart';
import 'package:gp/Screens/Messaging/MessagingScreen.dart';
import 'package:gp/Screens/Profile/UpdateMail.dart';
import 'package:gp/Screens/Profile/UpdatePassword.dart';
import 'package:gp/Screens/Home/SettingsPage.dart';
import 'Screens/Home/HomePage.dart';
import 'Screens/SignUp/SignUpPage.dart';
import 'package:gp/Screens/SignIn/SignInPage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget startingPage = const SignInPage();
  final storage = const FlutterSecureStorage();
  String? finalToken;


  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {

    String? token = await storage.read(key: 'token');
    if (token != null) {
      setState(() {
        startingPage = const HomePage();
        finalToken = token;
      });
    } else {
      setState(() {
        startingPage = const SignInPage();
        finalToken = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(finalToken);
    return ChangeNotifierProvider<myProvider>(
      create: (_) => myProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Artlance',
        themeMode: ThemeMode.light,
        theme: ThemeData(
          canvasColor: Colors.white.withOpacity(0.95),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith(
                (states) => Colors.black87), //<-- SEE HERE
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          hintColor: Colors.grey,
          fontFamily: 'OpenSans',
          primarySwatch: Colors.grey,
          textTheme: ThemeData.light().textTheme.copyWith(
                labelSmall: TextStyle(
                    fontFamily: 'Schyler',
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 12,
                    letterSpacing: 0.2),
                displaySmall: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                displayMedium: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                bodySmall: const TextStyle(
                  fontSize: 12,
                  // color: Colors.black,
                ),
                bodyMedium: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
                titleSmall: const TextStyle(
                  fontSize: 22,
                  // color: Colors.black,
                ),
                titleLarge: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
        ),
        home:finalToken == null? const SignInPage() : startingPage,
        routes: {
          SignUpPage.routeName: (context) => const SignUpPage(),
          SignInPage.routeName: (context) => const SignInPage(),
          HomePage.routeName: (context) => const HomePage(),
          SettingsPage.routeName: (context) => const SettingsPage(),
          editProfile.routeName: (context) => const editProfile(),
          editProfilePicture.routeName: (context) => const editProfilePicture(),
          updatePassword.routeName: (context) => const updatePassword(),
          updateMail.routeName: (context) => const updateMail(),
          historyPage.routeName: (context) => const historyPage(),
        },
      ),
    );
  }
}
