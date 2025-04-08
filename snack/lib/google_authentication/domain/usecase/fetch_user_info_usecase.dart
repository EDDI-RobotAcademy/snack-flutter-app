import 'package:google_sign_in/google_sign_in.dart';

abstract class FetchGoogleUserInfoUseCase {
  Future<GoogleSignInAccount> execute();
}