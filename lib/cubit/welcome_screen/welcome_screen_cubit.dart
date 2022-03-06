import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:bigpay_app003/data/storage.dart';
import 'package:bigpay_app003/services/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'welcome_screen_state.dart';

class WelcomeScreenCubit extends Cubit<WelcomeScreenState> {
  final Storage _storage;
  final AuthService _authService;
  WelcomeScreenCubit({Storage? storage, AuthService? authService})
      : _storage = storage ?? Storage(),
        _authService = authService ?? AuthService(),
        super(WelcomeScreenInitial());

  Future<void> loadSnapshots() async {
    try {
      emit(WelcomeScreenLoading());
      final identityId = await _authService.getIdentityId();

      if (identityId == null) {
        throw Exception();
      }

      final snapshots = await _storage.listFiles(identityId);
      emit(WelcomeScreenSnapshots(snapshots));
    } catch (e) {
      emit(WelcomeScreenError());
    }
  }
}
