import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/models/add_task_data_model.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/utils/instances.dart';
import 'package:todo_app/widgets/add_todo_widget.dart';
import 'package:todo_app/widgets/todo_card_widget.dart';

class ToDoListScreen extends StatefulWidget {
  final User? userData;
  const ToDoListScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  late DatabaseReference currentUserDataRef;
  @override
  void initState() {
    currentUserDataRef =
        FirebaseDatabase.instance.ref('${widget.userData!.uid}/data');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              elevation: 0.0,
              leading: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/premium-vector/man-avatar-profile-round-icon_24640-14044.jpg?w=2000")),
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      debugPrint("UserLogout");
                      await googleSignIn.signOut();
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.purple,
                    ))
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppConstants.hello,
                      style: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                    Text(
                      widget.userData?.displayName ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FirebaseAnimatedList(
                        query: currentUserDataRef,
                        defaultChild: const Center(
                            child: CircularProgressIndicator(
                                color: Colors.redAccent)),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, snapshot, animation, index) {
                          return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ToDoCard(
                                  title: snapshot
                                      .child('task_name')
                                      .value
                                      .toString(),
                                  description: snapshot
                                      .child('task_desc')
                                      .value
                                      .toString(),
                                  dateTime: snapshot
                                      .child('task_date')
                                      .value
                                      .toString(),
                                  uid: snapshot.child('id').value.toString(),
                                  user: widget.userData));
                        })),
            floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      useSafeArea: true,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: AddToDoWidget(
                              isEdit: false,
                              addTaskDataModel: AddTaskDataModel(),
                              userData: widget.userData),
                        );
                      });
                },
                backgroundColor: Colors.purple,
                splashColor: Colors.white,
                child: const Icon(Icons.add_task_sharp))));
  }
}
