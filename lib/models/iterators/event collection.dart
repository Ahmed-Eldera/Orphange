import '../../models/event.dart';
import 'event iterator.dart';

abstract class EventCollection {
  EventIterator createIterator();
}

class EventList implements EventCollection {
  final List<Event> _events = [];

  void addEvent(Event event) {
    _events.add(event);
  }

  List<Event> get events => _events;

  @override
  EventIterator createIterator() {
    return EventListIterator(_events);
  }
}
