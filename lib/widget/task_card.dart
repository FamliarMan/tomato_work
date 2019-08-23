import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tomato_work/data/data_center.dart';
import 'package:tomato_work/data/db.dart';
import 'package:tomato_work/data/model/db_model.dart';
import 'package:tomato_work/theme/color.dart';

class TaskCard extends StatefulWidget {
  TaskInfo _taskInfo;

  TaskCard(this._taskInfo);

  @override
  Widget build(BuildContext context) {}

  @override
  State<StatefulWidget> createState() {
    return TaskCardState(_taskInfo);
  }
}

class TaskCardState extends State<TaskCard> {
  TaskInfo taskInfo;
  Color color;
  String action;
  String status;

  TaskCardState(TaskInfo taskInfo) {
    this.taskInfo = taskInfo;
  }

  void _switchStatus() {
    if (taskInfo.status == TaskInfo.statusFinished) {
      color = ThemeColor.taskFinished;
      action = "";
      status = "已完成";
    } else if (taskInfo.status == TaskInfo.statusNotStart) {
      color = ThemeColor.taskNotStart;
      action = "开始";
      status = "未开始";
    } else if (taskInfo.status == TaskInfo.statusRunning) {
      color = ThemeColor.taskRunning;
      action = "完成";
      status = "进行中";
    } else {
      //shouldn't come here
      color = ThemeColor.taskNotStart;
      action = "开始";
      status = "未开始";
    }
  }

  @override
  Widget build(BuildContext context) {
    _switchStatus();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)), color: color),
      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Row(
              children: <Widget>[
                Text(taskInfo.name,
                    style: TextStyle(fontSize: 18, color: BaseColor.white)),
                Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      status,
                      style: TextStyle(fontSize: 10, color: BaseColor.white),
                    ))
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      '预计${taskInfo.estimatedDuration}分钟',
                      style: TextStyle(color: BaseColor.white, fontSize: 12),
                    ),
                    Offstage(
                      offstage: taskInfo.status != TaskInfo.statusFinished,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '实际${taskInfo.realDuration}分钟',
                          style:
                              TextStyle(color: BaseColor.white, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ))
          ]),
          Offstage(
              offstage: taskInfo.status != TaskInfo.statusRunning &&
                  taskInfo.status != TaskInfo.statusNotStart,
              child: FlatButton(
                  onPressed: () {
                    _statusClick();
                  },
                  child: Text(
                    action,
                    style: TextStyle(fontSize: 16, color: BaseColor.white),
                  )))
        ],
      ),
    );
  }

  void _statusClick() {
    if (taskInfo.status == TaskInfo.statusNotStart) {
      _startTask();
    } else if (taskInfo.status == TaskInfo.statusRunning) {
      _finishTask();
    }
  }

  void _startTask() {
    DbUtils dbUtils = Provider.of<DbUtils>(context);
    setState(() {
      taskInfo.startTime = DateTime.now().millisecondsSinceEpoch;
      taskInfo.status = TaskInfo.statusRunning;
    });
    dbUtils.updateTaskInfo(taskInfo);
  }

  void _finishTask() async {
    print("finish ");
    DbUtils dbUtils = Provider.of<DbUtils>(context);
    taskInfo.realDuration =
        (DateTime.now().millisecondsSinceEpoch - taskInfo.startTime) ~/
            (1000 * 60);
    taskInfo.status = TaskInfo.statusFinished;
    await dbUtils.updateTaskInfo(taskInfo);
    DataCenter dataCenter = Provider.of<DataCenter>(context);
    dataCenter.updatePresentTasks(await dbUtils.queryPresentTasks());
  }
}
