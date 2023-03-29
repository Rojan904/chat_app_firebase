import 'package:chat_app/bloc_switch/presentation/chat/bloc/chat_bloc.dart';
import 'package:chat_app/bloc_switch/presentation/group_info/group_info_page.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage2 extends StatefulWidget {
  const ChatPage2(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});
  final String groupId, groupName, userName;

  @override
  State<ChatPage2> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage2> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
    context.read<ChatBloc>().add(GetChats(widget.groupId));
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
                    GroupInfoPage(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          print(state);
          if (state is ChatError) {
            print("object");
          }
          return Stack(children: [
            chatMessages(),
            state is ChatError
                ? Center(
                    child: Text(
                      state.error,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                : Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
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
          ]);
        },
      ),
    );
  }

  chatMessages() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          return StreamBuilder(
              stream: state.data,
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
        } else if (state is ChatError) {
          return Text(state.error.toString());
        } else {
          return Container();
        }
      },
    );
  }

  sendMessage() {
    context.read<ChatBloc>().add(SendMessageEvent(
        messageController.text, widget.userName, widget.groupId));
    setState(() {
      messageController.clear();
    });
  }
}
