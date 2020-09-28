import 'package:climate/src/blocs/blocs.dart';
import 'package:flutter/material.dart';

class CustomExpansion extends StatefulWidget {
  final List<Widget> children;
  final double itemExtent;
  const CustomExpansion({Key key, this.children, this.itemExtent = 36.0})
      : super(key: key);
  @override
  _CustomExpansionState createState() => _CustomExpansionState();
}

class _CustomExpansionState extends State<CustomExpansion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  Animation<double> _size;
  AnimationController _controller;
  PreferencesBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<PreferencesBloc>(context);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // At least 3/4 child be presented then by clicking the
    // button it shows all the items.
    _size = Tween(
            // At least 3/4
            begin: 4 * widget.itemExtent,
            // Add some spaces between button and last item
            // +2 is for that reason.
            end: widget.itemExtent * (widget.children.length + 2))
        .animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('CustomExpansion');
    return AnimatedBuilder(
      animation: _controller,
      child: Stack(
        children: [
          Positioned.fill(
            left: 16.0,
            right: 16.0,
            child: ListView.builder(
              itemExtent: widget.itemExtent,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: widget.children.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => widget.children[index],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: StreamBuilder(
              stream: _bloc.themeStream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.done:
                    return FlatButton(
                      hoverColor: Colors.grey.shade200.withOpacity(.3),
                      color: snapshot.data
                          ? Colors.black26
                          : Colors.grey.shade200.withOpacity(.35),
                      onPressed: () {
                        if (_controller.status == AnimationStatus.completed) {
                          _isExpanded = false;
                          _controller.reverse();
                        } else if (_controller.status ==
                            AnimationStatus.dismissed) {
                          _isExpanded = true;
                          _controller.forward();
                        }
                        setState(() {});
                      },
                      child: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    );
                    break;
                  default:
                    return Container();
                }
              },
            ),
          )
        ],
      ),
      builder: (context, child) {
        return SizedBox.fromSize(
          child: child,
          size: Size.fromHeight(_size.value),
        );
      },
    );
  }
}
