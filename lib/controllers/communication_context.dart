import 'package:hope_home/models/communication_strats/push_notification_strategy.dart';

import '../models/communication_strats/communication_strategy.dart';

class CommunicationContext {
  CommunicationStrategy _strategy=PushNotificationStrategy();
    Future<void> fastsend(String recipient, String message)async{
    await _strategy.sendMessage(recipient, message, "Push notification");
  }
  Future<void> send(CommunicationStrategy strategy,String recipient, String message, String type)async{
    _setStrategy(strategy);
    await _executeStrategy(recipient, message, type);
  }
  void _setStrategy(CommunicationStrategy strategy) {
    _strategy = strategy;
  }

  Future<void> _executeStrategy(String recipient, String message, String type) async {
    await _strategy.sendMessage(recipient, message, type);
  }
}
