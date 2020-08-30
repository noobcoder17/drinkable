import 'package:flutter/material.dart';

class WeatherSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather',
          style: TextStyle(fontSize: 22),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 37, 90, 210),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Image.asset('assets/icons/025-sun.png',width: 40,),
            ),
            Container(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: 'It\'s',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
                        TextSpan(text: ' hot ',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700)),
                        TextSpan(text: 'today!',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
                      ]
                    ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    'Dont\'t forget to take the water bottle with you.',
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.black.withOpacity(0.6)
                      ),
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}