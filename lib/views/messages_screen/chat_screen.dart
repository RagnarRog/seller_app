import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seller_app/views/messages_screen/components/chat_bubble.dart';
import 'package:seller_app/views/widgets/normal_text.dart';

import '../../const/const.dart';
import '../../const/firebase_consts.dart';
import '../../services/store_services.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String customerId;
  final String customerName;
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || widget.customerId.isEmpty) return;
    _messageController.clear();
    await firestore.collection(chatsCollection).doc(widget.chatId).update({
      'created_on': FieldValue.serverTimestamp(),
      'last_msg': message,
      'user_ids': [currentUser!.uid, widget.customerId],
    });
    await firestore
        .collection(chatsCollection)
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'created_on': FieldValue.serverTimestamp(),
          'msg': message,
          'uid': currentUser!.uid,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: widget.customerName, size: 16.0, color: fontGrey),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkGrey),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: StoreServices.getChatMessages(widget.chatId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: normalText(
                        text: 'Send a message to start the conversation',
                        color: darkGrey,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index].data();
                      return chatBubble(
                        data,
                        isMine: data['uid'] == currentUser!.uid,
                      );
                    },
                  );
                },
              ),
            ), // Expanded
            10.heightBox,
            SizedBox(
              height: 60,
              child:
                  Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _messageController,
                              textInputAction: TextInputAction.send,
                              onFieldSubmitted: (_) => _sendMessage(),
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "Enter message",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: purpleColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: purpleColor),
                                ),
                              ),
                            ), // TextFormField
                          ), // Expanded
                          IconButton(
                            onPressed: _sendMessage,
                            icon: const Icon(Icons.send, color: purpleColor),
                          ),
                        ],
                      ).box
                      .padding(const EdgeInsets.all(12))
                      .make(), // Row with VelocityX styling
            ), // SizedBox
          ],
        ), // Column
      ), // Padding
    );
  }
}
