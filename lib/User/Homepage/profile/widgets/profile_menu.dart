import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color.fromARGB(255, 233, 233, 254),
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 68, 68, 130))),
      title: Text(title,
          style: const TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 68, 68, 130))),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromARGB(255, 151, 151, 229).withOpacity(0.1),
        ),
        child: const Icon(LineAwesomeIcons.angle_right,
            size: 18.0, color: Color.fromARGB(255, 68, 68, 130)),
      ),
    );
  }
}