import 'package:flutter/material.dart';
import '../values/water_amount_types.dart';
import '../models/water_amount.dart';

class WaterAmountSelector extends StatefulWidget {
  @override
  _WaterAmountSelectorState createState() => _WaterAmountSelectorState();
}

class _WaterAmountSelectorState extends State<WaterAmountSelector> {
  PageController _pageController;
  double _page = 2.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 2,
      viewportFraction: 0.4
    )..addListener(() {
      setState(() {
        _page = _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 110,
      //color: Colors.yellow,
      child: PageView.builder(
        controller: _pageController,
        itemCount: waterAmountTypes.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          WaterAmount waterAmount = waterAmountTypes[index];
          return Transform.scale(
            scale: 1.0-(0.3*(index.toDouble()-_page).abs()),
            child: Align(
              alignment: Alignment.centerRight.add(Alignment(-0.1, 0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(waterAmount.iconPath,height: 25,),
                  SizedBox(width: 10,),
                  Text('${waterAmount.count}  ${waterAmount.type}',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                ],
              )
            ),
          );
        },
      )
    );
  }
}