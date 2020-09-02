import 'package:drinkable/providers/auth_provider.dart';
import 'package:drinkable/screens/auth_screen.dart';
import 'package:drinkable/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/scatistics_screen.dart';

class CustomDrawer extends StatefulWidget {
  static const routeName = 'drawer';
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  bool _isDrawerOpened = false;
  int screen = 0;
 AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    //_animationController.repeat(reverse: true);
  }

  void open(){
    _animationController.forward();
    setState(() {
      _isDrawerOpened = true;
    });
  }

  void close(){
    _animationController.reverse();
    setState(() {
      _isDrawerOpened = false;
    });
  }

  void selectItem(int index){
    if(index!=screen){
      setState(() {
        screen = index;
      });
    }
    close();
  }

  // void tap(){
  //   if(_animationController.isCompleted){
  //     _animationController.reverse();
  //   }else{
  //     _animationController.forward();
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(openDrawer: open,),
      StatisticsScreen(openDrawer: open,),
      ProfileScreen(openDrawer: open,)
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255,0, 11, 33),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              //horizontal: 25,
              vertical: 35
            ),
            //color: Color.fromARGB(255,0, 11, 33),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Good Morning',style: TextStyle(color: Colors.white54,fontSize: 14),),
                              SizedBox(height: 1,),
                              Text('Akash',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close,color: Colors.white60,size: 20,),
                        onPressed: close,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 40),
                    children: [
                      MenuItem(
                        icon: Icons.home,
                        title: 'Home',
                        onTap: (){
                          selectItem(0);
                        },
                      ),
                      MenuItem(
                        icon: Icons.show_chart,
                        title: 'Statistics',
                        onTap:  (){
                          selectItem(1);
                        },
                      ),
                      MenuItem(
                        icon: Icons.add_circle_outline,
                        title: 'Add Water',
                        onTap: (){
                          
                        },
                      ),
                      MenuItem(
                        icon: Icons.account_circle,
                        title: 'Account',
                        onTap: (){
                          selectItem(2);
                        },
                      ),
                      
                      MenuItem(
                        icon: Icons.exit_to_app,
                        title: 'Log Out',
                        onTap: (){
                          Provider.of<AuthProvider>(context,listen: false).signOut();
                          // Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                          ..scale(1.0-(0.2*_animationController.value))
                          ..translate(0.0,size.height*0.80*_animationController.value,0.0)
                          ..setEntry(3, 2, 0.002)
                          ..rotateX(0.15*_animationController.value),
                origin: Offset(0,0),
                alignment: Alignment.center,
                //child: child,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20*_animationController.value),
                  child: AbsorbPointer(
                    absorbing: _isDrawerOpened,
                    child: screens[screen],
                  ),
                )
              );
            },
            child: AbsorbPointer(
              absorbing: _isDrawerOpened,
              child: screens[screen],
            )
          )
        ]
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  MenuItem({this.icon,this.title,this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13,horizontal: 35),
        child: Row(
          children: [
            Icon(this.icon,color: Colors.white,size: 21,),
            SizedBox(width: 15,),
            Text(this.title,style: TextStyle(color: Colors.white,fontSize: 15),),
          ],
        ),
      ),
    );
  }
}