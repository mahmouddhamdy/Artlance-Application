import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gp/Models/ChatMessage.dart';
import 'package:gp/Screens/Messaging/chatMessage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../Provider/myProvider.dart';

class MessagingScreen extends StatefulWidget {
  final String id, name, type;
  List<dynamic> messages;
  static const routeName = 'MessagingScreen';

  MessagingScreen(
      {Key? key,
      required this.id,
      required this.name,
      required this.type,
      required this.messages})
      : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  TextEditingController textController = TextEditingController();
  final storage = const FlutterSecureStorage();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100000,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 100000,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // const CircleAvatar(
            //   backgroundImage: AssetImage(""),
            // ),
            const SizedBox(
              width: 15.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: 'OpenSans',
                  ),
                ),
                Text(
                  widget.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: getChats(),
        builder: (context, snapshot) {
          if (widget.messages == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      //print(widget.messages);
                      return chatMessage(
                        message: ChatMessage(
                          text: widget.messages[index]['content'],
                          isSender:
                              Provider.of<myProvider>(context, listen: false)
                                          .id! ==
                                      widget.messages[index]['from']
                                  ? true
                                  : false,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 32,
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Focus(
                                      child: TextField(
                                        controller: textController,
                                        decoration: const InputDecoration(
                                          hintText: "Type Message",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                      onFocusChange: (hasFocus) {
                                        if (!hasFocus) {
                                          getChats();
                                        }
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 15.0,
                              ),
                              IconButton(
                                onPressed: () async {
                                  await sendMessage();
                                  await getChats();
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent +
                                        100000,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.ease,
                                  );
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blueGrey,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  getChats() async {
    List <dynamic> newMessages = [];
    var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/${widget.id}');
    var token = await storage.read(key: 'token');

    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token!}",
      },
    );


    Map<dynamic,dynamic> responseList = jsonDecode(response.body);
    newMessages = responseList['messages'];
    setState(() {
      widget.messages =newMessages;
    });
  }

  sendMessage() async {
    if (!textController.text.isEmpty) {
      var url = Uri.parse('http://10.0.2.2:8080/api/v1/chat/message');
      var token = await storage.read(key: 'token');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer ${token!}",
        },
        body: jsonEncode(
          {
            'to': widget.id,
            'content': textController.text,
          },
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent + 100000,
              duration: const Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
            );
          }
        },
      );

      textController.clear();
    }
  }
}
