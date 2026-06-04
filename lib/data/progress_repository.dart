import 'progress_state.dart';

abstract class ProgressRepository {
  Future<ProgressSnapshot> loadProgress(List<String> levelIds);
  Future<ProgressSnapshot> setLastPlayed(List<String> levelIds, String levelId);
  Future<ProgressSnapshot> recordHint(List<String> levelIds, String levelId);
  Future<ProgressSnapshot> recordAttempt(List<String> levelIds, String levelId);
  Future<ProgressSnapshot> completeLevel(List<String> levelIds, String levelId);
}
