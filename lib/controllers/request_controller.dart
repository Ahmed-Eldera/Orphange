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

  Future<void> updateRequestState(Request request) async {
    try {
      await FirestoreDatabaseService().updateRequestState(request);
      print("Request state updated successfully in the database.");
    } catch (e) {
      throw Exception("Failed to update request state in database: $e");
    }
  }

}
