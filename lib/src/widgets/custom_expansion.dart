import 'package:flutter/material.dart';

class CustomExpansion extends StatefulWidget {
  final List<Widget> children;
  final double itemExtent;
  const CustomExpansion({Key key, this.children, this.itemExtent = 36.0})
      : super(key: key);
  @override
  _CustomExpansionState createState() => _CustomExpansionState();
}

class _CustomExpansionState extends State<CustomExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    print('CustomExpansion');
    return SizedBox.fromSize(
      child: Stack(
        children: [
          Positioned.fill(
            left: 16.0,
            right: 16.0,
            child: ListView.builder(
              itemExtent: widget.itemExtent,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _isExpanded ? widget.children.length : 3,
              shrinkWrap: true,
              itemBuilder: (context, index) => widget.children[index],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: FlatButton(
              hoverColor: Colors.grey.shade200.withOpacity(.3),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black26
                  : Colors.grey.shade200.withOpacity(.35),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
      size: Size.fromHeight(widget.itemExtent *
              (_isExpanded
                  ? _isExpanded ? widget.children.length : 3 + 1
                  : 3.0) +
          36.0),
    );
  }
}
