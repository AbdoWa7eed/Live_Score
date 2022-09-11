

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/user_model.dart';
import 'package:football_scores/modules/register_screen/cubit/states.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/cubit/cubit.dart';
import 'package:football_scores/shared/network/local/cache_helper.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(RegisterIntialState());
  bool isPass = true;
  static RegisterCubit get (context) => BlocProvider.of(context);
  void changePasswordSuffix()
  {
    isPass = !isPass;
    emit(ChangeSuffixState());
  }
  void userRegister({
    required String name,
    required String email,
    required String password,
  }) async
  {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
          var user = value;
      UserCreate(email: email, name: name, uid: value.user!.uid).then((value) async
      {
        await getUserData(user.user!.uid);
      });
    }).catchError((onError) {
      print("Error While Registering :${onError.toString()}");
      emit(RegisterErrorState(onError.toString()));
    });
  }
  Future<void> UserCreate({
    required String email,
    required String name,
    required String uid,
  }) async {
    UserModel? model = UserModel(
        email: email,
        name: name,
        uid: uid,
        image:
        'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?w=740&t=st=1660748706~exp=1660749306~hmac=23fc25de06d2ebeaa9c9db3c14fc2d58f9ba758d866025b1072e5c9b4f0b8b6b',);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      CacheHelper.putData(
        key: 'uid',
        value: uid,
      ).then((value)
      {
        print('user Created');
        emit(CreateUserSuccessState());
      }).catchError((onError)
      {});
    }).catchError((onError) {
      print('Error While Creating : ${onError.toString()}');
      emit(CreateUserErrorState(onError.toString()));
    });
  }

  Future<void> getUserData(uid)  async{
    emit(RegisterLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      UID = value.data()?['uid'];
      value.data() != null
          ? userModel = UserModel.fromjson(value.data()!)
          : userModel = null;
      print("HAHAHAHAHAH : $userModel");
      emit(RegisterSuccessState());
    }).catchError((onError) {
      print('Error While Getting : ${onError}');
      RegisterErrorState(onError.toString());
    });
  }

}