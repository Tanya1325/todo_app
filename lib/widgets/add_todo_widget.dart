import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:todo_app/models/add_task_data_model.dart';
import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/utils/instances.dart';
import 'package:webkul_textfield_with_label/utils/input_decoration.dart';
import 'package:webkul_textfield_with_label/webkul_textfield_with_label.dart';
import 'package:intl/intl.dart';

class AddToDoWidget extends StatefulWidget {
  final bool isEdit;
  final User? userData;
  final AddTaskDataModel addTaskDataModel;

  const AddToDoWidget(
      {Key? key,
      required this.isEdit,
      required this.addTaskDataModel,
      this.userData})
      : super(key: key);

  @override
  State<AddToDoWidget> createState() => _AddToDoWidgetState();
}

class _AddToDoWidgetState extends State<AddToDoWidget> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  AppConstants.newTaskToDo,
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 4.0),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWithLabel(
                      controller: titleEditingController,
                      labelText: AppConstants.titleTask,
                      labelTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      gapBtwLblAndField: 8.0,
                      inputDecorationTextField: InputDecorationTextField(
                          contentEdgePadding: const EdgeInsets.all(12.0),
                          filledColor: Colors.grey.shade200,
                          isFilled: true,
                          hint: AppConstants.addTask,
                          hintTxtStyle: const TextStyle(fontSize: 14.0),
                          enabledInputBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8.0)),
                          focusedInputBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                    TextFieldWithLabel(
                      controller: descEditingController,
                      labelText: AppConstants.descTask,
                      labelTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      gapBtwLblAndField: 8.0,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      inputDecorationTextField: InputDecorationTextField(
                          contentEdgePadding: const EdgeInsets.all(12.0),
                          filledColor: Colors.grey.shade200,
                          isFilled: true,
                          hint: AppConstants.addDesc,
                          hintTxtStyle: const TextStyle(fontSize: 14.0),
                          enabledInputBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedInputBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        AppConstants.date,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030))
                              .then((value) => setState(() {
                                    dateTime = value ?? DateTime.now();
                                  }));
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.grey.shade200),
                            padding: const EdgeInsets.all(12.0),
                            child: Row(children: [
                              const Icon(Icons.calendar_month_outlined,
                                  color: Colors.grey),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(dateTime != null
                                    ? DateFormat("dd/MM/yyyy")
                                        .format(DateTime.parse(dateTime.toString()))
                                    : "dd/mm/yyyy"),
                              )
                            ])))
                  ]),
              const SizedBox(
                height: 4.0,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 60.0,
                        child: OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(const BorderSide(
                                    color: Colors.purple))),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              AppConstants.cancel,
                              style: TextStyle(fontSize: 20.0,color: Colors.purple),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 12.0
                    ),
                    Expanded(
                        child: SizedBox(
                            height: 60.0,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    String userUID = widget.userData!.uid;
                                    DatabaseReference currentUserDataRef =
                                        FirebaseDatabase.instance
                                            .ref(widget.userData!.uid);
                                    currentUserDataRef.ref.get().then((snapshot) {
                                      int timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      firebaseDatabase
                                          .child('$userUID/data/$timestamp')
                                          .set({
                                            'task_name':
                                                titleEditingController.text,
                                            'task_desc': descEditingController.text,
                                            'task_date': dateTime.toString(),
                                            'id': timestamp.toString()
                                          })
                                          .then((value) => {
                                                showSimpleNotification(
                                                    const Text(
                                                        "Task added successfully"),
                                                    background: Colors.lightGreen)
                                              })
                                          .whenComplete(
                                              () => Navigator.of(context).pop());
                                    });
                                  }
                                },
                                child: Text(
                                  widget.isEdit
                                      ? AppConstants.update
                                      : AppConstants.create,
                                  style: const TextStyle(fontSize: 20.0),
                                ))))
                  ]))
            ]),
          )),
    );
  }
}
