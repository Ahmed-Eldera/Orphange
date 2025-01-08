import '../Event/event.dart';

abstract class EventIterator {
  bool hasNext();
  Event next();
}

class EventListIterator implements EventIterator {
  final List<Event> _events;
  int _currentIndex = 0;

  EventListIterator(this._events);

  @override
  bool hasNext() {
    return _currentIndex < _events.length;
  }

  @override
  Event next() {
    if (!hasNext()) {
      throw Exception("No more events.");
    }
    return _events[_currentIndex++];
  }
}
