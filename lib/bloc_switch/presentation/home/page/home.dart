import 'package:chat_app/bloc_switch/presentation/search/search_page.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/profile.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/login/bloc/pages/login_page.dart';
import '../../../core/network/cubit/internet_cubit.dart';
import '../bloc/home_bloc.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage2> {
  String userName = "";
  String email = "";
  late TextEditingController groupName;
  Stream? groups;
  AuthService authService = AuthService();
  bool isLoading = false;
  @override
  void initState() {
    groupName = TextEditingController();
    getUserData();
    super.initState();
  }

  getUserData() async {
    await HelperFunctions.getUserNameKey().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await HelperFunctions.getUserEmailKey().then((value) {
      setState(() {
        email = value!;
      });
    });
    // await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    //     .getUserGroups()
    //     .then((snapshot) {
    //   setState(() {
    //     groups = snapshot;
    //   });
    // });
  }

  @override
  void dispose() {
    groupName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiBloc = BlocProvider.of<ApiBloc>(context);

    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetDisconnected) {
          showSnackbar(context, Colors.red, "No Internet");
        }
      },
      child: BlocProvider(
        create: (context) => ApiBloc()..add(GetUserGroupsEvents()),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    nextScreen(context, const SearchPage2());
                  },
                  icon: const Icon(Icons.search))
            ],
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              "Groups",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 150,
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  userName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 2,
                ),
                ListTile(
                  onTap: () {},
                  selectedColor: Theme.of(context).primaryColor,
                  selected: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Groups",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(
                        context,
                        ProfilePage(
                          userName: userName,
                          email: email,
                        ));
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.group),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  if (context.mounted) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage2()),
                                        (route) => false);
                                  }
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          body: groupList(),
          floatingActionButton: BlocListener<ApiBloc, ApiState>(
              bloc: apiBloc,
              listener: (newCtx, state) {
                if (state.status == ApiStatus.failue) {
                  showSnackbar(newCtx, Colors.red, state.error);
                } else if (state.status == ApiStatus.loading) {
                  const CircularProgressIndicator();
                } else if (state.status == ApiStatus.success) {
                  Navigator.of(context).pop();

                  showSnackbar(
                      context, Colors.green, "Group created successfully.");
                }
              },
              child: FloatingActionButton(
                onPressed: () {
                  popUpDialog(context);
                },
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              )),
        ),
      ),
    );
  }

  popUpDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: groupName,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                      errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("CANCEL"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName.text != "") {
                    BlocProvider.of<ApiBloc>(context).add(CreateGroupEvents(
                        groupName: groupName.text, userName: userName));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text("CREATE"),
              )
            ],
          );
        });
  }

  groupList() {
    return BlocBuilder<ApiBloc, ApiState>(
      builder: (context, state) {
        if (state.status == ApiStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        } else if (state.status == ApiStatus.success) {
          return StreamBuilder(
              stream: state.data,
              builder: (_, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['groups'] != null) {
                    if (snapshot.data['groups'].length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data['groups'].length,
                        itemBuilder: (ctx, index) {
                          int reverseIndex =
                              snapshot.data['groups'].length - index - 1;
                          return GroupTile(
                              userName: snapshot.data['fullName'],
                              groupId: HelperFunctions.getId(
                                  snapshot.data['groups'][reverseIndex]),
                              groupName: HelperFunctions.getName(
                                  snapshot.data['groups'][reverseIndex]));
                        },
                      );
                    } else {
                      return noGroup();
                    }
                  } else {
                    return noGroup();
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        } else {
          return noGroup();
        }
      },
    );
  }

  noGroup() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
          onTap: () {
            popUpDialog(context);
          },
          child: const Icon(
            Icons.add_circle,
            color: Colors.green,
            size: 75,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
