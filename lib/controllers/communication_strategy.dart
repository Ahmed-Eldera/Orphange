abstract class CommunicationStrategy {
  Future<void> sendMessage(String recipient, String message, String type);
}
