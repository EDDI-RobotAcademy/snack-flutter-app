import 'fetch_user_info_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FetchGoogleUserInfoUseCaseImpl implements FetchGoogleUserInfoUseCase {
  @override
  Future<GoogleSignInAccount> execute() async {
    final account = await GoogleSignIn().signIn();
    if (account != null) {
      return account;
    } else {
      throw Exception("Google 사용자 정보를 가져올 수 없습니다.");
    }
  }
}