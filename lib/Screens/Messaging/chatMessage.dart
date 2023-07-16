import 'package:flutter/material.dart';
import 'package:gp/Models/ChatMessage.dart';

class chatMessage extends StatelessWidget {
  const chatMessage({Key? key, required this.message}) : super(key: key);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isSender)
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(""),
            ),
          ),
        TextMessage(),
      ],
    );
  }

  Container TextMessage() {
    return Container(
        constraints: const BoxConstraints(
          maxWidth: 200,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: message.isSender
              ? Colors.blueGrey
              : Colors.blueGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isSender ? Colors.white : Colors.black,
            overflow: TextOverflow.visible,
            fontFamily: 'OpenSans',
            fontSize: 14,
          ),
        ),
      );
  }
}
