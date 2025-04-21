import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chat1 extends StatefulWidget {
  const Chat1({super.key});
  @override
  State<Chat1> createState() => _Chat1State();
}

class _Chat1State extends State<Chat1> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Admin details
  final String adminEmail = "admin@gmail.com";
  final String adminName = "Admin";

  // User details
  String? currentUserEmail;
  String? userName;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchUserData();
    _loadMessages();
  }

  void _getCurrentUser() {
    currentUserEmail = _auth.currentUser?.email;
  }

  Future<void> _fetchUserData() async {
    if (_auth.currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection("UserRegress")
            .doc(_auth.currentUser!.email)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          setState(() {
            userName = userData['name'];
            userPhone = userData['phoneNumber'];
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  Future<void> _loadMessages() async {
    if (currentUserEmail != null) {
      try {
        QuerySnapshot chatSnapshot = await _firestore
            .collection("Indi_Chat")
            .doc(currentUserEmail)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .get();

        setState(() {
          _messages.clear();
          for (var doc in chatSnapshot.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            _messages.add({
              "type": data["type"],
              "content": data["content"],
              "isAdmin": data["isAdmin"],
              "timestamp": data["timestamp"]
            });
          }
        });
      } catch (e) {
        print("Error loading messages: $e");
      }
    }
    print("AAA$_messages");
  }

  Future<void> _sendNotificationToAdmin(String message) async {
    try {
      // Fetch admin tokens from Firestore
      DocumentSnapshot adminDoc =
          await _firestore.collection("Admin").doc("admin@gmail.com").get();

      if (!adminDoc.exists) {
        print("Admin document not found");
        return;
      }

      Map<String, dynamic> adminData = adminDoc.data() as Map<String, dynamic>;

      // Check if token field exists and is a list
      if (!adminData.containsKey('token') || adminData['token'] == null) {
        print("Admin tokens not found");
        return;
      }

      List<dynamic> adminTokens = [];

      // Handle both single token (string) and multiple tokens (list)
      if (adminData['token'] is String) {
        adminTokens.add(adminData['token']);
      } else if (adminData['token'] is List) {
        adminTokens = adminData['token'];
      }

      if (adminTokens.isEmpty) {
        print("No admin tokens available");
        return;
      }

      // FCM server endpoint
      const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

      // Your FCM server key - should be stored securely in production
      const String serverKey =
          'YOUR_FCM_SERVER_KEY'; // Replace with actual server key

      // For each admin token, send a notification
      for (String token in adminTokens) {
        if (token == null || token.isEmpty) continue;

        // Notification payload
        Map<String, dynamic> notification = {
          'notification': {
            'title': 'New message from ${userName ?? currentUserEmail}',
            'body': message.length > 100
                ? '${message.substring(0, 97)}...'
                : message,
            'sound': 'default'
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'type': 'chat',
            'sender_email': currentUserEmail,
            'sender_name': userName
          },
          'to': token,
          'priority': 'high',
        };

        // Send notification
        await http.post(
          Uri.parse(fcmUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(notification),
        );

        print("Notification sent to admin with token: $token");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  String _generateUuid() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '_' +
        (1000 + (DateTime.now().microsecond % 9000)).toString();
  }

  Future<void> _sendMessage(String message, {String type = "text"}) async {
    if (message.trim().isEmpty) return;

    final timestamp = FieldValue.serverTimestamp();

    // First add to local state for immediate UI update
    setState(() {
      _messages.add({
        "type": type,
        "content": message,
        "isAdmin": false,
        "timestamp": Timestamp.now()
      });
    });

    _messageController.clear();

    try {
      // Message data to be stored
      String messageId = _generateUuid();
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('UserRegress')
          .doc(currentUserEmail)
          .get();
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      Map<String, dynamic> messageData = {
        "userName": data['name'] ?? '',
        "type": type,
        "content": message,
        "senderId": currentUserEmail,
        "receiverId": adminEmail,
        "timestamp": timestamp,
        "isAdmin": false,
        "messageId": messageId,
      };

      // Store in Indi_Chat collection for user's individual chat history
      await _firestore
          .collection("Indi_Chat")
          .doc(currentUserEmail)
          .collection("messages")
          .add(messageData);

      // Store in Chat collection (global chat storage)
      await _firestore
          .collection("Chat")
          .doc(currentUserEmail)
          .set(messageData);

      // Create or update ChatUser data
      await _firestore.collection("ChatUser").doc(currentUserEmail).set({
        "name": userName,
        "phoneNumber": userPhone,
        "servertime": timestamp,
        "last_message": message,
        "email": currentUserEmail,
      });

      // Send notification to admin for text messages
      if (type == "text") {
        await _sendNotificationToAdmin(message);
      } else if (type == "image") {
        await _sendNotificationToAdmin("📷 Sent an image");
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> _pickAndSendImage() async {
    try {
      final ImagePicker _picker = ImagePicker();

      // Pick an image from gallery
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return; // User canceled the picker

      // Show the image in a preview dialog with a send button
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(image.path),
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Close the preview dialog
                    Navigator.of(context).pop();

                    // Show loading indicator

                    try {
                      // Create a unique filename using timestamp
                      String fileName =
                          'chat_${DateTime.now().millisecondsSinceEpoch}.jpg';

                      // Create a reference to the file location in Firebase Storage
                      Reference storageRef = _storage
                          .ref()
                          .child('chat_images/$currentUserEmail/$fileName');

                      // Upload the file to Firebase Storage
                      await storageRef.putFile(File(image.path));

                      // Get the download URL
                      String downloadURL = await storageRef.getDownloadURL();

                      // Send the image URL as a message
                      await _sendMessage(downloadURL, type: "image");
                      // Dismiss the loading dialog
                      Navigator.of(context).pop();
                      setState(() {
                        // Dismiss the loading dialog
                        Navigator.of(context).pop();
                      });
                    } catch (e) {
                      // Dismiss the loading dialog in case of an error
                      //  Navigator.of(context).pop();
                      setState(() {
                        // Dismiss the loading dialog
                        Navigator.of(context).pop();
                      });
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error uploading image: $e")),
                      );
                      print("Error uploading image: $e");
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      // Show error message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
      print("Error picking image: $e");
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isMe = !message["isAdmin"];
    print("AAAAAAAAAA$isMe");
    // Format timestamp
    String formattedTime = "";
    if (message["timestamp"] != null) {
      Timestamp timestamp = message["timestamp"] as Timestamp;
      DateTime dateTime = timestamp.toDate();
      formattedTime =
          "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    }

    Widget messageContent;
    if (message["type"] == "image") {
      messageContent = Image.network(
        message["content"],
        width: 200,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            Text("Unable to load image", style: TextStyle(color: Colors.red)),
      );
    } else {
      messageContent = Text(
        message["content"],
        style: TextStyle(color: isMe ? Colors.white : Colors.black),
      );
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            messageContent,
            SizedBox(height: 5),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 12,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CHAT", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff008000),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("Indi_Chat")
                  .doc(currentUserEmail)
                  .collection("messages")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error loading messages"));
                }

                List<Map<String, dynamic>> messages = [];
                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    messages.add({
                      "type": data["type"] ?? "text",
                      "content": data["content"],
                      "isAdmin": data["isAdmin"],
                      "timestamp": data["timestamp"]
                    });
                  }
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(messages[index]);
                  },
                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: _pickAndSendImage,
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.green),
            onPressed: () => _sendMessage(_messageController.text),
          ),
        ],
      ),
    );
  }
}
