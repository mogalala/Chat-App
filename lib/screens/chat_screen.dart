import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser ;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try{
      final user = _auth.currentUser;
      if(user != null){
        signedInUser = user;
        print(signedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }

  // void getMessages()async{
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs){
  //     print(message.data());
  //   }
  // }

  // void messagesStreams()async{
  //   await for(var snapshpt in _firestore.collection('messages').snapshots()){
  //     for (var message in snapshpt.docs){
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/chat_icon.jpeg',),
              radius: 20,
            ),
            SizedBox(width: 10),
            Text('MessageMe',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: (){
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MessageStreamBuilder(),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.orange ,width: 2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageTextController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                            hintText: 'Write your message here...',
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            messageText = value;
                          },
                        ),
                    ),
                    TextButton(
                        onPressed: (){
                          messageTextController.clear();
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': signedInUser.email,
                            'time': FieldValue.serverTimestamp(),
                          });
                        },
                        child: Text('Send',
                          style: TextStyle(color: Colors.blue[800], fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshots){
        List<MessageLine> messageWidgets = [];
        if(!snapshots.hasData){
          return const Center(
            child: CircularProgressIndicator(backgroundColor: Colors.blue,),
          );
        }
        final messages = snapshots.data!.docs.reversed;
        for(var message in messages){
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentuser = signedInUser.email;

          final messageWidget = MessageLine(
            text: messageText,
            sender: messageSender,
            isMe: currentuser == messageSender ,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


class MessageLine extends StatelessWidget {
  const MessageLine({Key? key, this.text, this.sender, required this.isMe}) : super(key: key);
  final String? text;
  final String? sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender',
            style: TextStyle(fontSize: 13,color: Colors.yellow[900]),
          ),
          Material(
            borderRadius: isMe ? const BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ) : const BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            color: isMe ? Colors.blue[800] : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
              child: Text('$text',
                style: TextStyle(fontSize: 15,color: isMe ? Colors.white : Colors.black45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

