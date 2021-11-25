import 'package:flutter/material.dart';

class PulsingIndicator extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final void Function() onTapFn;

  const PulsingIndicator({
    required this.icon,
    required this.message,
    this.bgColor = Colors.white,
    this.textColor = Colors.blue,
    required this.onTapFn,
    Key? key,
  }) : super(key: key);

  @override
  State<PulsingIndicator> createState() => _PulsingIndicatorState();
}

class _PulsingIndicatorState extends State<PulsingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animation = Tween(begin: 0, end: 0.4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTapFn(),
      child: Container(
        color: widget.bgColor,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    widget.icon,
                    color: widget.textColor.withOpacity(1 - _animationController.value),
                  ),
                ),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
