

// ignore_for_file: prefer_const_literals_to_create_immutabl, prefer_const_constructorses, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_scores/layout/home_layout.dart';
import 'package:football_scores/modules/login_screen/cubit/cubit.dart';
import 'package:football_scores/modules/login_screen/cubit/states.dart';
import 'package:football_scores/modules/register_screen/register_screen.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit , LoginStates>(
      listener: (context, state) {
        if(state is GetUserLoginSuccessState)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeLayout(),));
        }
        if(state is LoginErrorState)
        {
          ShowToast(message: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return  Scaffold(
          appBar: AppBar(),
          body: Container(
            color: Colors.grey[100],
            height: double.infinity,
            child:
            Padding(
              padding: const EdgeInsets.only(left:  10, right: 10),
              child:
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key : formKey,
                  child: Column(
                    children: [
                      Image(
                          width: double.infinity,
                          image: AssetImage('assets/images/home_logo.png')),
                      SizedBox(
                        height: 90,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sign in to your account' , style: TextStyle(
                              color: Colors.black,
                              fontSize: 25
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          defaultformField(
                              validate: (value)
                              {
                                if(value!.isEmpty)
                                {
                                  return "Email can't be Empty";
                                }
                                else if (!value.contains('@'))
                                {
                                  return "Wrong format for Email";
                                }
                              },
                              prefix: IconBroken.Message,
                              lable: 'Email', controller: emailController, type: TextInputType.emailAddress),
                          SizedBox(
                            height: 20,
                          ),
                          defaultformField(
                              validate: (value )
                              {
                                if(value!.isEmpty)
                                {
                                  return "Password can't be Empty";
                                }
                              },
                              isPassword: cubit.isPass,
                              suffix: cubit.isPass ? Icons.visibility_outlined : Icons.visibility_off_outlined ,
                              suffixpressed: ()
                              {
                                cubit.changePasswordSuffix();
                              },
                              prefix: IconBroken.Password,
                              lable: 'Password', controller: passwordController, type: TextInputType.emailAddress),
                                  SizedBox(
                                    height: 20,
                                  ),
                          ConditionalBuilder(condition: state is! LoginSuccessState && state is! LoginLoadingState,
                            builder: (context) {
                              return
                                defultButton(function: ()
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    cubit.UserLogin(email: emailController.text, password: passwordController.text);
                                  }
                                }, Name: 'Login');
                            }, fallback: (context) {
                              return Center(child: CircularProgressIndicator(),);
                            },),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                  onPressed: ()
                                  {
                                    NavigateTo(context, RegisterScreen());
                                  }, child: Text('Join us' , style: TextStyle(
                              ),)),
                            ],
                          ),
                          Text('Or sign in with : '),
                          SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 7,
                            child: IconButton(
                              onPressed: ()
                              {
                                cubit.signInWithGoogle().then((value)
                                {
                                  if(userModel != null)
                                    {
                                      NavigateTo(context , HomeLayout());
                                    }
                                }).catchError((onError)
                                {
                                  print('Error : ${onError}');
                                });
                              },
                              icon: FaIcon(FontAwesomeIcons.google),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
