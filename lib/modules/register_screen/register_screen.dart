import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/layout/home_layout.dart';
import 'package:football_scores/modules/register_screen/cubit/cubit.dart';
import 'package:football_scores/modules/register_screen/cubit/states.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class RegisterScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          showToast(
              message: 'Registered Successfully', state: ToastStates.SUCCESS);
          AppCubit.get(context).getLeagues().then((value) {
            AppCubit.get(context).getMatches(39).then((value) {
              navigateTo(context, const HomeLayout());
            });
          });
        }
        if (state is RegisterErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(IconBroken.Arrow___Left),
            ),
          ),
          body: Container(
            color: Colors.grey[100],
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
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
                      const Text(
                        'Create an Account',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultformField(
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Name can't be Empty";
                            }
                            return null;
                          },
                          prefix: IconBroken.User,
                          lable: 'Name',
                          controller: nameController,
                          type: TextInputType.text),
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
                        height: 40,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) {
                          return defultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      email: emailController.text,
                                      name: nameController.text,
                                      password: passwordController.text);
                                }
                              },
                              name: 'Register');
                        },
                        fallback: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
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
