import 'package:hope_home/models/iterators/Iterator.dart';

import '../Event/event.dart';
import 'event iterator.dart';

abstract class EventCollection {
  AppIterator createIterator();
}

class EventList implements EventCollection {
  final List<Event> _events = [];

  void addEvent(Event event) {
    _events.add(event);
  }

  List<Event> get events => _events;

  @override
  AppIterator createIterator() {
    return EventListIterator(_events);
  }
}
