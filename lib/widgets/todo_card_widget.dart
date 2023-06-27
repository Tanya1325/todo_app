import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoCard extends StatelessWidget {
  final String? title;
  final String? description;
  final String? dateTime;
  final String? uid;
  final User? user;

  const ToDoCard(
      {Key? key,
      @required this.title,
      @required this.description,
      @required this.dateTime,
      @required this.uid,
      @required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Card(
        elevation: 0.0,
        color: Colors.purple[50],
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Colors.purple)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0))),
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (title.toString()[0].toUpperCase() +
                                    title
                                        .toString()
                                        .substring(1)
                                        .toLowerCase()),
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: dateTime.toString().toLowerCase() == "null"
                                  ? const Text("--")
                                  : Text(
                                      DateFormat('EEEE, MMM d, ' 'yy').format(
                                          DateTime.parse(dateTime.toString())),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0,
                                          color: Colors.grey))),
                           Row(
                              mainAxisSize:  MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const[
                                Expanded(child: Divider(color: Colors.purple)),
                              ]),
                          const Text("Description:"),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                description ?? "",
                                maxLines: 4,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ))
                        ]))),
            IconButton(
                onPressed: () async {
                  DatabaseReference currentUserDataRef = FirebaseDatabase
                      .instance
                      .ref('/${user?.uid.toString()}/data/$uid');
                  await currentUserDataRef.remove();
                  debugPrint("DELETED!");
                  debugPrint('/${user?.uid.toString()}/data/$uid');
                },
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.purple)),
          ],
        ),
      ),
    );
  }
}
