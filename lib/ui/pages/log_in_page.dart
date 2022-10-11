import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'OSMANLICA SÖZLÜK',
      messages: LoginMessages(
        userHint: 'Email ...',
        passwordHint: 'Şifre ...',
        loginButton: 'Giriş yap',
        flushbarTitleError: 'HATA!',
      ),
      theme: LoginTheme(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.lightBlue,
        titleStyle: const TextStyle(
          fontSize: 44,
        ),
      ),
      // logo: const AssetImage('images/lugat64.png'),
      onLogin: _authUser,
      userValidator: _userValidator,
      passwordValidator: _passwordValidator,
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () => Get.offAndToNamed('/'),
    );
  }

  Future<String?>? _authUser(LoginData loginData) {
    return Future.delayed(loginTime).then((_) async {
      try {
        UserCredential credential = await serviceAuth.signInWithEmailAndPassword(loginData.name, loginData.password);
        debugPrint('Giriş yapan kullanıcı bilgileri: ${credential.user?.email}');
      } on FirebaseAuthException catch (_) {
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
    } else if (value != null && !emailRegExp.hasMatch(value)) {
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

  RegExp get emailRegExp => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}
