import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Profile/EditProfile.dart';
import 'package:gp/Screens/SignIn/SignInPage.dart';

class SettingsPage extends StatelessWidget {
  final storage = const FlutterSecureStorage();

  static const routeName = 'Settings';

  const SettingsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.black.withOpacity(0.05),
        leading: const BackButton(color: Colors.black),
        title: const Text("Settings",style: TextStyle(color: Colors.black,fontSize: 21),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black,),
              trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.of(context).pushNamed(editProfile.routeName);
              },
            ),
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.help,color: Colors.black,),
              trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
              title: const Text('Help & Support'),
              onTap: () {

              },
            ),
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.logout,color: Colors.black,),
              title: const Text('Logout'),
              onTap: () async {
                await storage.write(key: 'token', value: null);
                Navigator.of(context).pushNamed(SignInPage.routeName);

              },
            ),
          ],
        ),
      ),
    );
  }
}