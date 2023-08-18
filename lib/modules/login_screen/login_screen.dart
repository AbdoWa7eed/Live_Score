import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_scores/layout/home_layout.dart';
import 'package:football_scores/modules/login_screen/cubit/cubit.dart';
import 'package:football_scores/modules/login_screen/cubit/states.dart';
import 'package:football_scores/modules/register_screen/register_screen.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            color: Colors.grey[100],
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const Image(
                          width: double.infinity,
                          image: AssetImage('assets/images/home_logo.png')),
                      const SizedBox(
                        height: 90,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign in to your account',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultformField(
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Email can't be Empty";
                                } else if (!value.contains('@')) {
                                  return "Wrong format for Email";
                                }
                                return null;
                              },
                              prefix: IconBroken.Message,
                              lable: 'Email',
                              controller: emailController,
                              type: TextInputType.emailAddress),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultformField(
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return "Password can't be Empty";
                                }
                                return null;
                              },
                              isPassword: cubit.isPass,
                              suffix: cubit.isPass
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              suffixpressed: () {
                                cubit.changePasswordSuffix();
                              },
                              prefix: IconBroken.Password,
                              lable: 'Password',
                              controller: passwordController,
                              type: TextInputType.emailAddress),
                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginSuccessState &&
                                state is! LoginLoadingState,
                            builder: (context) {
                              return defultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        onSuccess: () {
                                          navigateTo(
                                              context, const HomeLayout());
                                        },
                                      );
                                    }
                                  },
                                  name: 'Login');
                            },
                            fallback: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    navigateTo(context, RegisterScreen());
                                  },
                                  child: const Text(
                                    'Join us',
                                    style: TextStyle(),
                                  )),
                            ],
                          ),
                          const Text('Or sign in with : '),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 7,
                            child: IconButton(
                              onPressed: () {
                                cubit.signInWithGoogle(
                                  onSuccess: () {
                                    navigateTo(context, const HomeLayout());
                                  },
                                );
                              },
                              icon: const FaIcon(FontAwesomeIcons.google),
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
