import 'package:flutter_riverpod/flutter_riverpod.dart';

class Test {

  String language;

  Test({
    required this.language
  });


}

class TestNotifier extends StateNotifier<List<Test>> {

  String? token;

  TestNotifier({ required this.token }): super([]);

  void load() {
    print(token);
  }

}

final testProvider = StateNotifierProvider<TestNotifier, List<Test>>((ref) {

  final ap = ref.watch(authProvider);

  return TestNotifier(token: ap.token);
});


class Auth {
  String? token;
  Auth({
    required this.token
  });
}

class AuthNotifier extends StateNotifier<Auth> {
  AuthNotifier() : super(Auth(token: null));


  void setToken() {
    state = Auth(token: 'mytoken*123');
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, Auth>((ref) {
  

  return AuthNotifier();
});



