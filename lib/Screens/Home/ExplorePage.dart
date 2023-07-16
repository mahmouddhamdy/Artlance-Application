import 'dart:convert';
import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Screens/Home/ExplorePageTabs.dart';
import 'package:gp/Screens/Home/ImageSearchResults.dart';
import 'package:gp/Screens/Home/SearchResults.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Provider/myProvider.dart';
import 'SettingsPage.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ImagePicker picker = ImagePicker();
  File? pickedImage;
  TextEditingController searchController = TextEditingController();
  final storage = const FlutterSecureStorage();
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '788564269827684',
    apiSecret: 'qqCcksWCmccWU8Uq_00FHmqstFI',
    cloudName: 'dvd0x8c5z',
  );
  List<Map<String, dynamic>> imageResults = [];
  List<Map<String, dynamic>> searchResults = [];

  fetchImage() async {
    String type = '';
    String url = '';
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(25.0, 25.0, 25.0, 25.0),
      //position where you want to show the menu on screen
      items: [
        const PopupMenuItem<String>(
            value: '1', child: Text('Search for photographers')),
        const PopupMenuItem<String>(
            value: '2', child: Text('Search for Artists')),
        const PopupMenuItem<String>(
            value: '3', child: Text('Search for Graphic Designers')),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value == '1') {
        type = 'Photographer';
        final image = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
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
        }
      } else if (value == '2') {
        type = "Artist";
        final image = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
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
        }
      } else if (value == '3') {
        type = "Graphic Designer";
        final image = await picker.pickImage(
            source: ImageSource.gallery, imageQuality: 80);
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
        }
      }
      if (pickedImage != null) {
        if (!mounted) return;
        var snackBar1 = const SnackBar(
          content: Text('Image Fetched'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
        var snackBar2 = const SnackBar(
          content: Text('Searching... '),
          duration: Duration(seconds: 3),
        );
        Future.delayed(const Duration(seconds: 2)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        });
        final response = await cloudinary.upload(
            file: pickedImage!.path,
            fileBytes: pickedImage!.readAsBytesSync(),
            resourceType: CloudinaryResourceType.image,
            fileName:
                'SearchItem_${Provider.of<myProvider>(context, listen: false).portfolioItemIndex}');

        if (response.isSuccessful) {
          Provider.of<myProvider>(context, listen: false)
              .incrementSearchIndex();
          url = response.secureUrl!;
          sendImageToServer(url, type);
        }
      }
    });
  }

  sendImageToServer(String ImageURL, String type) async {
    var parameter = {
      'url': ImageURL,
      'type': type,
    };
    var address =
        Uri.http("10.0.2.2:8080", 'api/v1/clients/search/images', parameter);
    var token = await storage.read(key: 'token');
    var response = await http.get(
      address,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    if (response.statusCode == 200) {
      imageResults = [];
      List<dynamic> responseList = jsonDecode(response.body);

      for (var obj in responseList) {
        imageResults.add(Map<String, dynamic>.from(obj));
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => imageSearchResults(results: imageResults)),
      );
    }
  }

  submitSearch() async {
    var parameter = {
      'query': searchController.text,
    };
    var url = Uri.http(
        "10.0.2.2:8080", 'api/v1/clients/search/freelancers', parameter);

    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    searchResults = [];
    var jsonResponse = await jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      var name, type,username;
      name = await getNameByID(jsonResponse[i]);
      type = await getTypeByID(jsonResponse[i]);
      username = await getUsernameByID(jsonResponse[i]);
      searchResults.add(
        {
          'id': '${jsonResponse[i]}',
          'name': name,
          'type': type,
          'username': username

        },
      );
    }
  }

  getUsernameByID(String id) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/freelancers/$id');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var username = await jsonResponse['username'];
    return username;
  }


  getNameByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/$id");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var name = await jsonResponse['fullName'];
    return name;
  }

  getTypeByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/freelancers/$id");
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    var jsonResponse = await jsonDecode(response.body);
    var type = await jsonResponse['freelancerType'];
    return type;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 75,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    padding: const EdgeInsets.all(10.0),
                    placeholder: 'Search..',
                    suffixMode: OverlayVisibilityMode.always,
                    suffixIcon: const Icon(Icons.camera_enhance_outlined),
                    onSuffixTap: () {
                      fetchImage();
                    },
                    itemColor: Colors.black,
                    onSubmitted: (str) async {
                      submitSearch();
                      Future.delayed(const Duration(seconds: 2)).then(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResults(searchResults: searchResults),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 5.0),
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsPage.routeName);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Expanded(child: ExplorePageTabs()),
        ],
      ),
    );
  }
}
