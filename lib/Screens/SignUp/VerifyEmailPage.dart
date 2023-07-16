import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gp/Screens/SignIn/SignInPage.dart';
import 'package:http/http.dart' as http;

class verifyEmail extends StatefulWidget {
  final String email;
  static const routeName = 'verifyEmail';


  const verifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  TextEditingController codeValue = TextEditingController();
  bool? isCorrect;

  resendVerification() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/users/send-verify');

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email' : widget.email,
      }),
    );
    print(response.body);
    if (!mounted) return;
    if (response.statusCode == 200 || response.statusCode == 201 ||
        response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('A code has been re-sent to you'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      var jsonResponse = jsonDecode(response.body);
      var errorMsg = jsonResponse['message'];
      var snackBar = SnackBar(
        content: Text(errorMsg!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  checkForCode() async {
    bool correct;
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/users/verify');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': widget.email,
        'code': codeValue.text,
      }),
    );
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201 ||
        response.statusCode == 204) {
      correct = true;
    }
    else {
      correct = false;
      var jsonResponse = jsonDecode(response.body);
      var errorMsg = jsonResponse['message'];
      var snackBar = SnackBar(
        content: Text(errorMsg!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return correct;
  }

  @override
  Widget build(BuildContext context) {
    bool successful;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.blueGrey.withOpacity(0),
          backgroundColor: Colors.blueGrey.withOpacity(0),
          leading: const BackButton(color: Colors.black),
        ),
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage('assets/images/EmailIcon.png'),
                  radius: 55,
                ),

                Text(
                  "An code has been sent to you \n to complete your verification",
                  style: TextStyle(
                      fontFamily: 'Schyler',
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 18,
                      letterSpacing: 0.2),
                ),

                const SizedBox(height: 25,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35.0),
                      topRight: Radius.circular(35.0),
                    ),
                  ),
                  child: Column(children: [
                    const SizedBox(
                      height: 10,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: codeValue,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Enter code..'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        minimumSize: MaterialStateProperty.all(const Size(300, 35)),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () async {
                        successful = await checkForCode();
                        if (!mounted) return;
                        if (successful) {
                          var snackBar = const SnackBar(
                            content: Text('Success!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        }

                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                            fontFamily: 'Schyler',
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 21),
                      ),
                    ),
                  ]),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't get a message? ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    InkWell(
                      onTap: () async {
                        await resendVerification();
                      },
                      child: Text(
                        "Click here to resend",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
