import 'package:flutter/material.dart';
import 'package:tomato_work/data/db.dart';
import 'package:provider/provider.dart';
import 'package:tomato_work/page/history_page.dart';
import 'package:tomato_work/page/screen_lock_page.dart';
import 'package:tomato_work/page/setting_page.dart';
import 'package:tomato_work/page/statistics_page.dart';
import 'package:tomato_work/page/to_do_page.dart';
import 'package:tomato_work/theme/color.dart';

import 'data/data_center.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(builder: (context) => DbUtils()),
          ChangeNotifierProvider(builder: (context) => DataCenter())
        ],
        child: MaterialApp(
          title: '番茄工作法',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: '番茄'),
          routes: <String, WidgetBuilder>{
            "/screen_lock": (context) => ScreenLockPage()
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curIndex = 0;
  var _pageController = PageController(initialPage: 0);

  void onPageSelect(int index) {
    _pageController.animateToPage(index,
        duration: Duration(seconds: 1), curve: ElasticOutCurve(1.0));
//    _pageController.jumpToPage(index);
    setState(() {
      _curIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _curIndex = index;
          });
        },
        children: <Widget>[
          ToDoPage(),
          HistoryPage(),
          StatisticsPage(),
          SettingPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: ThemeColor.navSelectColor,
          unselectedItemColor: ThemeColor.navIconColor,
          currentIndex: _curIndex,
          onTap: (int index) {
            onPageSelect(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                title: Title(
                    color: ThemeColor.taskRunning,
                    child: Text("待做", style: TextStyle(fontSize: 10)))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                ),
                title: Title(
                    color: ThemeColor.navIconColor,
                    child: Text("历史", style: TextStyle(fontSize: 10)))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_chart,
                ),
                title: Title(
                    color: ThemeColor.navIconColor,
                    child: Text("统计", style: TextStyle(fontSize: 10)))),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                title: Title(
                    color: ThemeColor.navIconColor,
                    child: Text("设置", style: TextStyle(fontSize: 10))))
          ]),
    );
  }
}
