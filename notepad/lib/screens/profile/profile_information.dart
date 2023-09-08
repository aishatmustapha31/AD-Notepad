import 'package:flutter/material.dart';

class ProfileInformation extends StatefulWidget {
  final String title;
  const ProfileInformation({super.key, required this.title});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Text(widget.title,
            style:
            TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
