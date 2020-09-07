import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

// providers
import '../providers/auth_provider.dart';

// screens
import '../screens/profile_screen.dart';
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
      duration: Duration(milliseconds: 350),
    );
    changeStatusBar(false);
  }

  void changeStatusBar(bool isOpened){
    if(isOpened){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light    
      ));
    }else{
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,    
      ));
    }
  }

  void open(){
    changeStatusBar(true);
    _animationController.forward();
    setState(() {
      _isDrawerOpened = true;
    });
  }

  void close()async{
    await _animationController.reverse();
    changeStatusBar(false);
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
              vertical: 35
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, value, child) {
                          User user = value.user;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(user.photoURL),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello',style:  GoogleFonts.poppins(color: Colors.white54,fontSize: 14),),
                                  SizedBox(height: 1,),
                                  Text(user.displayName.split(' ')[0],style:  GoogleFonts.poppins(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500))
                                ],
                              )
                            ],
                          );
                        },
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
                        icon: Icons.account_circle,
                        title: 'Profile',
                        onTap: (){
                          selectItem(2);
                        },
                      ),
                      
                      MenuItem(
                        icon: Icons.exit_to_app,
                        title: 'Log Out',
                        onTap: (){
                          Provider.of<AuthProvider>(context,listen: false).signOut();
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
                
                // comment the child and uncomment the commented child to get the curved app drawer
                child: child,
                // child: ClipRRect(
                //   borderRadius: BorderRadius.circular(20*_animationController.value),
                //   child: AbsorbPointer(
                //     absorbing: _isDrawerOpened,
                //     child: screens[screen],
                //   ),
                // )
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
            Text(this.title,style:  GoogleFonts.poppins(color: Colors.white,fontSize: 14),),
          ],
        ),
      ),
    );
  }
}