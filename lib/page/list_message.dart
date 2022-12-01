import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nutrious/model/message.dart';
import 'package:intl/intl.dart';

String formatDateTime(datetime) {
  final outputFormat = DateFormat("dd-MM-yyyy HH:mm");
  return outputFormat.format(datetime);
}

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Future<List<Message>> fetchMessage() async {
      final response = await request.get("https://nutrious.up.railway.app/json-message/");
      List<Message> listMessage = [];
      for (var message in response){
        if (message != null){
          listMessage.add(Message.fromJson(message));
        }
      }
      return listMessage;
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFFF0FFFF),
          centerTitle: true,
          title: Image.asset('images/NUTRIOUS.png', height: 75),
          toolbarHeight: 100,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30)
              )
          ),
          iconTheme: const IconThemeData(color: Colors.indigo)
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: const Text("List of Fundraising(s)", style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20
                ),),
              ),
            ),
            Expanded(
              flex: 10,
              child: FutureBuilder(
                future: fetchMessage(),
                builder: (context, AsyncSnapshot snapshot){
                  if (snapshot.data == null){
                    return const Center(child: CircularProgressIndicator());
                  } else{
                    if (!snapshot.hasData) {
                      return const Text("No Opened Fundraising");
                    } else{
                      return ListView.builder(
                        padding: const EdgeInsets.all(7),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(5),
                            height: 80,
                            decoration: BoxDecoration(
                                color:Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 2.0
                                  )
                                ]
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(snapshot.data![index].fields.message, textAlign: TextAlign.left, style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20
                                    ),),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text("Sender ID: ${snapshot.data![index].fields.user.toString()}"),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Text(formatDateTime(snapshot.data![index].fields.timeSent.toLocal()))
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );;
  }
}
