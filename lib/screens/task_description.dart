import 'package:flutter/material.dart';

class TaskDescription extends StatelessWidget {
  final String title, description;

  const TaskDescription(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Description')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              title,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              description,
            ),
          ),
        ],
      ),
    );
  }
}
