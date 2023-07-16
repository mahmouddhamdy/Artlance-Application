import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gp/Models/Freelancer.dart';
import 'package:gp/Models/freelancerSpeciality.dart';
import 'package:gp/Screens/SignUp/VerifyEmailPage.dart';

import 'package:http/http.dart' as http;

class additionalRegistrationDetails extends StatefulWidget {
  final String username, name, image, email, password;

  const additionalRegistrationDetails(
      {Key? key,
      required this.username,
      required this.name,
      required this.image,
      required this.email,
      required this.password})
      : super(key: key);

  @override
  State<additionalRegistrationDetails> createState() =>
      _additionalRegistrationDetailsState();
}

var specialities = ['Photographer', 'Graphic Designer','Artist'];

enum Users { freelancer, normalUser }

class _additionalRegistrationDetailsState
    extends State<additionalRegistrationDetails> {
  Users? _user;
  String? _selectedSpeciality = specialities.first;
  Freelancer freelancer = Freelancer(speciality: Speciality.digitalArtist);

  bool isFreelancer = false;
  TextEditingController addressValue = TextEditingController();
  TextEditingController hourlyRateValue = TextEditingController();
  TextEditingController descriptionValue = TextEditingController();
  TextEditingController phoneNumberValue = TextEditingController();
  String? errorText;
  double locationLatitude = 0;
  double locationLongitude = 0;
  bool? isFreelancerInvalid;
  bool? isClientInvalid;

  //bool? isInputValid;
  void getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    else {

      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        locationLatitude = position.latitude;
        locationLongitude = position.altitude;
      });

    }

  }

  SignUpFreelancer() async {
    var error;
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": widget.username,
        "fullName": widget.name,
        "email": widget.email,
        'profilePic': widget.image,
        "password": widget.password,
        'freelancerType': _selectedSpeciality,
        "address": [locationLatitude,locationLongitude],
        "phoneNum": freelancer.phoneNumber,
        "hourlyRate": int.parse(freelancer.hourlyRate),
        "description": freelancer.description,
      }),
    );
    var jsonResponse = await jsonDecode(response.body);
    errorText = await jsonResponse['message'];

    if (errorText != null) {
      setState(() {
        error = true;
      });
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(errorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        error = false;
      });
    }
    return error;
  }

  SignUpClient() async {
    var error;

    var url = Uri.parse('http://10.0.2.2:8080/api/v1/clients/');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "username": widget.username,
        "fullName": widget.name,
        "email": widget.email,
        'profilePic':widget.image,
        "password": widget.password,
      }),
    );

    var jsonResponse = jsonDecode(response.body);
    errorText = jsonResponse['message'];

    if (errorText != null) {
      error = true;
      if (!mounted) return;
      var snackBar = SnackBar(
        content: Text(errorText!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      error = false;
    }
    return error;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                ListTile(
                  horizontalTitleGap: 0.0,
                  title: Text(
                    "I'm a Freelancer",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                        "Sign up as a freelancer and Submit your work to our application",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      _user == Users.freelancer
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    value: _selectedSpeciality,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[600],
                                    ),
                                    items: specialities.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'OpenSans',
                                            fontSize: 14,
                                            letterSpacing: 0.1,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? val) {
                                      setState(() {
                                        _selectedSpeciality = val!;
                                        switch (_selectedSpeciality) {
                                          case 'Digital Artist':
                                            {
                                              freelancer.speciality =
                                                  Speciality.digitalArtist;
                                              break;
                                            }
                                          case 'UX/UI Designer':
                                            {
                                              freelancer.speciality =
                                                  Speciality.uiDesigner;
                                              break;
                                            }
                                          case 'Photographer':
                                            {
                                              freelancer.speciality =
                                                  Speciality.photographer;
                                              break;
                                            }
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      getCurrentLocation();
                                    },
                                    child: const Row(
                                      children: [
                                        Text("Get Current Location"),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: hourlyRateValue,
                                      onChanged: (value) =>
                                          {freelancer.hourlyRate = value},
                                      keyboardType: TextInputType.number,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        suffixText: 'EGP',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        border: InputBorder.none,
                                        labelText: 'Hourly Rate',
                                        labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: phoneNumberValue,
                                      onChanged: (value) =>
                                          {freelancer.phoneNumber = value},
                                      keyboardType: TextInputType.number,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        border: InputBorder.none,
                                        labelText: 'Phone Number',
                                        labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: descriptionValue,
                                      onChanged: (value) =>
                                          {freelancer.description = value},
                                      keyboardType: TextInputType.name,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        border: InputBorder.none,
                                        labelText: 'Describe your work..',
                                        labelStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : Container()
                    ],
                  ),
                  leading: Radio<Users>(
                    value: Users.freelancer,
                    groupValue: _user,
                    onChanged: (Users? value) {
                      setState(() {
                        _user = value;
                        isFreelancer = true;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  horizontalTitleGap: 0.0,
                  selectedTileColor: Colors.white,
                  title: Text(
                    "I'm a Client",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    "Sign up as a user to see individuals' portfolios and contact freelancers",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  leading: Radio<Users>(
                    value: Users.normalUser,
                    groupValue: _user,
                    onChanged: (Users? value) {
                      setState(() {
                        _user = value;
                        isFreelancer = false;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                    minimumSize: MaterialStateProperty.all(const Size(250, 35)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () async {
                    if (isFreelancer) {
                      isFreelancerInvalid = await SignUpFreelancer();
                    } else {
                      isClientInvalid = await SignUpClient();
                    }
                    isFreelancerInvalid ??= false;
                    isClientInvalid ??= false;

                    if (isFreelancerInvalid! || isClientInvalid!) {
                    } else {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>verifyEmail(email: widget.email),
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
              ],
            ),
          )
        ],
      ),
    ));
  }
}
