import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UsersNotifier extends StateNotifier<List<User>> {

  Ref ref;

  UsersNotifier(this.ref): super([]);


  


}

final usersProvider = StateNotifierProvider<UsersNotifier, List<User>>((ref) {

  return UsersNotifier(ref);

});