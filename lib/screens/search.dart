import 'package:chat2/helper/constants.dart';
import 'package:chat2/screens/conversation_screen.dart';
import 'package:chat2/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  DatabaseMethodes databaseMethodes = DatabaseMethodes();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

// Create chat room && send user to conversation
  creatChatUserAndStartConversation({String userName}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      List<String> _users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': _users,
        'chatroomId': chatRoomId,
      };
      DatabaseMethodes().creatChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print('You can\'t send messages to your self');
      Fluttertoast.showToast(
          msg: 'You can\'t send messages to your self :)',
          backgroundColor: Colors.white,
          textColor: Colors.green);
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(left: 16, top: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: $userName',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 17,
                        ),
                      ),
                      // Text(
                      //   userEmail,
                      // style: TextStyle(
                      //   color: Colors.blue,
                      //   fontSize: 16,
                      //   decoration: TextDecoration.underline,
                      // ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: userEmail));
                          Fluttertoast.showToast(
                              msg: 'Copied',
                              backgroundColor: Colors.white,
                              textColor: Colors.green);
                        },
                        child: Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            creatChatUserAndStartConversation(userName: userName);
          },
          child: Container(
            margin: EdgeInsets.only(right: 16, top: 10),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Message',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  QuerySnapshot searchSnapshot;

  void initialSearch() {
    databaseMethodes.getUserByUserName(_searchController.text).then((value) {
      setState(() {
        searchSnapshot = value;
        _searchController.text = '';
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].data()["name"],
                userEmail: searchSnapshot.docs[index].data()["email"],
              );
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFDEE7F6),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4.0, 4.0),
                      blurRadius: 15,
                      spreadRadius: 1),
                  BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 8,
                      spreadRadius: 1),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search username...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0x36FFFFFF),
                          const Color(0x0FFFFFFF),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        initialSearch();
                      },
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
