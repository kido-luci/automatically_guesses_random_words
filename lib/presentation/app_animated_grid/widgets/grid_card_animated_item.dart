import 'package:flutter/material.dart';

class GridCardAnimatedItemWidget extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback? onTap;
  final bool selected;
  final bool removing;
  final Widget child;

  const GridCardAnimatedItemWidget({
    super.key,
    this.onTap,
    this.selected = false,
    this.removing = false,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: animation,
            curve: removing ? Curves.easeInOut : Curves.bounceOut),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Card(
            color: Colors.grey.shade100,
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
