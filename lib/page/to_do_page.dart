import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato_work/data/data_center.dart';
import 'package:tomato_work/data/db.dart';
import 'package:tomato_work/data/model/db_model.dart';
import 'package:tomato_work/widget/task_card.dart';
import 'package:tomato_work/widget/task_divider.dart';
import 'package:tomato_work/widget/time_counter.dart';

import 'dialog/task_edit_dialog.dart';

class ToDoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ToDoState();
  }
}

class ToDoState extends State<ToDoPage> with AutomaticKeepAliveClientMixin {
  TimeCounterController _timeCounterController = TimeCounterController(
    tomatoDuration: 25,
    restDuration: 5,
  );

  bool _hasQuery = false;

  @override
  void initState() {
    super.initState();
    if (!_hasQuery) {
      Future.delayed(Duration.zero, () {
        queryTasks();
      });
      _hasQuery = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    DataCenter dataCenter = Provider.of<DataCenter>(context);
    var notFinishTasks = [];
    var finishedTasks = [];
    dataCenter.presentTasks.forEach((task) {
      if (task.status == TaskInfo.statusFinished) {
        finishedTasks.add(task);
      } else {
        notFinishTasks.add(task);
      }
    });
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            TimeCounter(_timeCounterController),
            Expanded(
              child: ListView.builder(
                  itemCount: notFinishTasks.length + finishedTasks.length + 1,
                  //+1是因为有一条分割栏目
                  itemBuilder: (BuildContext context, int index) {
                    Widget item;
                    if (index < notFinishTasks.length) {
                      item = TaskCard(notFinishTasks[index]);
                    } else if (index == notFinishTasks.length) {
                      //分割栏目
                      item = TaskDivider();
                    } else {
                      item = TaskCard(
                          finishedTasks[index - notFinishTasks.length - 1]);
                    }
                    return Container(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      child: item,
                    );
                  }),
            )
          ],
        ),
        Container(
          alignment: Alignment(0.9, 0.9),
          child: FloatingActionButton(
            child: Text("增加"),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return TaskEditDialog();
                  });
            },
          ),
        ),
      ],
    );
  }

  void queryTasks() async {
    DbUtils dbUtils = Provider.of<DbUtils>(context);
    DataCenter dataCenter = Provider.of<DataCenter>(context);
    Future<List<TaskInfo>> futureTasks = dbUtils.queryPresentTasks();
    futureTasks.then((List<TaskInfo> tasks) {
      dataCenter.updatePresentTasks(tasks);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
