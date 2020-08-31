import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Function openDrawer;
  CustomAppBar(this.openDrawer);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MenuButton(openDrawer),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/logo.png',height: 20,),
              SizedBox(width: 15,),
              Text('Drinkable',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17),)
            ],
          ),
          CircleAvatar(
            radius: 19,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          )
        ],
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final Function onTap;
  MenuButton(this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[300],
            width: 1.1,
          ),
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 11,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
            SizedBox(height: 4,),
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
          ],
        ),
      ),
    );
  }
}