import 'package:hope_home/models/state/request_state.dart';

import '../Event/request.dart';
import '../db_handlers/FireStore.dart';

class PendingState implements RequestState {
  @override
  Future<void> handle(Request request) async {
    bool isConnected = await FirestoreDatabaseService().checkConnection();
    if (!isConnected) {
      return;
    }

    // Perform operations for pending state
    // Example: Send notification to admin
    await FirestoreDatabaseService().notifyAdmin(request.id, "New request pending approval.");
  }

  @override
  bool canEdit() => true;

  @override
  String getStateName() => "Pending";
}

class ApprovedState implements RequestState {
  @override
  Future<void> handle(Request request) async {
    bool isConnected = await FirestoreDatabaseService().checkConnection();
    if (!isConnected) {
      return;
    }

    await FirestoreDatabaseService().notifyAdmin(request.id, "Request approved.");
  }

  @override
  bool canEdit() => false;

  @override
  String getStateName() => "Approved";
}

class RejectedState implements RequestState {
  @override
  Future<void> handle(Request request) async {
    bool isConnected = await FirestoreDatabaseService().checkConnection();
    if (!isConnected) {
      return;
    }

    await FirestoreDatabaseService().notifyAdmin(request.id, "Request rejected.");
  }
  @override
  bool canEdit() => false;

  @override
  String getStateName() => "Rejected";
}
