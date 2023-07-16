import 'package:flutter/material.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:gp/Screens/Profile/ClientProfile.dart';
import 'package:gp/Screens/Profile/FreelancerProfilePage.dart';
import 'package:provider/provider.dart';

class profilePage extends StatefulWidget {
  final bool myProfile;

  const profilePage({Key? key, required this.myProfile}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<myProvider>(context,listen: true).isFreelancer!
          ? FreelancerProfilePage(
              myProfile: widget.myProfile,
            )
          : clientProfile(
              myProfile: widget.myProfile,
            ),
    );
  }
}
