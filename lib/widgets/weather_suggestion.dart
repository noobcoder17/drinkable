import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// providers
import '../providers/home_provider.dart';

// values
import '../values/weather_icons.dart';


class WeatherSuggestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weather',
          style:  GoogleFonts.poppins(fontSize: 20),
        ),
        SizedBox(height: 18,),
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
                          style: GoogleFonts.poppins(
                            color: Colors.black,fontSize: 17,
                          ),
                          children: [
                            TextSpan(text: 'It\'s ',style:  GoogleFonts.poppins(fontWeight: FontWeight.w300)),
                            TextSpan(text:  weather['description'],style:  GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                            TextSpan(text: ' today!',style:  GoogleFonts.poppins(fontWeight: FontWeight.w300)),
                          ]
                        ),
                      ),
                      SizedBox(height: 11,),
                      Text(
                        'Dont\'t forget to take the water bottle with you.',
                        style:  GoogleFonts.poppins(
                          height: 1.5,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12
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