import 'package:hope_home/models/Event/request.dart';
import 'package:hope_home/models/db_handlers/FireStore.dart';

import '../models/state/state_types.dart';

class RequestController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<List<Request>> fetchAllRequests() async {
    try {
      return await _dbService.fetchAllRequests();
    } catch (e) {
      print('Error fetching requests: $e');
      throw Exception('Failed to fetch requests');
    }
  }

  Future<void> updateRequestState(Request request, String newState) async {
    try {
      if (newState == "Approved") {
        request.setState(ApprovedState());
      } else if (newState == "Rejected") {
        request.setState(RejectedState());
      } else {
        request.setState(PendingState());
      }
      await _dbService.updateRequestState(request);
    } catch (e) {
      print('Error updating request state: $e');
      throw Exception('Failed to update request state');
    }
  }
}
