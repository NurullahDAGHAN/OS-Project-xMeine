import 'package:shared_preferences/shared_preferences.dart';

class PlayerProfilePreferences {
  static const String _avatarKeyPrefix = 'player_avatar_index';

  Future<int> loadAvatarIndex(String? userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_avatarKey(userEmail)) ?? 0;
  }

  Future<void> saveAvatarIndex(String? userEmail, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_avatarKey(userEmail), index);
  }

  String _avatarKey(String? userEmail) {
    final normalized = userEmail?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return '${_avatarKeyPrefix}_guest';
    }
    return '${_avatarKeyPrefix}_$normalized';
  }
}
