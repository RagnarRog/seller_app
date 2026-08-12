import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../../const/const.dart';
import '../../const/firebase_consts.dart';
import '../../services/store_services.dart';
import '../widgets/normal_text.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: chats, size: 16.0, color: fontGrey),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkGrey),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: normalText(text: 'No messages yet', color: darkGrey),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(data.length, (index) {
                    var t = data[index]['created_on'] == null
                        ? DateTime.now()
                        : data[index]['created_on'].toDate();
                    var time = intl.DateFormat("h:mma").format(t);
                    return ListTile(
                      onTap: () {
                        final userIds = data[index]['user_ids'];
                        final customerId = userIds is List
                            ? userIds
                                  .map((id) => id.toString())
                                  .firstWhere(
                                    (id) => id != currentUser!.uid,
                                    orElse: () =>
                                        data[index]['fromId']?.toString() ?? '',
                                  )
                            : data[index]['fromId']?.toString() ?? '';
                        Get.to(
                          () => ChatScreen(
                            chatId: data[index].id,
                            customerId: customerId,
                            customerName:
                                data[index]['sender_name']?.toString() ??
                                'Customer',
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: purpleColor,
                        child: Icon(Icons.person, color: white),
                      ), // CircleAvatar
                      title: boldText(
                        text: "${data[index]["sender_name"]}",
                        color: fontGrey,
                      ),
                      subtitle: normalText(
                        text: "${data[index]["last_msg"]}",
                        color: darkGrey,
                      ),
                      trailing: normalText(text: time, color: darkGrey),
                    ); // ListTile
                  }), // List.generate
                ), // Column
              ), // SingleChildScrollView
            );
          }
        },
      ),
    ); // Scaffold
  }
}
