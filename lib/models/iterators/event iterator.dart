import 'package:hope_home/models/iterators/Iterator.dart';
import '../Event/event.dart';

class EventListIterator implements AppIterator {
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
