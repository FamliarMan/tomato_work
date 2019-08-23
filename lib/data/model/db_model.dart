class TaskInfo {
  static final int statusNotStart = 0;
  static final int statusRunning = 1;
  static final int statusFinished = 2;
  int id;

  TaskInfo();

  TaskInfo.create(this.name, this.status, this.estimatedDuration) {
    createTime = DateTime.now().millisecondsSinceEpoch;
  }

  /// 任务名称
  String name;

  /// 任务状态，0-未开始，1-开始但未结束，2-结束,默认0
  int status;

  /// 预计时长，单位分钟
  int estimatedDuration;

  /// 实际时长
  int realDuration;

  /// 实际开始时间
  int startTime;

  /// 任务创建时间
  int createTime;

  Map<String, dynamic> toMap() {
    Map<String,dynamic> res = toMapWithoutId();
    res['id'] = id;
    return res;
  }


  Map<String, dynamic> toMapWithoutId() {
    return {
      'name': name,
      'status': status,
      'estimatedDuration': estimatedDuration,
      'realDuration': realDuration,
      'createTime': createTime,
      'startTime': startTime
    };
  }

  TaskInfo.fromMap(Map<String,dynamic> map){
    id = map['id'];
    createTime = map['createTime'];
    realDuration = map['realDuration'];
    estimatedDuration = map['estimatedDuration'];
    name = map['name'];
    status = map['status'];
    startTime = map['startTime'];
  }
}

class TomatoInfo {
  int id;

  ///番茄状态，0-已完成，1-废弃
  int status;

  ///番茄持续时间，配置中可以修改，所以需要记录
  int duration;

  int createTime;

  Map<String, dynamic> toMap() {
    return {'id': id, 'duration': duration, 'createTime': createTime};
  }
}
