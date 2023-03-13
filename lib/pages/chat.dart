import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});
  final String groupId, groupName, userName;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(children: [
        chatMessages(),
        Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
            color: Colors.grey[700],
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                controller: messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    hintText: "Send a message",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none),
              )),
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  sendMessage();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                      child: Icon(
                    Icons.send,
                    color: Colors.white,
                  )),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (ctx, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                });
          } else {
            return Container();
          }
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
