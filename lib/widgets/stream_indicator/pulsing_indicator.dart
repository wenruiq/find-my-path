import 'package:flutter/material.dart';

class PulsingIndicator extends StatefulWidget {
  final String message;
  final IconData icon;

  const PulsingIndicator({
    required this.icon,
    required this.message,
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
      onTap: () {},
      child: Container(
        // color: Colors.white,
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
                    color: Theme.of(context).primaryColorDark.withOpacity(1 - _animationController.value),
                  ),
                ),
                Text(
                  widget.message,
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    // color: Colors.cyan.withOpacity(_animationController.value / 4),
                    color: Theme.of(context).primaryColorDark,
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
