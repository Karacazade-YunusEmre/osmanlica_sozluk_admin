import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lugat_admin/ui/pages/home_page.dart';

import '../../main.dart';

/// Created by Yunus Emre Yıldırım
/// on 24.08.2022

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController textControllerEmail;
  late TextEditingController textControllerPassword;
  late FocusNode focusNode;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();

    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textControllerEmail.dispose();
    textControllerPassword.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Giriş Yap'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 0.3.sw,
          height: 0.3.sh,
          color: Colors.blue.shade400.withOpacity(0.5),
          padding: EdgeInsets.all(60.0.sp),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textControllerEmail,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Email adresinizi girin',
                      label: Text('Email'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return 'Email alanı boş bırakılamaz';
                      } else if (value != null && !EmailValidator.validate(value)) {
                        return 'Email doğru formatta değil';
                      }
                      return null;
                    },
                    onSaved: (String? value) => email = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: textControllerPassword,
                    decoration: const InputDecoration(
                      hintText: 'Şifrenizi girin',
                      label: Text('Şifre'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    obscureText: true,
                    validator: (String? value) {
                      if (value != null && value.isEmpty) {
                        return 'Şifre alanı boş olamaz';
                      } else if (value != null && value.length < 3) {
                        return 'Şifre en az 3 karakter olmalıdırç';
                      }
                      return null;
                    },
                    onSaved: (String? value) => password = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: const Text('Giriş Yap'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        loginWithEmailPassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginWithEmailPassword() async {
    try {
      final credential = await user.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('Giriş Yapan Kullanıcı bilgileri: ${credential.additionalUserInfo}');
      Get.to(() => const HomePage());
      Get.snackbar('', 'Oturum açma işlemi başarılı.');
    } on FirebaseAuthException catch (e) {
      debugPrint('email veya şifre hatalı. $e');
      Get.snackbar('HATA', 'Email veya Şifre hatalı. Lütfen tekrar deneyin');
      textControllerEmail.clear();
      textControllerPassword.clear();
      focusNode.nextFocus();
    } catch (e) {
      debugPrint('hata çıktı: ${e.toString()}');
    }
  }
}
