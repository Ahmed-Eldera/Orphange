import 'communication_strategy.dart';

class CommunicationContext {
  late CommunicationStrategy _strategy;

  void setStrategy(CommunicationStrategy strategy) {
    _strategy = strategy;
  }

  Future<void> executeStrategy(String recipient, String message, String type) async {
    await _strategy.sendMessage(recipient, message, type);
  }
}
