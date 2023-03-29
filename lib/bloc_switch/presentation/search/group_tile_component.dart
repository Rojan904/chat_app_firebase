// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../helper/helper_function.dart';
// import '../../../pages/chat.dart';
// import '../../../widgets/widgets.dart';
// import 'bloc/search_bloc.dart';

// class GroupTileComponent extends StatelessWidget {
//   const GroupTileComponent(
//       {super.key,
//       required this.userName,
//       required this.groupId,
//       required this.groupName,
//       required this.admin,
//       required this.userId});
//   final String userName, groupId, groupName, admin, userId;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         BlocConsumer<SearchBloc, SearchState>(
//           listener: (context, state) {
//             print(state);
//             if (state is ButtonToggled && state is HasJoined) {
//               if (context.mounted) {
//                 showSnackbar(
//                     context, Colors.green, "Succesfully joine the group");
//                 Future.delayed(const Duration(seconds: 2), () {
//                   nextScreen(
//                       context,
//                       ChatPage(
//                           groupId: groupId,
//                           groupName: groupName,
//                           userName: userName));
//                 });
//               }
//             } else if (state is HasNotJoined) {
//               if (context.mounted) {
//                 showSnackbar(context, Colors.red, "Left the group");
//               }
//             }
//           },
//           builder: (context, state) {
//             return ListTile(
//               contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               leading: CircleAvatar(
//                 radius: 30,
//                 backgroundColor: Theme.of(context).primaryColor,
//                 child: Text(
//                   groupName.substring(0, 1).toUpperCase(),
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               title: Text(
//                 groupName,
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//               subtitle: Text("Admin:${HelperFunctions.getName(admin)}"),
//               trailing: InkWell(
//                   onTap: () async {
//                     context.read<SearchBloc>().add(ToggleJoinEvent(
//                         userId: userId,
//                         groupId: groupId,
//                         groupName: groupName,
//                         userName: userName));
//                     print(state);
//                   },
//                   child: state is HasJoined
//                       ? Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.black,
//                               border:
//                                   Border.all(color: Colors.white, width: 1)),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: const Text(
//                             "Joined",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         )
//                       : Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Theme.of(context).primaryColor,
//                               border:
//                                   Border.all(color: Colors.white, width: 1)),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: const Text(
//                             "Join Now",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         )),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

import 'package:chat_app/bloc_switch/presentation/chat/page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helper/helper_function.dart';
import '../../../pages/chat.dart';
import '../../../widgets/widgets.dart';
import 'bloc/search_bloc.dart';

class GroupTileComponent extends StatelessWidget {
  const GroupTileComponent(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName,
      required this.admin,
      required this.userId});
  final String userName, groupId, groupName, admin, userId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is HasJoined) {
              if (state.isToggled == true) {
                if (context.mounted) {
                  showSnackbar(
                      context, Colors.green, "Succesfully joine the group");
                  Future.delayed(const Duration(seconds: 2), () {
                    nextScreen(
                        context,
                        ChatPage2(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName));
                  });
                }
              }
            } else if (state is HasNotJoined) {
              if (state.isToggled == true) {
                showSnackbar(context, Colors.red, "Left the group");
              }
            }
          },
          builder: (context, state) {
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  groupName.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                groupName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text("Admin:${HelperFunctions.getName(admin)}"),
              trailing: InkWell(
                  onTap: () async {
                    context.read<SearchBloc>().add(ToggleJoinEvent(
                        isToggled: true,
                        userId: userId,
                        groupId: groupId,
                        groupName: groupName,
                        userName: userName));
                    // if (state is HasJoined) {
                    //   context.read<SearchBloc>().add(ToggleJoinEvent(
                    //       userId: userId,
                    //       groupId: groupId,
                    //       groupName: groupName,
                    //       userName: userName));
                    //   // context.read<SearchCubit>().toggleJoin(
                    //   //     false, userId, userName, groupId, groupName);
                    // } else if (state is HasNotJoined) {
                    //   context.read<SearchBloc>().add(ToggleJoinEvent(
                    //       userId: userId,
                    //       groupId: groupId,
                    //       groupName: groupName,
                    //       userName: userName));
                    //   // context.read<SearchCubit>().toggleJoin(
                    //   //     true, userId, userName, groupId, groupName);
                    // }
                  },
                  child: state is HasJoined
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                              border:
                                  Border.all(color: Colors.white, width: 1)),
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
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: const Text(
                            "Join Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
            );
          },
        ),
      ],
    );
  }
}
