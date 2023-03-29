import 'package:chat_app/bloc_switch/presentation/group_info/bloc/group_info_bloc.dart';
import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});
  final String groupId, groupName, adminName;

  @override
  State<GroupInfoPage> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfoPage> {
  @override
  void initState() {
    super.initState();
    getMembers();
  }

  getMembers() async {
    context.read<GroupInfoBloc>().add(GetMembersEvent(groupId: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Group Info"),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Leave"),
                          content:
                              const Text("Are you sure you want to leave?"),
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
                            BlocListener<GroupInfoBloc, GroupInfoState>(
                              listener: (context, state) {
                                if (state is LeaveGroupSuccess) {
                                  showSnackbar(context, Colors.green,
                                      "Left group successfully.");
                                  nextScreenReplace(context, const HomePage());
                                } else {
                                  showSnackbar(context, Colors.green,
                                      "Error while leaving group.");
                                }
                              },
                              child: IconButton(
                                onPressed: () async {
                                  context.read<GroupInfoBloc>().add(
                                      LeaveGroupEvent(widget.groupId,
                                          widget.groupName, widget.adminName));
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.exit_to_app))
          ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).primaryColor.withOpacity(0.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Admin: ${HelperFunctions.getName(widget.adminName)}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return BlocBuilder<GroupInfoBloc, GroupInfoState>(
      builder: (context, state) {
        if (state is GroupInfoLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else if (state is GroupInfoLoaded) {
          return StreamBuilder(
              stream: state.members,
              builder: (ctx, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['members'] != null) {
                    if (snapshot.data['members'].length != 0) {
                      return ListView.builder(
                          itemCount: snapshot.data['members'].length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    HelperFunctions.getName(
                                            snapshot.data['members'][index])
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  HelperFunctions.getName(
                                      snapshot.data['members'][index]),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  HelperFunctions.getId(
                                      snapshot.data['members'][index]),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(child: Text("No members"));
                    }
                  } else {
                    return const Center(child: Text("No members"));
                  }
                } else {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
              });
        } else {
          return Container();
        }
      },
    );
  }
}
