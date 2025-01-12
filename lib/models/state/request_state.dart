import '../Event/request.dart';

abstract class RequestState {
  Future<void> handle(Request request);
  bool canEdit();
  String getStateName();
}
