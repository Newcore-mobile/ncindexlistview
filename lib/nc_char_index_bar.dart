///
///Author: YoungChan
///Date: 2019-05-28 13:43:37
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 19:38:28
///Description: 字母顺序条
///
import 'package:flutter/material.dart';

class NCCharIndexBar extends StatefulWidget {
  final List<CharIndexItem> charIndexList;
  final void Function(CharIndexItem) onCharIndexSelect;

  NCCharIndexBar({this.charIndexList, this.onCharIndexSelect});

  @override
  _NCCharIndexBarState createState() => _NCCharIndexBarState();
}

class _NCCharIndexBarState extends State<NCCharIndexBar>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State<StatefulWidget>> _toastKey = GlobalKey();
  AnimationController _animController;
  Animation<double> _fadeAnim;

  ///当前定位的字母
  CharIndexItem _currentCharIndex;

  ///显示Toast的坐标
  Offset _showToastOffset = Offset.zero;

  ///是否已经显示toast
  bool _isToastShow = false;

  ///显示toast， 延时1秒自动消失
  Future _showToast() async {
    if (!_isToastShow) {
      _isToastShow = true;
      _animController.forward();
      await Future.delayed(Duration(seconds: 1));
      _animController.reverse();
      _isToastShow = false;
    }

    return Future.value();
  }

  ///滑动操作定位字母
  void _findDragItem(DragUpdateDetails du) {
    for (var i = 0; i < widget.charIndexList?.length ?? 0; i++) {
      var charItem = widget.charIndexList[i];
      RenderBox renderBox = charItem.key.currentContext.findRenderObject();
      var boxOffset = renderBox.localToGlobal(Offset.zero);
      var boxSize = renderBox.size;
      var dragPosition = du.globalPosition;
      if (boxOffset.dx <= dragPosition.dx &&
          boxOffset.dy <= dragPosition.dy &&
          dragPosition.dx <= boxOffset.dx + boxSize.width &&
          dragPosition.dy <= boxOffset.dy + boxSize.height) {
        _positionPin(boxOffset, charItem);
        return;
      }
    }
  }

  ///定位触摸的字母
  void _positionPin(Offset boxOffset, CharIndexItem charItem) {
    setState(() {
      _showToastOffset = Offset(boxOffset.dx - 62, boxOffset.dy - 17);
      _currentCharIndex = charItem;
      if (widget.onCharIndexSelect != null) {
        widget.onCharIndexSelect(charItem);
      }
      _showToast();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    //构造字母列表
    widget.charIndexList?.forEach((charItem) {
      children.add(
        InkWell(
          onTap: () {
            //定位当前字母位置，并在此位置出弹出toast
            RenderBox renderBox =
                charItem.key.currentContext.findRenderObject();
            var boxOffset = renderBox.localToGlobal(Offset.zero);
            _positionPin(boxOffset, charItem);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: Text(
              charItem.char,
              key: charItem.key,
              style: TextStyle(fontSize: 10, color: Color(0xFF333333)),
            ),
          ),
        ),
      );
    });
    var toastOffset = Offset.zero;
    if (_toastKey.currentContext != null) {
      RenderBox toastBox = _toastKey.currentContext.findRenderObject();
      toastOffset = toastBox.globalToLocal(_showToastOffset);
    }

    return Container(
      width: 140,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            //Toast widget
            Positioned(
              left: toastOffset.dx,
              top: toastOffset.dy,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: 54,
                  height: 44,
                  padding: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      image: DecorationImage(image: char_indicator)),
                  alignment: Alignment.center,
                  child: Text(
                    _currentCharIndex == null ? '' : _currentCharIndex.char,
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
            //字母列表
            Align(
              key: _toastKey,
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onVerticalDragUpdate: (du) {
                  _findDragItem(du);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CharIndexItem {
  String char;
  GlobalKey<State<StatefulWidget>> key = GlobalKey();

  CharIndexItem({this.char});
}

const char_indicator =
    AssetImage('assets/ic_char_indicator.png', package: 'ncindexlistview');
