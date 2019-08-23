import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tomato_work/data/data_center.dart';
import 'package:tomato_work/data/db.dart';
import 'package:tomato_work/data/model/db_model.dart';
import 'package:tomato_work/theme/color.dart';
import 'package:tomato_work/utils/dialog_utils.dart';

class TaskEditDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskEditDialogState();
  }
}

class TaskEditDialogState extends State<TaskEditDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _estimatedDurationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50),
      child: Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                "添加任务",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "任务名称"),
            maxLength: 20,
          ),
          TextField(
            controller: _estimatedDurationController,
            decoration: InputDecoration(
              labelText: "预计时间(分钟)",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                color: BaseColor.green65C6A6,
                child: Padding(
                    padding: EdgeInsets.only(left: 70, right: 70),
                    child: Text(
                      "确认",
                      style: TextStyle(color: BaseColor.white),
                    )),
                onPressed: () {
                  addTask();
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    ));
  }

  void addTask() async {
    if (_nameController.text.isEmpty) {
      DialogUtils.showInfoDialog(context, "任务名称不能为空");
      return;
    }
    if (_estimatedDurationController.text.isEmpty) {
      DialogUtils.showInfoDialog(context, "任务预估时长不能为空");
      return;
    }

    TaskInfo info = TaskInfo();
    info.status = TaskInfo.statusNotStart;
    info.estimatedDuration = int.parse(_estimatedDurationController.text) ;
    info.createTime = DateTime.now().millisecondsSinceEpoch;
    info.name = _nameController.text;

    DbUtils dbUtils = Provider.of<DbUtils>(context);
    DataCenter dataCenter = Provider.of<DataCenter>(context);
    await dbUtils.addTaskInfo(info);
    dataCenter.updatePresentTasks(await dbUtils.queryPresentTasks());
  }
}
