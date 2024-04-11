import 'package:flutter/material.dart';

class LiveCount extends StatelessWidget {
  final String count;
  const LiveCount({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.person,
          size: 16,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            count,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
