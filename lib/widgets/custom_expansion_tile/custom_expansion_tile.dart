import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

import '../../constant/app_colors.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final Duration duration;
  final Curve curve;
  final Curve reverseCurve;
  final Function()? onCollapse;
  final Function()? onExpand;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final bool tapHeaderToExpand;
  const CustomExpansionTile({
    super.key,

    required this.title,
    required this.children,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.reverseCurve = Curves.easeInOut,
    this.onCollapse,
    this.onExpand,
    this.margin,
    this.padding,
    this.decoration,
    this.tapHeaderToExpand = true,
  });

  @override
  State createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isExpanded;
  bool isOpen() => _isExpanded;

  @override
  void initState() {
    super.initState();
    try {
      _isExpanded = widget.initiallyExpanded;
      _controller = AnimationController(
        duration: widget.duration,
        reverseDuration: widget.duration,
        vsync: this,
      );
      _animation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve,
      );

      if (_isExpanded) {
        _controller.forward();
      }
    } catch (e) {
      errorLog("initial iniState", e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    try {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          _controller.forward();
          if (widget.onExpand != null) {
            widget.onExpand!();
          }
        } else {
          _controller.reverse();
          if (widget.onCollapse != null) {
            widget.onCollapse!();
          }
        }
      });
    } catch (e) {
      errorLog("handle tap", e);
    }
  }

  void expand() {
    try {
      if (!_isExpanded) {
        _handleTap();
      }
    } catch (e) {
      errorLog("handle tap", e);
    }
  }

  void collapse() {
    try {
      if (_isExpanded) {
        _handleTap();
      }
    } catch (e) {
      errorLog("collapse function", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: widget.tapHeaderToExpand ? _handleTap : null,
          child: Container(
            padding: widget.padding,
            margin: widget.margin,
            decoration: widget.decoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: widget.title),
                GestureDetector(
                  onTap: widget.tapHeaderToExpand ? null : _handleTap,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 24,
                      color: AppColors.instance.black500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
