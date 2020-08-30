import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';


class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Location _location;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    //_location = Location();
    init();
  }

  void toggleLoading(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }
  
  // void getLocation()async{
  //   bool isServiceEnabled = await _location.serviceEnabled();
  //   if(!isServiceEnabled){
  //     bool _enabled = await _location.requestService();
  //     if (_enabled) {
  //       print('Service is enables');
  //     }else{
  //       return;
  //     }
  //   }
  //   print('Service is already enables');

  //   PermissionStatus permissionGranted = await _location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     PermissionStatus _isGranted = await _location.requestPermission();
  //     if (_isGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }

  //   LocationData _locationData = await _location.getLocation();
  //   print(_locationData.latitude);
  //   print(_locationData.longitude);
  // }

  void init() async {
    toggleLoading();
    await Provider.of<HomeProvider>(context,listen: false).init();
    toggleLoading();
  }

  // void week(){
  //   DateTime stateDate = DateTime(2019,1,1);
  //   int weekday = stateDate.weekday;
  //   print('weekday $weekday');

  //   DateTime today = DateTime(2019,2,4);
  //   int day = today.difference(stateDate).inDays; 
  //   print('Total days ${day+1}');
  //   print('Week is ${((weekday+day)/7).ceil()}');
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: _isLoading ? CircularProgressIndicator() : RaisedButton(
          child: Text('Get week'),
          onPressed: (){
          },
        ),
      ),
      
    );
  }
}


// class TestScreen extends StatefulWidget {
//   @override
//   _TestScreenState createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> with SingleTickerProviderStateMixin {
//   AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 3),
//       lowerBound: 0,
//       upperBound: 1
//     );
//     _animationController.repeat();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return AnimatedBuilder(
//               animation: _animationController,
//               builder: (context, child) {
//                 List<Offset> points1 = [];
//                 List<Offset> points2 = [];
//                 for(double i=0;i<=constraints.maxWidth;i++){
//                   double val = 20*sin(2*pi*(_animationController.value + (i/constraints.maxWidth)));
//                   double val2 = 20*sin(2*pi*(_animationController.value + (1-(i/constraints.maxWidth))));
//                   points1.add(Offset(i,constraints.maxWidth-20+val));
//                   points2.add(Offset(constraints.maxWidth - i,20+val2));
//                 } 
//                 return ClipPath(
//                   clipper: MyClip(points1,points2),
//                   child: Container(
//                     width: constraints.maxWidth,
//                     height: constraints.maxWidth,
//                     color: Colors.blue,
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
      
//     );
//   }
// }

// class MyClip extends CustomClipper<Path> {
//   List<Offset> offsets1;
//   List<Offset> offsets2;
//   MyClip(this.offsets1,this.offsets2);
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(offsets1[0].dx,offsets1[0].dy);
//     path.addPolygon(offsets1, false);
//     //path.lineTo(size.width, size.height);
//     path.lineTo(offsets2[0].dx,offsets2[0].dy);
//     path.addPolygon(offsets2, false);
//     path.lineTo(offsets2[offsets2.length-1].dx,offsets2[offsets2.length-1].dy);
//     path.lineTo(offsets1[0].dx,offsets1[0].dy);
//     //path.lineTo(0, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;

// }