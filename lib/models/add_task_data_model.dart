class AddTaskDataModel {
  String? taskName;
  String? descOfTask;
  String? taskDate;

  AddTaskDataModel({this.taskName, this.descOfTask, this.taskDate});

  AddTaskDataModel.fromJson(Map<dynamic, dynamic> data) {
    taskName = data['task_name'];
    descOfTask = data['task_desc'];
    taskDate = data['task_date'];
  }
}
