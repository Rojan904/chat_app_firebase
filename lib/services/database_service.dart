import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

//reference for collection
//making collection users in our firestore database
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //updating Userdata
  //inserting data in our user table
  Future updateUserData(fullName, email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  Future getUserData(String email) async {
    //snapshot means getting the value from our collection
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  //get groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
  
//create group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId":
          groupDocumentReference.id, //assigning auto generated id to groupId
    });
    //adding groupId to the associated user.
    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

//for getting chat of associated group
  getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection(
            "messages") //this creates another collection inside the group collection
        .orderBy("time")
        .snapshots();
  }

  Future getAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }

  //get group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

  //search
  searchByName(groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  //check if user has joined certain group
  Future<bool> isUserJoined(String groupId, String groupName, userName) async {
    DocumentReference documentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    List<dynamic> group = await documentSnapshot['groups'];
    if (group.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  //toggle group join and exit
  Future toggleGroupJoin(String groupId, String groupName, userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference grpDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot userDocumentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await userDocumentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });

      await grpDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });

      await grpDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  //send message
  sendMessage(String groupId, Map<String, dynamic> message) async {
    groupCollection.doc(groupId).collection("messages").add(message);
    groupCollection.doc(groupId).update({
      "recentMessage": message['message'],
      "recentMessageSender": message['sender'],
      "recentMessageTime": message['time'].toString(),
    });
    
  }
}
