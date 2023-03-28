import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/chat.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnap;
  bool hasUserSearched = false;
  bool isJoined = false;
  String? userName;
  User? user;
  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  getCurrentUserInfo() async {
    await HelperFunctions.getUserNameKey().then((value) {
      setState(() {
        userName = value;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(children: [
        Container(
          color: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Groups..",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
              )),
              InkWell(
                onTap: () {
                  initiateSearch();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : groupList()
      ]),
    );
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((snap) {
        setState(() {
          searchSnap = snap;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnap!.docs.length,
            itemBuilder: (ctx, index) {
              return groupTile(
                userName,
                searchSnap!.docs[index]['groupId'],
                searchSnap!.docs[index]['groupName'],
                searchSnap!.docs[index]['admin'],
              );
            })
        : Container();
  }

  joinedOrNot(userName, groupId, groupName, admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupId, groupName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  groupTile(userName, groupId, String groupName, admin) {
    //func to check if user already exist in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Admin:${HelperFunctions.getName(admin)}"),
        trailing: InkWell(
            onTap: () async {
              await DatabaseService(uid: user!.uid)
                  .toggleGroupJoin(groupId, groupName, userName);
              if (isJoined) {
                setState(() {
                  isJoined = !isJoined;
                });
                if (context.mounted) {
                  showSnackbar(
                      context, Colors.green, "Succesfully joine the group");
                  Future.delayed(const Duration(seconds: 2), () {
                    nextScreen(
                        context,
                        ChatPage(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName));
                  });
                } else {
                  setState(() {
                    isJoined = !isJoined;
                  });
                  if (context.mounted) {
                    showSnackbar(context, Colors.red, "Left the group");
                  }
                }
              }
            },
            child: isJoined
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        border: Border.all(color: Colors.white, width: 1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Joined",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Colors.white, width: 1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Join Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
  }
}
