import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tomato_work/theme/color.dart';

class TaskDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: BaseColor.greyCCCCCC),
            height: 0.8,
            width: 120,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
                "以下是已完成的任务",
            style: TextStyle(
              fontSize: 10,
              color: BaseColor.greyCCCCCC
            ),),
          ),
          Container(
            decoration: BoxDecoration(color: BaseColor.greyCCCCCC),
            height: 0.8,
            width: 120,
          )
        ]);
  }
}
