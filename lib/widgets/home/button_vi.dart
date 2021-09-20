import 'package:flutter/material.dart';

class ButtonVI extends StatelessWidget {

  const ButtonVI({
    Key? key,
    required this.icon,
    required this.tooltip,
    required this.label,
    required this.onButtonPress,
  }) : super(key: key);

  final IconData icon;
  final String tooltip;
  final String label;
  final Function onButtonPress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 300,
        height: 180,
        child: OutlinedButton.icon(
          icon: Icon(
            icon,
            size: 60,
            color: Colors.white,
          ),
          label: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          onPressed: () => onButtonPress(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                //* Remove opacity after development (is currently there just to test that button can be pressed)
                Theme.of(context).colorScheme.primary.withOpacity(0.85)),
          ),
        ),
      ),
    );
  }
}
