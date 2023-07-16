import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Provider/myProvider.dart';
import 'package:gp/Screens/Home/SettingsPage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Messaging/MessagingScreen.dart';

class historyPage extends StatefulWidget {
  static const routeName = 'History';

  const historyPage({Key? key}) : super(key: key);

  @override
  State<historyPage> createState() => _historyPageState();
}

class _historyPageState extends State<historyPage> {
  List<Map<String, dynamic>> chatters = [];
  bool? isEmpty;

  final storage = const FlutterSecureStorage();

  fetchData(BuildContext ctx) async {
    chatters = [];
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/');
    var token = await storage.read(key: 'token');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );

    var jsonResponse = await jsonDecode(response.body);
    for (int i = 0; i < jsonResponse.length; i++) {
      var name, type, messages;
      name = Provider.of<myProvider>(ctx, listen: false).isFreelancer!
          ? await getClientNameByID(jsonResponse[i])
          : await getFreelancerNameByID(jsonResponse[i]);

      type = Provider.of<myProvider>(ctx, listen: false).isFreelancer!
          ? 'Client'
          : await getTypeByID(jsonResponse[i]);
      messages = await getChats(jsonResponse[i]);
      chatters.add(
        {
          'id': '${jsonResponse[i]}',
          'name': name,
          'type': type,
          'messages': messages,
        },
      );
    }
  }

  getFreelancerNameByID(String id) async {
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

  getClientNameByID(String id) async {
    var url = Uri.parse("http://10.0.2.2:8080/api/v1/clients/$id");
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

  getChats(String id) async {
    List<dynamic> messages = [];
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/$id');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );

    Map<dynamic, dynamic> responseList = jsonDecode(response.body);
    messages = responseList['messages'];
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    chatters = [];
    return FutureBuilder(
        future: fetchData(context),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              shadowColor: Colors.blueGrey.withOpacity(0),
              backgroundColor: Colors.black.withOpacity(0.05),
              leading: const BackButton(color: Colors.black),
              title: Row(
                children: [
                  const Text(
                    "Chat History",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width) - 240,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).pushNamed(SettingsPage.routeName);
                    },
                  ),
                ],
              ),
            ),
            body: chatters.isEmpty
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/EmptyList.png'),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "No previous chats found",
                          style: TextStyle(
                              fontFamily: 'Schyler',
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 25,
                              letterSpacing: 0.2),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: chatters.length,
                    itemBuilder: (context, index) {
                      return inkwellBuilder(
                          chatters[index]['name'],
                          chatters[index]['id'],
                          chatters[index]['messages'],
                          chatters[index]['type'],
                          context);
                    },
                  ),
          );
        });
  }

  inkwellBuilder(String name, String id, List<dynamic> messages, String type,
      BuildContext ctx) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessagingScreen(
              messages: messages,
              id: id,
              name: name,
              type: type,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 20.0 * 0.75),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagingScreen(
                          messages: messages,
                          id: id,
                          name: name,
                          type: type,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.messenger_outlined,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Divider(
              color: Colors.grey.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }
}
