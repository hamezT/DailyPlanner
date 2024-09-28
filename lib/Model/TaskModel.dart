class taskModel {
  String? message;
  Task? task;

  taskModel({this.message, this.task});

  taskModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    task = json['task'] != null ? Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (task != null) {
      data['task'] = task!.toJson();
    }
    return data;
  }
}

class Task {
  String? title;
  String? date;
  TimeTask? time;
  String? location;
  List<String>? participants;
  String? notes;
  String? status;
  String? reviewedBy;
  bool? isReminderEnabled;
  String? sId;
  int? iV;

  Task(
      {this.title,
      this.date,
      this.time,
      this.location,
      this.participants,
      this.notes,
      this.status,
      this.reviewedBy,
      this.isReminderEnabled,
      this.sId,
      this.iV});

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    date = json['date'];
    time = json['time'] != null ? TimeTask.fromJson(json['time']) : null;
    location = json['location'];
    participants = json['participants'].cast<String>();
    notes = json['notes'];
    status = json['status'];
    reviewedBy = json['reviewedBy'];
    isReminderEnabled = json['isReminderEnabled'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['date'] = date;
    if (time != null) {
      data['time'] = time!.toJson();
    }
    data['location'] = location;
    data['participants'] = participants;
    data['notes'] = notes;
    data['status'] = status;
    data['reviewedBy'] = reviewedBy;
    data['isReminderEnabled'] = isReminderEnabled;
    data['_id'] = sId;
    data['__v'] = iV;
    return data;
  }
}

class TimeTask {
  String? start;
  String? end;

  TimeTask({this.start, this.end});

  TimeTask.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
