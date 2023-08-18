// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_scores/models/user_model.dart';
import 'package:football_scores/modules/login_screen/cubit/states.dart';
import 'package:football_scores/shared/components/constants.dart';
import 'package:football_scores/shared/network/local/cache_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginIntialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPass = true;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  void changePasswordSuffix() {
    isPass = !isPass;
    emit(ChangeSuffixState());
  }

  Future<void> userLogin({
    required String email,
    required String password,
    required Function() onSuccess,
  }) async {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await CacheHelper.putData(key: 'uid', value: value.user!.uid);
      UID = value.user!.uid;
      userModel = UserModel(
        name: value.user!.displayName,
        email: value.user!.email,
      );
      emit(LoginSuccessState());
      await getUserData(value.user!.uid).then((value) {
        onSuccess.call();
      });
    }).catchError((onError) {
      print('Error While Signing In : $onError ');
      emit(LoginErrorState(onError.message.toString()));
    });
  }

  Future<void> signInWithGoogle({required Function() onSuccess}) async {
    emit(LoginLoadingState());
    GoogleSignInAuthentication? googleSignInAuthentication;
    _googleSignIn.signIn().then((value) {
      if (value == null) {
        emit(LoginErrorState('Please add an account'));
        return;
      }
      value.authentication.then((value) async {
        googleSignInAuthentication = value;
        AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication?.accessToken,
            idToken: googleSignInAuthentication?.idToken);
        await FirebaseAuth.instance
            .signInWithCredential(authCredential)
            .then((value) async {
          UserCredential user = value;
          await userCreate(
              image: user.user!.photoURL!,
              email: user.user!.email!,
              name: user.user!.displayName!,
              uid: user.user!.uid);
          emit(LoginSuccessState());
          await getUserData(user.user!.uid).then((value) async {
            await CacheHelper.putData(key: "googleSignIn", value: true);
            onSuccess.call();
          });
        }).catchError((onError) {
          print('Error : $onError');
          emit(LoginErrorState(onError.message.toString()));
        });
      });
    }).catchError((onError) {
      print('Error : $onError');
      emit(LoginErrorState(onError.toString()));
    });
  }

  Future<void> userCreate({
    required String email,
    required String name,
    required String uid,
    String? image,
  }) async {
    UserModel? model = UserModel(
      email: email,
      name: name,
      uid: uid,
      image: image ??
          'https://img.freepik.com/free-vector/illustration-user-avatar-icon_53876-5907.jpg?w=740&t=st=1660748706~exp=1660749306~hmac=23fc25de06d2ebeaa9c9db3c14fc2d58f9ba758d866025b1072e5c9b4f0b8b6b',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) async {
      CacheHelper.putData(
        key: 'uid',
        value: uid,
      ).then((value) {
        print('user Created');
      }).catchError((onError) {});
      await getUserData(uid);
      emit(CreateUserLoginSuccessState());
    }).catchError((onError) {
      print('Error While Creating : ${onError.toString()}');
      emit(CreateUserLoginErrorState(onError.toString()));
    });
  }

  Future<void> signOut() async {
    bool isGoogleSignIn = CacheHelper.getData("googleSignIn") ?? false;
    if (isGoogleSignIn) {
      _googleSignIn.signOut().then((value) {
        print("Google Sign out");
      }).catchError((onError) {
        print('Error While Signing Out : $onError ');
      });
      await CacheHelper.removeData(key: 'googleSignIn');
    }
    await CacheHelper.removeData(key: 'uid');
    print('sign Out');
  }

  Future<void> getUserData(uid) async {
    emit(GetUserLoginLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      print(uid);
      value.data() != null
          ? userModel = UserModel.fromjson(value.data()!)
          : userModel = null;
      print(userModel);
      emit(GetUserLoginSuccessState());
    }).catchError((onError) {
      print('Error While Getting : $onError');
      GetUserLoginErrorState(onError.toString());
    });
  }
}
