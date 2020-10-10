import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double width, height;
  const Skeleton({Key key, this.width, this.height}) : super(key: key);
  @override
  _SkeletonState createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1500))
          ..addListener(() => setState(() {}));

    _animation = Tween<double>(begin: -1, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: Theme.of(context).brightness == Brightness.dark
              ? [Colors.white12, Colors.white24, Colors.white12]
              : [Colors.black12, Colors.black26, Colors.black12],
          begin: Alignment(_animation.value, 0),
          end: Alignment(-1, 0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
