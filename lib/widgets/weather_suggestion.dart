import 'package:drinkable/providers/home_provider.dart';
import 'package:drinkable/values/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        Consumer<HomeProvider>(
          builder: (context, value, child) {
            Map<String,dynamic> weather = value.weather;
            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 37, 90, 210),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Image.asset(
                    weatherIcons[
                      weather['icon'].toString().split('')[0]
                      +weather['icon'].toString().split('')[1]
                    ],
                    width: 40,
                  ),
                ),
                SizedBox(width: 20,),
                Container(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'It\'s ',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
                            TextSpan(text:  weather['description'],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w700)),
                            TextSpan(text: ' today!',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w300)),
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
            );
          },
        ),
      ],
    );
  }
}