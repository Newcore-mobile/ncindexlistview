library ncindexlistview;

///
///Author: YoungChan
///Date: 2019-05-28 15:05:50
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 18:10:37
///Description: 首字排序列表
///
import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'nc_char_index_bar.dart';

class NCIndexListView<T> extends StatefulWidget {
  ///数据源
  final List<T> dataSource;

  ///获取列表项文本
  final String Function(T) getNameText;

  ///列表项构造回调
  final Widget Function(BuildContext, T value) itemBuilder;

  ///列表项高度
  final double itemHeight;
  NCIndexListView(
      {this.dataSource,
      @required this.getNameText,
      @required this.itemBuilder,
      this.itemHeight = 44})
      : assert(getNameText != null),
        assert(itemBuilder != null);

  @override
  _NCIndexListViewState createState() => _NCIndexListViewState<T>(
      dataSource: dataSource,
      getNameText: getNameText,
      itemBuilder: itemBuilder);
}

class _NCIndexListViewState<T> extends State<NCIndexListView> {
  List<T> dataSource;

  ///获取列表项文本
  final String Function(T) getNameText;

  ///列表项构造回调
  final Widget Function(BuildContext, T value) itemBuilder;
  _NCIndexListViewState({this.dataSource, this.getNameText, this.itemBuilder});
  final ScrollController _scrollController = ScrollController();

  List<NCCharItem> _showDataSource;

  ///字母列表
  List<CharIndexItem> _charIndexList;

  void _initDataSource() {
    if (dataSource == null) {
      return;
    }
    dataSource.sort((a, b) {
      var nameA = getNameText(a);
      var nameB = getNameText(b);
      var fa = PinyinHelper.getFirstWordPinyin(nameA)[0];
      var fb = PinyinHelper.getFirstWordPinyin(nameB)[0];
      if (fa != fb) {
        return fa.compareTo(fb);
      } else {
        return nameA.compareTo(nameB);
      }
    });

    //构造字母列表 , 构造显示列表
    _charIndexList = [];
    var tmpCharList = <String>[];
    _showDataSource = [];

    dataSource.forEach((d) {
      var name = getNameText(d);
      var f = PinyinHelper.getFirstWordPinyin(name)[0].toUpperCase();
      if (!tmpCharList.contains(f)) {
        tmpCharList.add(f);
        _charIndexList.add(CharIndexItem(char: f));
        _showDataSource.add(NCCharItem(type: NCCharType.group, name: f));
      }
      _showDataSource
          .add(NCCharItem<T>(type: NCCharType.child, name: name, data: d));
    });
  }

  ///滚动到目标位置
  void _toCharIndex(CharIndexItem charIndexItem) {
    var offsetY = 0.0;
    for (var i = 0; i < widget.dataSource.length; i++) {
      var dataItem = _showDataSource[i];
      if (dataItem.type == NCCharType.group &&
          dataItem.name == charIndexItem.char) {
        break;
      } else if (dataItem.type == NCCharType.group) {
        offsetY += 33;
      } else {
        offsetY += widget.itemHeight;
      }
      offsetY += 1;
    }
    _scrollController.animateTo(offsetY,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  ///构建主列表view
  Widget _buildMainView() {
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) {
        var dataItem = _showDataSource[index];
        NCCharItem nextCharItem;
        if (index < _showDataSource.length - 1) {
          nextCharItem = _showDataSource[index + 1];
        }

        if (dataItem.type == NCCharType.group) {
          return Divider(
            height: 1,
            color: Color(0xFFEEEEEE),
          );
        } else {
          if (nextCharItem != null && nextCharItem.type == NCCharType.group) {
            return Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
            );
          } else {
            return Divider(
              height: 1,
              color: Color(0xFFEEEEEE),
              indent: 16,
            );
          }
        }
      },
      itemCount: _showDataSource == null ? 0 : _showDataSource.length,
      itemBuilder: (context, index) {
        var dataItem = _showDataSource[index];

        if (dataItem.type == NCCharType.group) {
          return Container(
            height: 33,
            padding: EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              dataItem.name,
              style: TextStyle(fontSize: 12, color: Color(0xFF333333)),
            ),
          );
        } else {
          return Container(
            height: widget.itemHeight,
            padding: EdgeInsets.only(left: 16, right: 8),
            child: itemBuilder(context, dataItem.data),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _initDataSource();
    super.initState();
  }

  @override
  void didUpdateWidget(NCIndexListView oldWidget) {
    dataSource = widget.dataSource;
    _initDataSource();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 32),
          child: _buildMainView(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: NCCharIndexBar(
            charIndexList: _charIndexList,
            onCharIndexSelect: (charItem) {
              _toCharIndex(charItem);
            },
          ),
        ),
      ],
    );
  }
}

class NCCharItem<T> {
  NCCharType type;
  String name;
  T data;
  NCCharItem({this.type, this.name, this.data});
}

enum NCCharType { group, child }
