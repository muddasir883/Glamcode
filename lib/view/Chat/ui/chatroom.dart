import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'model/messageModel.dart';

class ChatRoom extends StatefulWidget {
  final String bookingId;
  final String userId;
  final String beauticianId;
  final String beauticianName;

  const ChatRoom({super.key, required this.bookingId, required this.userId, required this.beauticianId, required this.beauticianName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  var uuid = Uuid();

  void sendMessage(String lat, String long) async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty || (lat.isNotEmpty && long.isNotEmpty)) {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userId,  // Sender is user
        createdOn: DateTime.now(),
        text: msg,
        lat: lat,
        long: long,
        seen: false,
      );

      String chatroomId = "${widget.userId}_${widget.bookingId}";  // Unique chatroom ID

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomId)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: NetworkImage("widget.beauticianId"),  // Display beautician's profile pic
            ),
            const SizedBox(width: 10),
            Text(widget.beauticianName),  // Display beautician's name
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc("${widget.userId}_${widget.bookingId}")
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        reverse: true,
                        itemCount: datasnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(
                              datasnapshot.docs[index].data() as Map<String, dynamic>);
                          return Row(
                            mainAxisAlignment: (currentMessage.sender == widget.userId)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (currentMessage.sender == widget.userId)
                                        ? Colors.pink
                                        : Colors.blue,
                                  ),
                                  child: currentMessage.lat!.isNotEmpty && currentMessage.long!.isNotEmpty
                                      ? SizedBox(
                                    height: 90,
                                    width: 150,
                                    child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 50),
                                          InkWell(
                                            onTap: () {},
                                            child: const Text(
                                              "View Location",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color.fromARGB(255, 123, 45, 218)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      : Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.black),
                                    maxLines: null,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No messages found."));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      sendMessage("26.8467° N", "80.9462° E");  // Example coordinates
                    },
                    icon: const Icon(Icons.location_searching, color: Colors.pink),
                  ),
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: "Enter message"),
                    ),
                  ),
                  IconButton(
                    onPressed: () => sendMessage("", ""),
                    icon: const Icon(Icons.send, color: Colors.pink),
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
