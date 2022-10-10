/// Created by Yunus Emre Yıldırım
/// on 6.10.2022

abstract class IBaseAuthService {
  Future<dynamic> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<bool> isUserSignIn();
}
