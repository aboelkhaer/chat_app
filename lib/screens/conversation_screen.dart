import 'package:chat2/helper/constants.dart';
import 'package:chat2/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(
    this.chatRoomId,
  );
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController _messageController = TextEditingController();
  DatabaseMethodes _databaseMethodes = DatabaseMethodes();

  Stream chatMessageStream;

  @override
  void initState() {
    _databaseMethodes.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  DatabaseMethodes databaseMethodes = DatabaseMethodes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text('Chatting Room'),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: [
            _chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[700],
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _sendMessage();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.documents[index];
                  return MessageTile(
                      data['message'], data['sendBy'] == Constants.myName);
                },
              );
      },
    );
  }

  _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': _messageController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      _databaseMethodes.addConversationMessages(widget.chatRoomId, messageMap);
      _messageController.text = '';
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(
        vertical: 8,
      ),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe
                  ? [
                      const Color(0xFF007EF4),
                      const Color(0xFF2A75BC),
                    ]
                  : [
                      const Color(0xFF6a6b6c),
                      const Color(0xFFa4a7ab),
                    ]),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
