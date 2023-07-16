import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gp/Screens/SignIn/SignInPage.dart';
import 'package:gp/Screens/SignUp/AdditionalRegisterationDetails.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary/cloudinary.dart';

import '../../Models/User.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = 'SignUpRoute';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = false;
  User user = User();
  TextEditingController usernameValue = TextEditingController();
  TextEditingController nameValue = TextEditingController();
  TextEditingController emailValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  bool? isUsernameValid;
  bool? isNameValid;
  bool? isEmailValid;
  bool? isPasswordValid;
  bool? inputFailure;

  String? usernameErrorText;
  String? nameErrorText;
  String? emailErrorText;
  String? passwordErrorText;

  final ImagePicker picker = ImagePicker();
  File? pickedImage;
  String ImageUrl =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '788564269827684',
    apiSecret: 'qqCcksWCmccWU8Uq_00FHmqstFI',
    cloudName: 'dvd0x8c5z',
  );

  fetchImage() async {
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    var img = File(image!.path);
    var size = await (img.length());
    if (size > 1000000) {
      if (!mounted) return;
      var snackBar = const SnackBar(
        content:
            Text('File too big! Please choose an image smaller than 1MBs '),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        pickedImage = File(image.path);
      });

      ImageToUrl(pickedImage);
    }
  }

  void ImageToUrl(File? img) async {
    final response = await cloudinary.upload(
        file: img!.path,
        fileBytes: img.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        fileName: 'ProfilePicture');

    if (response.isSuccessful) {
      ImageUrl = response.secureUrl!;
    }
  }

  checkForUsername(String value) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/data/validate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "dataType": "USERNAME",
        "data": user.username,
      }),
    );
    print(response.body);
    print(response.statusCode);

    var jsonResponse = await jsonDecode(response.body);
    usernameErrorText = await jsonResponse['message'];

    if (usernameErrorText != null) {
      setState(() {
        isUsernameValid = false;
      });
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(usernameErrorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        isUsernameValid = true;
      });
    }
    return isUsernameValid;
  }

  checkForName(String value) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/data/validate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "dataType": "FULLNAME",
        "data": user.name,
      }),
    );
    var jsonResponse = await jsonDecode(response.body);
    nameErrorText = await jsonResponse['message'];

    if (nameErrorText != null) {
      setState(() {
        isNameValid = false;
      });
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(nameErrorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        isNameValid = true;
      });
    }
    return isNameValid;
  }

  checkForEmail(String value) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/data/validate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "dataType": "EMAIL",
        "data": user.email,
      }),
    );
    var jsonResponse = await jsonDecode(response.body);
    emailErrorText = await jsonResponse['message'];
    if (emailErrorText != null) {
      setState(() {
        isEmailValid = false;
      });
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(emailErrorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        isEmailValid = true;
      });
    }
    return isEmailValid;
  }

  checkForPassword(String value) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/data/validate');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "dataType": "PASSWORD",
        "data": user.password,
      }),
    );
    var jsonResponse = await jsonDecode(response.body);
    passwordErrorText = await jsonResponse['message'];
    if (passwordErrorText != null) {
      setState(() {
        isPasswordValid = false;
      });
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(passwordErrorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        isPasswordValid = true;
      });
    }
    return isPasswordValid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Let's Get Started!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text("Create your account",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Column(children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundImage: pickedImage == null
                                ? const NetworkImage(
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png')
                                : FileImage(pickedImage!) as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: IconButton(
                                onPressed: fetchImage,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox(
                          height: 45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextField(
                                controller: usernameValue,
                                onChanged: (value) {
                                  setState(() {
                                    user.username = value;
                                  });
                                },
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  border: InputBorder.none,
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox(
                          height: 45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: nameValue,
                                onChanged: (value) {
                                  user.name = value;
                                },
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  border: InputBorder.none,
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox(
                          height: 45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: emailValue,
                                onChanged: (value) => {user.email = value},
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  border: InputBorder.none,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: SizedBox(
                          height: 45,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5.0),
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
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        border: InputBorder.none,
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
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
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                          minimumSize:
                              MaterialStateProperty.all(const Size(250, 35)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          isUsernameValid =
                              await checkForUsername(user.username);
                          isNameValid = await checkForName(user.name);
                          isEmailValid = await checkForEmail(user.email);
                          isPasswordValid =
                              await checkForPassword(user.password);
                          if (isUsernameValid! &&
                              isNameValid! &&
                              isEmailValid! &&
                              isPasswordValid!) {
                            inputFailure = false;
                          } else {
                            inputFailure = true;
                          }
                          if (inputFailure == true || inputFailure == null) {
                          } else if (inputFailure == false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    additionalRegistrationDetails(
                                        username: user.username,
                                        name: user.name,
                                        image: ImageUrl,
                                        email: user.email,
                                        password: user.password),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 21),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already a user? ",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(SignInPage.routeName);
                            },
                            child: Text(
                              "Click here to login",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.deepPurple[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
