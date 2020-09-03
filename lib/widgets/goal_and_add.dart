import 'package:drinkable/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// widgets
import './daily_amout_dial.dart';
import './water_amount_selector.dart';
import './daily_goal_amount.dart';
import './water_effect.dart';

class GoalAndAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: constraints,
          child: Stack(
            alignment: Alignment.center,
            children: [
              WaterEffect(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DailyGoalAmount(),
                        SizedBox(height: 25,),
                        DailyAmountDial()
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     WaterAmountSelector(),
                    //     IconButton(
                    //       icon: Icon(Icons.add_circle,color: Colors.white,size: 35,),
                    //       onPressed: (){
                    //         //Provider.of<HomeProvider>(context,listen: false).addWater(300);
                    //       },
                    //     )
                    //   ],
                    // )
                  ],
                ),
              )
            ],
          )
        );
      },
    );
  }
}