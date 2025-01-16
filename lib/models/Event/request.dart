import 'package:cloud_firestore/cloud_firestore.dart';

import '../state/request_state.dart';
import '../state/state_types.dart';
class Request {
  final String id;
  final String taskId;
  final String eventId;
  final String? volunteerId;
  String details; // Remove final
  late RequestState _state;

  Request({
    required this.id,
    required this.taskId,
    required this.eventId,
    required this.volunteerId,
    required this.details,
    RequestState? initialState,
  }) : _state = initialState ?? PendingState();

  String getStateName() => _state.getStateName();

  void setState(RequestState state) {
    _state = state;
  }

  // Check if the request can be edited
  bool canEdit() => getStateName() == "Pending";

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'eventId': eventId,
      'volunteerId': volunteerId,
      'details': details,
      'state': _state.getStateName(),
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    RequestState initialState;

    switch (map['state'] as String) {
      case 'Approved':
        initialState = ApprovedState();
        break;
      case 'Rejected':
        initialState = RejectedState();
        break;
      default:
        initialState = PendingState();
        break;
    }

    return Request(
      id: map['id'] as String,
      taskId: map['taskId'] as String,
      eventId: map['eventId'] as String,
      volunteerId: map['volunteerId'] as String?,
      details: map['details'] as String,
      initialState: initialState,
    );
  }

  static RequestState _mapState(String stateName) {
    switch (stateName) {
      case 'Approved':
        return ApprovedState();
      case 'Rejected':
        return RejectedState();
      default:
        return PendingState();
    }
  }
  RequestState getState() => _state;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveRequest(String eventId) async {
    try {
      await _firestore
          .collection('events') // Navigate to events
          .doc(eventId) // Select the event
          .collection('tasks') // Access tasks
          .doc(taskId) // Select the task
          .collection('requests') // Access requests under the task
          .doc(id) // Use the request ID
          .set(toMap()); // Save the request details
      print("Request saved successfully under event $eventId and task $taskId");
    } catch (e) {
      print('Failed to save request: $e');
      throw Exception('Failed to save request');
    }
  }

  Future<void> updateRequestDetails() async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId)
          .collection('tasks')
          .doc(taskId)
          .collection('requests')
          .doc(id)
          .update({
        'details': details,
      });
      print("Request details updated successfully for $id");
    } catch (e) {
      print("Failed to update request details: $e");
      throw Exception("Failed to update request details");
    }
  }

  Future<void> updateRequestState() async {
    try {
      final docPath = 'events/$eventId/tasks/$taskId/requests/$id';

      await _firestore
          .collection('events')
          .doc(eventId) // Ensure eventId is used
          .collection('tasks')
          .doc(taskId)
          .collection('requests')
          .doc(id)
          .update({'state': getStateName()}); // Update the state
      print("Request state updated successfully for $id");
    } catch (e) {
      print("Failed to update request state: $e");
      throw Exception("Failed to update request state");
    }
  }
}
