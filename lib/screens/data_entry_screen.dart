import 'package:drinkable/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../utils/time_converter.dart';

class DataEntryScreen extends StatelessWidget {
  static const routeName = 'data-entry-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(30,30, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios)
                  )
                ],
              ),
              SizedBox(height: 20,),
              Column(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(height: 10,),
                  Text('About you',style: TextStyle(fontSize: 23),),
                  SizedBox(height: 20,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 270
                    ),
                    child: Text(
                      'This information will let us help to calculate your daily recommended water intake amount and remind you to drink water in intervals.',
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.60),
                          height: 1.4
                        ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      GoogleSignInAccount googleAccount = authProvider.googleAcount;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(googleAccount.photoUrl),
                            ),
                            SizedBox(height: 15,),
                            Text('${googleAccount.email}'),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 50,),
              DataEntryForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class DataEntryForm extends StatefulWidget {
  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void toggleLoading(){
    setState(() {
      _loading = !_loading;
    });
  }

  // data
  String _gender = 'male';
  DateTime _birthday = DateTime(1997,4,1);
  double _weight;
  TimeOfDay _wakeUpTime = TimeOfDay(hour: 8, minute: 0);

  void submit()async{
    if(!_formKey.currentState.validate()){
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 47,
                child: CustomFormField(
                  label: 'Gender',
                  child: DropdownButtonFormField<String>(
                    value: _gender,
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem(
                        child: Text('Male',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),),
                        value: 'male',
                      ),
                      DropdownMenuItem(
                        child: Text('Female',style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),),
                        value: 'female',
                      ),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none
                    ),
                    onChanged: (String gender){
                      setState(() {
                        _gender = gender;
                      });
                    },
                  ),
                )
              ),
              Expanded(
                flex: 6,
                child: SizedBox(height: 20,)
              ),
              Expanded(
                flex: 47,
                child: GestureDetector(
                   onTap: ()async{
                    DateTime date = await showDatePicker(
                      context: context,
                      initialDate:DateTime(1997,4,1),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(DateTime.now().year-12,12,31),
                    );
                    print(date);
                  },
                  child: CustomFormField(
                    label: 'Birthday',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd('en_US').format(_birthday),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )
                  ),
                )
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Expanded(
                flex: 47,
                child: CustomFormField(
                  label: 'Weight',
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '60 kg',
                      suffixText: 'kg',
                    ),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter weight';
                      }
                      if(double.parse(value)<40){
                        return 'You are underweight';
                      }
                      return null;
                    },
                  ),
                )
              ),
              Expanded(
                flex: 6,
                child: SizedBox(height: 20,),
              ),
              Expanded(
                flex: 47,
                child: GestureDetector(
                   onTap: ()async{
                    TimeOfDay time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: 8, minute: 0),
                    );
                    if(time!=null){
                      setState(() {
                        _wakeUpTime = time;
                      });
                    }
                  },
                  child: CustomFormField(
                    label: 'Wakes Up',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeConverter(_wakeUpTime),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ) 
                  ),
                )
              ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                elevation: 1,
                color: Color.fromARGB(255, 0, 60, 192),

                child: _loading ? SizedBox(
                  height: 22,width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                ) : Text(
                  'Let\'t go',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 12
                  ),
                ),

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                onPressed: (){
                  //toggleLoading();
                  submit();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  final String label;
  final Widget child;
  CustomFormField({this.child,this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.yellow,
      height: 60,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(top: 6),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.3),width: 1.1),
              borderRadius: BorderRadius.circular(4)
            ),
            alignment: Alignment.centerLeft,
            child: child
          ),
          Positioned(
            left: 14,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                ),
              )
            ),
          )
        ],
      ),
    );
  }
}

// RaisedButton(
//           child: Text('Lest go'),
//           onPressed: ()async{
//             await Provider.of<AuthProvider>(context,listen: false).signUp();
//             Navigator.of(context).pop();
//           },
//         ),