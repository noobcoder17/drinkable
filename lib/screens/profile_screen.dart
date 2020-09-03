import 'package:drinkable/models/app_user.dart';
import 'package:drinkable/providers/auth_provider.dart';
import 'package:drinkable/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../utils/time_converter.dart';
import '../widgets/custom_form_field.dart';

class ProfileScreen extends StatelessWidget {
  final Function openDrawer;
  ProfileScreen({
    this.openDrawer
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(openDrawer: openDrawer),
              Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  AppUser appUser = homeProvider.appUser;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appUser.name,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  appUser.email,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                             Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                User user = authProvider.user;
                                return CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(user.photoURL),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 50,),
                        DataEntryForm(appUser)
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DataEntryForm extends StatefulWidget {
  final AppUser appUser;
  DataEntryForm(this.appUser);
  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  TextEditingController _textEditingController;
  AppUser _appUser;
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _appUser = AppUser.fromDoc(widget.appUser.toDoc());
    _textEditingController = TextEditingController(text: _appUser.dailyTarget.toString());
  }

  void toggleLoading(){
    setState(() {
      _loading = !_loading;
    });
  }

  void submit()async{
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    toggleLoading();
    try{
      await Provider.of<HomeProvider>(context,listen: false).updateUser(_appUser);
    }catch(e){
      print(e);
    }
    toggleLoading();
  }

  void setWater({double weight}){
    if(_appUser.weight!=null || weight!=null){
      double calWater = weight!=null ? weight*2.205 : _appUser.weight*2.205;
      calWater = calWater/2.2;
      int age = DateTime.now().year-_appUser.birthday.year;
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
        _appUser.dailyTarget= calWater.toInt();
        _appUser.weight = weight==null? _appUser.weight : weight;
        _textEditingController.text = _appUser.dailyTarget.toString();
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
                    value: _appUser.gender,
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
                        _appUser.gender = gender;
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
                      initialDate:_appUser.birthday,
                      firstDate: DateTime(1960),
                      lastDate: DateTime(DateTime.now().year-12,12,31),
                    );
                    if(date!=null){
                      setState(() {
                        _appUser.birthday = date;
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
                          DateFormat.yMMMd('en_US').format(_appUser.birthday),
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
                    initialValue: _appUser.weight.toString(),
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
                        _appUser.wakeUpTime = time;
                      });
                    }
                  },
                  child: CustomFormField(
                    label: 'Wakes Up',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeConverter(_appUser.wakeUpTime),
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
              Expanded(
                flex: 2,
                child: CustomFormField(
                  label: 'Water',
                  child: TextFormField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '3200 mL',
                      suffixText: 'mL',
                    ),
                    style: TextStyle(
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
                    onChanged: (String value){
                      setState(() {
                        _appUser.dailyTarget = int.parse(value);
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
                  'Update',
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