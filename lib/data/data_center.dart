
import 'package:flutter/widgets.dart';

import 'model/db_model.dart';

class DataCenter with ChangeNotifier{

  /// 今日的所有任务
  List<TaskInfo> presentTasks = [];

  /// 所有的任务信息
  List<TaskInfo> allTasks = [];

  /// 更新今日的所有任务
  void updatePresentTasks(List<TaskInfo> tasks){
    presentTasks = tasks;
    notifyListeners();
  }

}