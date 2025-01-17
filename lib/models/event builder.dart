import 'Event/event.dart';

class EventBuilder {
  String? _id;
  String? _name;
  int? _attendance;
  String? _description;
  String? _date;

  EventBuilder setId(String id) {
    _id = id;
    return this;
  }

  EventBuilder setName(String name) {
    _name = name;
    return this;
  }

  EventBuilder setAttendance(int attendance) {
    _attendance = attendance;
    return this;
  }

  EventBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  EventBuilder setDate(String date) {
    _date = date;
    return this;
  }

  Event build() {
    return Event(
      id: _id!,
      name: _name!,
      attendance: _attendance!,
      description: _description!,
      date: _date!, tasks: [],
    );
  }
}
