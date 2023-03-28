import 'package:chat_app/bloc_switch/presentation/search/bloc/search_bloc.dart';
import 'package:chat_app/bloc_switch/presentation/search/group_tile_component.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage2 extends StatefulWidget {
  const SearchPage2({super.key});

  @override
  State<SearchPage2> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage2> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnap;
  bool hasUserSearched = false;
  bool isJoined = false;
  String? userName;
  late User user;
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

  }

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;

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
      context
          .read<SearchBloc>()
          .add(GetSearchEvent(keyword: searchController.text));
    }
  }

  groupList() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoaing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchError) {
          return const Text("No data");
        } else if (state is SearchSuccess) {
          if (state.searchSnapshot.docs.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: state.searchSnapshot.docs.length,
                itemBuilder: (ctx, index) {
                  return BlocProvider(
                    create: (context) => SearchBloc()
                      ..add(HasJoinedEvent(
                        userId: "i1hImninQqPE7IjoSc4T46hi69F2",
                        groupId: state.searchSnapshot.docs[index]['groupId'],
                        groupName: state.searchSnapshot.docs[index]
                            ['groupName'],
                      )),
                    child: GroupTileComponent(
                        userName: userName ?? "",
                        groupId: state.searchSnapshot.docs[index]['groupId'],
                        groupName: state.searchSnapshot.docs[index]
                            ['groupName'],
                        admin: state.searchSnapshot.docs[index]['admin'],
                        userId: user.uid),
                  );
                });
          } else {
            return const Text("Sorry no results");
          }
        }
        return Container();
      },
    );
  }

  
}
