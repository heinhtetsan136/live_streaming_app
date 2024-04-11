import 'package:flutter/material.dart';

class LiveRemark extends StatelessWidget {
  const LiveRemark({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.red.shade500,
            shape: BoxShape.circle,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            "Live",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
