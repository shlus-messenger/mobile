import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String logo;
  final String? name;
  final double radius;

  const Logo({
    super.key,
    required this.logo,
    this.name,
    this.radius = 20
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: logo.contains("http") ? NetworkImage(
        logo
      ) : null,
      backgroundColor: !logo.contains("http") ? Color(int.parse(logo.replaceAll("#", "0xff"))) : null,
      child: !logo.contains("http")
        ? Text(
          name![0],
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: 1
          ),
          textAlign: TextAlign.center,
        )
        : null,
    );
  }

}