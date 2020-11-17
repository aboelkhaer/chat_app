import 'package:chat2/helper/authenticate.dart';
import 'package:chat2/helper/constants.dart';
import 'package:chat2/helper/helper_functions.dart';
import 'package:chat2/screens/conversation_screen.dart';
import 'package:chat2/screens/search.dart';
import 'package:chat2/services/auth.dart';
import 'package:chat2/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChateRome extends StatefulWidget {
  @override
  _ChateRomeState createState() => _ChateRomeState();
}

class _ChateRomeState extends State<ChateRome> {
  final AuthMethods authMethods = AuthMethods();
  DatabaseMethodes _databaseMethodes = DatabaseMethodes();
  Stream chatRoomsStream;

  @override
  void initState() {
    _getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text('My Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Fluttertoast.showToast(
                  msg: '  Soon  ',
                  backgroundColor: Colors.white,
                  textColor: Colors.black);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[700],
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      // body: _chatRoomsList(),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: ExactAssetImage('assets/images/logo2.png'),
                ),
              ),
            ),
          ),
          _chatRoomsList()
        ],
      ),
    );
  }

  _getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    _databaseMethodes.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  Widget _chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot != null
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.documents[index];
                  return ChatRoomsTile(
                      data['chatroomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(Constants.myName, ''),
                      data['chatroomId']);
                },
              )
            : Container();
      },
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    userName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  userName,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.grey[700];
                    return Color(0xFFed0000);
                  },
                ),
              ),
              onPressed: () {
                yYNoticeDialog(context);
              },
              child: Container(
                child: Text('Remove'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  YYDialog yYNoticeDialog(context) {
    return YYDialog().build(context)
      ..width = MediaQuery.of(context).size.width * 0.80
      // ..height = MediaQuery.of(context).size.height * 0.45
      ..widget(
        Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Color(0xFFed0000),
                      ),
                      Text(
                        'Delete this room, sure?',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(''),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      height: 40,
                      color: Colors.grey[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        'Cancle',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    FlatButton(
                      height: 40,
                      color: Color(0xFFed0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: '  Soon  ',
                            backgroundColor: Colors.white,
                            textColor: Colors.black);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
      ..show();
  }
}
