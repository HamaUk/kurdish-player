import 'package:api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IptvCubit extends Cubit<List<Playlist>?> {
  IptvCubit([super.initialState]) {
    update();
  }

  static bool refreshed = false;

  Future<void> update() async {
    final playlists = await Api.playlistQueryAll();
    emit(playlists);
  }
}
