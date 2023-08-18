import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/main.dart';
import 'package:football_scores/modules/login_screen/cubit/cubit.dart';
import 'package:football_scores/shared/components/components.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/cubit/states.dart';
import 'package:football_scores/shared/styles/colors/colors.dart';
import 'package:football_scores/shared/styles/icon_broken.dart';

class ProfileScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateUserSuccessState) {
          showToast(
              message: "Updated Successfully", state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        emailController.text = userModel!.email!;
        nameController.text = userModel!.name!;
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(IconBroken.Arrow___Left),
              onPressed: () {
                cubit.myImage = null;
                Navigator.pop(context);
              },
            ),
            title: const Text('Edit Profile'),
          ),
          body: Container(
            color: Colors.grey[100],
            child: Center(
              child: Column(
                children: [
                  if (state is UpdateUserLoadingState) ...[
                    const LinearProgressIndicator(),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                backgroundColor: premierColor,
                                radius: 51,
                                child: Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: cubit.myImage == null
                                      ? buildImage(userModel!.image!)
                                      : Image(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                          image: FileImage(cubit.myImage!)),
                                ),
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: premierColor,
                                child: IconButton(
                                    icon: const Icon(IconBroken.Camera,
                                        size: 20, color: Colors.white),
                                    onPressed: () {
                                      cubit.getImage();
                                    }),
                              ),
                            ]),
                        const SizedBox(
                          height: 50,
                        ),
                        defaultformField(
                            prefix: IconBroken.User,
                            lable: 'Name',
                            controller: nameController,
                            type: TextInputType.text),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultformField(
                            prefix: IconBroken.Message,
                            lable: 'Email',
                            controller: emailController,
                            type: TextInputType.emailAddress),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            defultButton(
                                width: 100,
                                function: () {
                                  if (cubit.myImage == null) {
                                    cubit.updateData(
                                        name: nameController.text,
                                        email: emailController.text);
                                  } else {
                                    cubit.updateData(
                                        name: nameController.text,
                                        email: emailController.text,
                                        image: cubit.myImage!.path);
                                  }
                                },
                                name: 'Update'),
                            const Spacer(),
                            defultButton(
                                width: 100,
                                function: () {
                                  LoginCubit.get(context)
                                      .signOut()
                                      .then((value) {
                                    userModel = null;
                                    UID = null;
                                    navigateAndFinish(context, const MyApp());
                                  });
                                },
                                name: 'Logout'),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
