import 'package:flutter/material.dart';
import 'package:gp/Screens/Profile/EditProfilePicture.dart';
import 'package:gp/Screens/Profile/UpdatePassword.dart';
import 'package:gp/Screens/Profile/UpdateMail.dart';
import 'package:gp/Screens/Profile/addPortfolioItems.dart';
import 'package:gp/Screens/Profile/updateHourlyRate.dart';
import 'package:gp/Screens/Profile/updatePhoneNum.dart';
import 'package:provider/provider.dart';

import '../../Provider/myProvider.dart';

class editProfile extends StatefulWidget {
  static const routeName = 'EditProfile';

  const editProfile({Key? key}) : super(key: key);

  @override
  State<editProfile> createState() => _editProfileState();
}


class _editProfileState extends State<editProfile> {
  bool firstViewable = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black,),
              trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
              title: const Text('Update Profile Information'),

              onTap: () {
                setState(() {
                  firstViewable = !firstViewable;
                });
              },
            ),
            firstViewable == true?
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: 5,),
                        ListTile(
                          horizontalTitleGap: 2.0,
                          leading: const Icon(Icons.camera_outlined,color: Colors.black,),
                          trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
                          title: const Text('Change Your Profile Picture'),

                          onTap: () {
                             Navigator.of(context).pushNamed(editProfilePicture.routeName);
                          },
                        ),
                        Provider.of<myProvider>(context, listen: true).isFreelancer!? ListTile(
                          horizontalTitleGap: 2.0,
                          leading: const Icon(Icons.camera_outlined,color: Colors.black,),
                          trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
                          title: const Text('Add portfolio items'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const addPortfolioItems(),
                              ),
                            );
                          },
                        ) : Container(),
                        Provider.of<myProvider>(context, listen: true).isFreelancer!? ListTile(
                          horizontalTitleGap: 2.0,
                          leading: const Icon(Icons.money_off_sharp,color: Colors.black,),
                          trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
                          title: const Text('Update hourly rate'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  updateHourlyRate(),
                              ),
                            );
                          },
                        ) : Container(),
                        Provider.of<myProvider>(context, listen: true).isFreelancer!? ListTile(
                          horizontalTitleGap: 2.0,
                          leading: const Icon(Icons.phone_android,color: Colors.black,),
                          trailing: const Icon(Icons.arrow_forward_ios,size: 18,color: Colors.black,),
                          title: const Text('Update phone number'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  updatePhoneNum(),
                              ),
                            );
                          },
                        ) : Container(),
                      ],
                    ),
                  ),
                ) : Container(),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
