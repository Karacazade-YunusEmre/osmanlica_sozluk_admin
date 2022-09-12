import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../utilities/custom_class/utilities_class.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'LUGAT',
      messages: LoginMessages(
        userHint: 'Email ...',
        passwordHint: 'Şifre ...',
        loginButton: 'Giriş yap',
        flushbarTitleError: 'HATA!',
      ),
      theme: LoginTheme(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.lightBlue,
      ),
      logo: const AssetImage('images/lugat64.png'),
      onLogin: _authUser,
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () => Get.offAndToNamed('/'),
    );
  }

  Future<String?>? _authUser(LoginData loginData) {
    debugPrint('Name: ${loginData.name}, Password: ${loginData.password}');

    return Future.delayed(loginTime).then((_) async {
      try {
        final credential = await user.signInWithEmailAndPassword(email: loginData.name, password: loginData.password);
        debugPrint('Giriş Yapan Kullanıcı bilgileri: ${credential.additionalUserInfo}');
      } on FirebaseAuthException catch (e) {
        debugPrint('email veya şifre hatalı. ${e.toString()}');
        return 'Email veya Şifre hatalı';
      } catch (e) {
        debugPrint('Firebase oturum hatası: ${e.toString()}');
      }

      return null;
    });
  }

  Future<String?>? _recoverPassword(String p1) {
    return null;
  }

  String? _userValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Email alanı boş geçilemez';
    } else if (value != null && !UtilitiesClass.emailRegExp.hasMatch(value)) {
      return 'Geçersiz email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Şifre alanı boş geçilemez';
    }
    return null;
  }
}
