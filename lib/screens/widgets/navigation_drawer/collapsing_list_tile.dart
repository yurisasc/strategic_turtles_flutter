import 'package:flutter/material.dart';

import 'navigation_theme.dart';

class CollapsingListTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  CollapsingListTile(
      {@required this.title,
        @required this.icon,
        @required this.animationController,
        this.isSelected = false,
        this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 60, end: 180).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 0, end: 10).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 7.0),
            Icon(
              widget.icon,
              color: widget.isSelected ? selectedColor : Colors.white70,
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 170)
                ? Text(widget.title,
                style: widget.isSelected
                    ? listTitleSelectedTextStyle
                    : listTitleDefaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}
