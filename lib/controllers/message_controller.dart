import '../models/db_handlers/FireStore.dart';

class MessageController {
  final FirestoreDatabaseService _dbService = FirestoreDatabaseService();

  Future<List<Map<String, dynamic>>> fetchMessages(String userId) async {
    try {
      return await _dbService.fetchMessagesForRecipient(userId);
    } catch (error) {
      return [];
    }
  }
}
