import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gp/Screens/SignIn/verifyCode.dart';
import 'package:http/http.dart' as http;

class forgetPassword extends StatefulWidget {
  const forgetPassword({Key? key}) : super(key: key);

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  bool isPasswordVisible = false;
  TextEditingController passwordValue = TextEditingController();
  TextEditingController confirmPasswordValue = TextEditingController();
  TextEditingController emailValue = TextEditingController();
  String? email, password, passwordConfirmation;
  bool? correctMail;

  checkforMail() async {
    bool correctMail;
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/users/send-reset');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    print(response.statusCode);

   if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
     correctMail = true;

   }
   else {
     correctMail = false;
     var jsonResponse = jsonDecode(response.body);
     var errorMsg = jsonResponse['message'];
     var snackBar = SnackBar(
       content: Text(errorMsg!),
     );
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
   return correctMail;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(children: [
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 50,
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
                        controller: emailValue,
                        style: const TextStyle(color: Colors.black),
                        onChanged: (value) => {email = value},
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
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
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) => {password = value},
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password'),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
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
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: confirmPasswordValue,
                              onChanged: (value) =>
                                  {passwordConfirmation = value},
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelText: "Confirm Your New Password",
                                border: InputBorder.none,
                              ),
                              obscureText: !isPasswordVisible,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
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
                  height: 75,
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
                    correctMail = await checkforMail();
                    if (!correctMail!) {

                    }
                    else if (emailValue.text.isEmpty ||
                        passwordValue.text.isEmpty ||
                        confirmPasswordValue.text.isEmpty) {
                      var snackBar = const SnackBar(
                        content: Text('All fields are required'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (passwordValue.text !=
                        confirmPasswordValue.text) {
                      print('a7a');
                      var snackBar = const SnackBar(
                        content: Text('Passwords do not match!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => verifyCode(
                            email: emailValue.text,
                            password: passwordValue.text,
                          ),
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
          )
        ],
      ),
    );
  }
}
