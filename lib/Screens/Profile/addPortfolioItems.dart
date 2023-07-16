import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Provider/myProvider.dart';

class addPortfolioItems extends StatefulWidget {
  static const routeName = 'EditProfilePicture';

  const addPortfolioItems({Key? key}) : super(key: key);

  @override
  State<addPortfolioItems> createState() => _addPortfolioItemsState();
}

class _addPortfolioItemsState extends State<addPortfolioItems> {
  final ImagePicker picker = ImagePicker();
  final storage = const FlutterSecureStorage();

  File? pickedImage;
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '788564269827684',
    apiSecret: 'qqCcksWCmccWU8Uq_00FHmqstFI',
    cloudName: 'dvd0x8c5z',
  );
  List<String>? urls;

  fetchImage() async {
    List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    for (int i = 0; i < images.length; i++) {
      var img = File(images[i].path);
      var size = await (img.length());
      if (size > 2000000) {
        if (!mounted) return;
        var snackBar = const SnackBar(
          content:
              Text('File too big! Please choose an image smaller than 2MBs '),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        var pickedImage = File(images[i].path);
        await ImageToUrl(pickedImage);
        if (!mounted) return;
        var snackBar = const SnackBar(
          content: Text('Image Uploaded!'),
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } );

      }
    }
  }

  ImageToUrl(File? img) async {
    String ImageUrl;
    String filename= 'PortfolioItem_${Provider.of<myProvider>(context, listen: false).id}_${Provider.of<myProvider>(context, listen: false).portfolioItemIndex}';
    print(filename);
    final response = await cloudinary.upload(
        file: img!.path,
        fileBytes: img.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        fileName: filename);



    Provider.of<myProvider>(context, listen: false).incrementIndex();
    if (response.isSuccessful) {
      ImageUrl = response.secureUrl!;
      urls?.add(ImageUrl);
      uploadImage(ImageUrl);
    }
  }

  uploadImage(String imageUrl) async {
    print(imageUrl);
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/portfolio/');
    var token = await storage.read(key: 'token');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
      body: jsonEncode(
        {
          'url': imageUrl,
        },
      ),
    );
    // print(response.statusCode);
    // print(response.body);
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
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                const CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png')),
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
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Upload portfolio images..",
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
