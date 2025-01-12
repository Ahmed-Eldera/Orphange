import 'package:hope_home/models/state/request_state.dart';

import '../Event/request.dart';

class PendingState implements RequestState {
  @override
  void handle(Request request) {
    print("Request is pending.");
  }

  @override
  bool canEdit() => true;

  @override
  String getStateName() => "Pending";
}

class ApprovedState implements RequestState {
  @override
  void handle(Request request) {
    print("Request has been approved.");
  }

  @override
  bool canEdit() => false;

  @override
  String getStateName() => "Approved";
}

class RejectedState implements RequestState {
  @override
  void handle(Request request) {
    print("Request has been rejected.");
  }

  @override
  bool canEdit() => false;

  @override
  String getStateName() => "Rejected";
}
