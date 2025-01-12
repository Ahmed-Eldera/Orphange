import 'package:hope_home/models/state/request_state.dart';

import '../Event/request.dart';
import '../db_handlers/FireStore.dart';

class PendingState implements RequestState {
  @override
  Future<void> handle(Request request) async {
    bool isConnected = await FirestoreDatabaseService().checkConnection();
    if (!isConnected) {
      print("Database connection failed. Cannot process request.");
      return;
    }

    // Perform operations for pending state
    print("Request is in the pending state. Waiting for approval.");
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
      print("Database connection failed. Cannot process approval.");
      return;
    }

    print("Request has been approved.");
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
      print("Database connection failed. Cannot process rejection.");
      return;
    }

    print("Request has been rejected.");
    await FirestoreDatabaseService().notifyAdmin(request.id, "Request rejected.");
  }
  @override
  bool canEdit() => false;

  @override
  String getStateName() => "Rejected";
}
