import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:seller_app/const/const.dart';
import 'package:seller_app/const/firebase_consts.dart';

class AuthController extends GetxController {
  // Explicitly typed RxBool
  RxBool isLoading = false.obs;

  // Explicitly typed TextEditingControllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Added BuildContext type and Future return type
  Future<UserCredential?> loginMethod({required BuildContext context}) async {
    UserCredential? userCredential;
    isLoading(true); // Start loading

    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = userCredential.user;
      if (user != null) {
        final ref = firestore.collection(vendorsCollection).doc(user.uid);
        final profile = await ref.get();
        if (!profile.exists) {
          await ref.set({
            'id': user.uid,
            'vendor_name':
                user.displayName ?? user.email?.split('@').first ?? 'Seller',
            'email': user.email,
            'imageUrl': '',
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    } finally {
      isLoading(false); // Stop loading regardless of success/fail
    }
    return userCredential;
  }

  // Added required String types for named parameters
  // Added BuildContext type
  Future<void> signoutMethod(BuildContext context) async {
    try {
      await auth.signOut();
    } catch (e) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<void> sendPasswordReset(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      VxToast.show(context, msg: 'Enter your email address first');
      return;
    }
    try {
      await auth.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: 'Password reset email sent');
    } on FirebaseAuthException catch (error) {
      // ignore: use_build_context_synchronously
      VxToast.show(context, msg: error.message ?? 'Could not send reset email');
    }
  }

  // FIX: Dispose of controllers when the controller is removed from memory
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
