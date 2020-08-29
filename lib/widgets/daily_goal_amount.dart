import 'package:flutter/material.dart';

class DailyGoalAmount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          border: Border(left: BorderSide(color: Colors.white,width: 2)),
        ),
        child: Row(
          children: [
            Text(
              'Goal',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 19,
                fontWeight: FontWeight.w300
              ),
            ),
            SizedBox(width: 15,),
            Text(
              '3.2 L',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700
              )
            )
          ],
        ),
      ),
    );
  }
}