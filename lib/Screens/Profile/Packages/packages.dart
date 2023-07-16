import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gp/Screens/Profile/Packages/addPackage.dart';
import 'package:gp/Screens/Profile/Packages/requestPackage.dart';
import 'package:gp/Screens/Profile/Packages/updatePackage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../Provider/myProvider.dart';
import 'package:http/http.dart' as http;

class packages extends StatefulWidget {
  final String? id;
  final bool? myProfile;

  const packages({Key? key, this.id, this.myProfile}) : super(key: key);

  @override
  State<packages> createState() => _packagesState();
}

class _packagesState extends State<packages> {
  final storage = const FlutterSecureStorage();
  List<Map<String, dynamic>> packageList = [];

  fetchPackages() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/packages/${widget.id}');
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    packageList = [];
    List<dynamic> responseList = jsonDecode(response.body);

    for (var obj in responseList) {
      packageList.add(Map<String, dynamic>.from(obj));
    }
    print(packageList);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.blueGrey.withOpacity(0),
          backgroundColor: Colors.blueGrey.withOpacity(0),
          leading: const BackButton(color: Colors.black),
          title: widget.myProfile!
              ? Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => addPackage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Add package",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        body: FutureBuilder(
            future: fetchPackages(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: packageList.length,
                itemBuilder: (context, index) => packageBuilder(
                    index,
                    packageList[index]['_id'],
                    packageList[index]['description'],
                    packageList[index]['photosNum'],
                    packageList[index]['price']),
              );
            }),
      ),
    );
  }

  packageBuilder(int index, String packageID, String description, int photosNum,
      int price) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      color: Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: widget.myProfile!
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              widget.myProfile!
                  ? IconButton(
                      onPressed: () async {
                        deletePackage(packageID);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  : Container(),
              widget.myProfile!
                  ? IconButton(
                      onPressed: () async{
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => updatePackage(id: packageID,description: description,photosNum: photosNum,price: price,),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    )
                  : Container(),
            ],
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
            leadingAndTrailingTextStyle: const TextStyle(
                color: Colors.black, fontSize: 20, letterSpacing: 0.2),
            subtitle: Text(
              '$description \n $photosNum Photos',
              style: const TextStyle(
                  color: Colors.black, fontSize: 18, letterSpacing: 0.2),
            ),
            trailing: Text('$price EGP'),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  deletePackage(String packageID) async {
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/packages/$packageID');
    var token = await storage.read(key: 'token');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );
    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Package Deleted!'),
        duration: Duration(seconds: 1),
      );
      Future.delayed(const Duration(seconds: 1)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      setState(() {});
    }
  }
}
