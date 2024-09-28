class TaskStatModel {
  int? tasksCreated;
  int? tasksInProgress;
  int? tasksCompleted;
  int? tasksClosed;

  TaskStatModel(
      {this.tasksCreated,
      this.tasksInProgress,
      this.tasksCompleted,
      this.tasksClosed});

  TaskStatModel.fromJson(Map<String, dynamic> json) {
    tasksCreated = json['tasksCreated'];
    tasksInProgress = json['tasksInProgress'];
    tasksCompleted = json['tasksCompleted'];
    tasksClosed = json['tasksClosed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tasksCreated'] = tasksCreated;
    data['tasksInProgress'] = tasksInProgress;
    data['tasksCompleted'] = tasksCompleted;
    data['tasksClosed'] = tasksClosed;
    return data;
  }
}
