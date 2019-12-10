///
///Author: YoungChan
///Date: 2019-12-10 16:44:57
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 18:50:25
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:ncindexlistview/ncindexlistview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
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
  List<String> _dataSource = [
    '宝慧雅',
    '董水凡',
    '齐曼婉',
    '斐承载',
    '叔寒雁',
    '赵欣艳',
    '泉亦绿',
    '单芳懿',
    '蒋鹏鲸',
    '车含桃',
    '蓝觅珍',
    '薄凝梦',
    '胥谷枫',
    '翁心怡',
    '旅志国',
    '郁高超',
    '尚婉秀',
    '饶亦云',
    '艾寒凝',
    '雷小夏',
    '吴绮南',
    '南宫惜玉',
    '晋涵亮',
    '干梓云',
    '曹萍',
    '冯晓昕',
    '裴雯丽'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IndexList'),
      ),
      body: NCIndexListView<String>(
        dataSource: _dataSource,
        getNameText: (s) => s,
        itemBuilder: (context, value) {
          return ListTile(
            title: Text(value),
          );
        },
        itemHeight: 50,
      ),
    );
  }
}
