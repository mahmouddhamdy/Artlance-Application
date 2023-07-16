import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editProfilePicture extends StatefulWidget {
  static const routeName = 'EditProfilePicture';

  const editProfilePicture({Key? key}) : super(key: key);

  @override
  State<editProfilePicture> createState() => _editProfilePictureState();
}

class _editProfilePictureState extends State<editProfilePicture> {
  final ImagePicker picker = ImagePicker();
  File? pickedImage;

  fetchImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(image!.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.blueGrey.withOpacity(0),
        backgroundColor: Colors.blueGrey.withOpacity(0),
        leading: const BackButton(color: Colors.black),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Stack(
              children: [
                CircleAvatar(
                  radius: 120,
                  backgroundImage: pickedImage == null? const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png') : FileImage(pickedImage!) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30.0),

                    ),
                    child: IconButton(
                      onPressed: fetchImage,
                      icon: const Icon(Icons.add,color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Text(
              "Select your profile photo",
              style: TextStyle(
                  fontFamily: 'Schyler',
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 25,
                  letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}
