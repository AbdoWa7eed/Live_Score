
// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:football_scores/models/match_model.dart';
import 'package:football_scores/modules/states_screen/states_screen.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:hexcolor/hexcolor.dart';

Widget defaultformField({
  required String lable,
  required TextEditingController controller,
  FormFieldValidator<String>? validate,
  required TextInputType? type,
  bool isPassword = false,
  ValueChanged<String>? onSubmit,
  IconData? prefix,
  IconData? suffix,
  ValueChanged<String>? onChange,
  VoidCallback? suffixpressed,
  GestureTapCallback? onTap,
  bool? isClickable = true,
}) =>
    TextFormField(
      cursorWidth: 1,
      controller: controller,
      enabled: isClickable,
      validator: validate,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      obscureText: isPassword,
      keyboardType: type,
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        suffixIcon: suffix != null
            ? IconButton(icon: Icon(suffix), onPressed: suffixpressed)
            : null,
        suffixIconColor: defaultColor,
        labelText: lable,
        prefixIcon: Icon(prefix),
        fillColor: defaultColor,
        border: OutlineInputBorder(),
        errorBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: defaultColor!, width: 1.3),
        ),
        focusedErrorBorder:OutlineInputBorder(
          borderSide:  BorderSide(color: defaultColor!, width: 1.3),
        ),
        errorStyle: TextStyle(
            color: defaultColor
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: premierColor!, width: 1.3),
        ),
      ),
      onTap: onTap,
    );

Widget defultButton(
    {double width = double.infinity,
      bool isUpper = true,
      double raduis = 0.0,
      required VoidCallback? function,
      required String Name}) =>
    Container(
      height: 40.0,
      width: width,
      child: MaterialButton(
        elevation: 5,
        color: premierColor,
        onPressed: function,
        child: Text(
          isUpper ? Name.toUpperCase() : Name,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
      ),
    );
MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

void ShowToast({required String message, required ToastStates state}) {
  Color? color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red[800];
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}
enum ToastStates { SUCCESS, ERROR, WARNING }

void NavigateTo(context , screen)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return screen;
  },));
}
Widget buildMatchItem(cubit, Response model , int index , context)
{
  double elevation = cubit.MatchIndex == index ? 8 : 0;
  Color color = cubit.MatchIndex == index ? Colors.white: Colors.white70;
  return InkWell(
    onTap: ()
    {
      cubit.changeMatchIndex(index);
    },
    child: Card(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 75,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text('${model.teams!.home!.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87 , fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    buildImage('${model.teams!.home!.logo}' , hight: 40 , width: 40),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppCubit.get(context).formatTime(model),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.deepOrange , fontWeight: FontWeight.bold
                        )),
                    Text(AppCubit.get(context).formatDate(model),
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey , fontWeight: FontWeight.bold
                        )),
                  ],),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    buildImage('${model.teams!.away!.logo}' , width: 40 , hight: 40),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('${model.teams!.away!.name}',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87 , fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
Widget buildLiveMatchItem(AppCubit cubit , context ,Response model)
{

  return InkWell(
    onTap: ()
    {
      //  cubit.getLineUp(867996);
      cubit.getStats(model.fixture!.id!).then((value)
      {
        cubit.getLineUp(model.fixture!.id!).then((value)
        {
          cubit.getEvents(model.fixture!.id!).then((value)
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StatsScreen(model),));
          });
        });
      });
      print("Id : ${model.fixture!.id}");
      print("team : ${model.teams!.home!.id}");
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Container(
            height: 200,
            width: 300,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: premierColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  Center(
                    child: Column(
                      children: [
                        Text('${model.league!.name}',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline6!.copyWith(
                              height: 1.2,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 0,
                        ),
                        Text('${model.league!.round}' , style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 16,
                            color: Colors.grey[500]
                        ))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      buildMatchTeamItem('${model.teams?.home?.logo}'
                          ,'${model.teams?.home?.name}','Home'),
                      Expanded(
                        child: Column(
                          children: [
                            Text('${model.goals!.home} : ${model.goals!.away}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.white
                              ),),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.pinkAccent,
                                ),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color.fromARGB(255,102,53,102),
                                ),
                                Text(model.fixture!.status!.short != 'HT'? "${model.fixture!.status!.elapsed}'" : "HT" , style: TextStyle(
                                    color: Colors.white
                                ),)
                              ],
                            )
                          ],
                        ),
                      ),
                      buildMatchTeamItem('${model.teams?.away?.logo}'
                          ,'${model.teams?.away?.name}','Away'),
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    ),
  );
}
Widget buildMatchTeamItem(String url , String name ,String state )
{
  return Expanded(
    child: Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        buildImage(url , width: 60 , hight: 60),
        SizedBox(
          height: 10,
        ),
        Text(name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.1
          ),),
        SizedBox(
          height: 10,
        ),
        Text(state ,
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[500],
              height: 1.1
          ),)
      ],
    ),
  );
}

Widget buildImage(String url , { double width = 100 , double hight = 100 , BoxFit fit = BoxFit.cover} ) {
  return Image.network(
    url,
    height: hight ,
    width: width,
    fit: fit,
    errorBuilder: (context, error, stackTrace) {
      print(error);
      return Image(
        height: hight,
        width: width,
        fit: fit,
        image: AssetImage('assets/images/error.png'),);
    },
    loadingBuilder: (BuildContext context, Widget child,
        ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child:
        Container(
          height: hight,
          width: width,
          child: CircularProgressIndicator(
            color: premierColor,
            value: loadingProgress.expectedTotalBytes !=
                null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                    .toInt()
                : null,
          ),
        ),
      );
    },
  );
}
void NavigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    return widget;
  }), (rout) => false);
}