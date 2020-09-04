import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// providers
import '../providers/auth_provider.dart';

// utils
import '../utils/time_converter.dart';

// widgets
import '../widgets/custom_form_field.dart';


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
                  Text('About you',style:  GoogleFonts.poppins(fontSize: 22,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 270
                    ),
                    child: Text(
                      'This information will let us help to calculate your daily recommended water intake amount and remind you to drink water in intervals.',
                      textAlign: TextAlign.center,
                        style:  GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.60),
                          height: 1.4,
                          fontWeight: FontWeight.w400
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
                            Text(
                              '${googleAccount.email}',
                              style: GoogleFonts.poppins(
                                fontSize: 13
                              ),
                            ),
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
  int _water = 3200;


  void submit()async{
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    toggleLoading();
    try{
      await Provider.of<AuthProvider>(context,listen: false).signUp(
        _gender,
        _birthday,
        _weight,
        _wakeUpTime,
        _water
      );
      Navigator.of(context).pop();
      return;
    }catch(e){
      print(e);
    }
    toggleLoading();
  }

  void setWater({double weight}){
    if(_weight!=null || weight!=null){
      double calWater = weight!=null ? weight*2.205 : _weight*2.205;
      calWater = calWater/2.2;
      int age = DateTime.now().year-_birthday.year;
      if(age<30){
        calWater = calWater*40;
      }else if(age>=30 && age<=55){
        calWater = calWater*35;
      }else{
        calWater = calWater*30;
      }
      calWater = calWater/28.3;
      calWater = calWater*29.574;
      setState(() {
        _water = calWater.toInt();
        _weight = weight==null? _weight : weight;
      });
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
                        child: Text('Male',style:  GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),),
                        value: 'male',
                      ),
                      DropdownMenuItem(
                        child: Text('Female',style:  GoogleFonts.poppins(
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
                child: SizedBox(width: 20,)
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
                    if(date!=null){
                      setState(() {
                        _birthday = date;
                      });
                      setWater();
                    }
                  },
                  child: CustomFormField(
                    label: 'Birthday',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd('en_US').format(_birthday),
                          style:  GoogleFonts.poppins(
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
                    style:  GoogleFonts.poppins(
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
                    onChanged: (String value){
                      setWater(weight: double.parse(value));
                    },
                  ),
                )
              ),
              Expanded(
                flex: 6,
                child: SizedBox(width: 20,),
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
                          style:  GoogleFonts.poppins(
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
              Expanded(
                flex: 2,
                child: CustomFormField(
                  label: 'Water',
                  child: TextFormField(
                    controller: TextEditingController(text: '$_water'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '3200 mL',
                      suffixText: 'mL',
                    ),
                    style:  GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter water amount';
                      }
                      if(double.parse(value)<1600){
                        return 'Less than min water';
                      }
                      return null;
                    },
                    onSaved: (String value){
                      setState(() {
                        _water = int.parse(value);
                      });
                    },
                  ),
                )
              ),
              Expanded(
                child: SizedBox(width: 0,),
              ),
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
                  style:  GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 13
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