import '../Event/request.dart';

abstract class RequestState {
  void handle(Request request);
  bool canEdit();
  String getStateName();
}
