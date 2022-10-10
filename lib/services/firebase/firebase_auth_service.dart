import 'package:firebase_auth/firebase_auth.dart';
import 'package:lugat_admin/services/base/i_base_auth_service.dart';

/// Created by Yunus Emre Yıldırım
/// on 6.10.2022

class FirebaseAuthService implements IBaseAuthService {
  late FirebaseAuth user;

  FirebaseAuthService() {
    user = FirebaseAuth.instance;
  }

  @override
  Future<dynamic> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await user.signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (_) {
      throw FirebaseAuthService();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await user.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> isUserSignIn() async {
    if (user.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }
}
