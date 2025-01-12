import 'package:flutter/material.dart';
import 'package:hope_home/controllers/request_controller.dart';
import 'package:hope_home/models/Event/request.dart';

class AdminRequestManagementPage extends StatefulWidget {
  const AdminRequestManagementPage({Key? key}) : super(key: key);

  @override
  State<AdminRequestManagementPage> createState() =>
      _AdminRequestManagementPageState();
}

class _AdminRequestManagementPageState
    extends State<AdminRequestManagementPage> {
  final RequestController _controller = RequestController();
  late Future<List<Request>> _requestsFuture;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _controller.fetchAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Requests"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Request>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return const Center(child: Text("No requests available."));
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                child: ListTile(
                  title: Text(
                    request.details,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Task ID: ${request.taskId}"),
                      Text("Submitted by: ${request.volunteerId}"),
                      Text("Status: ${request.getStateName()}"),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: request.getStateName(),
                    icon: const Icon(Icons.arrow_downward),
                    items: ["Pending", "Approved", "Rejected"]
                        .map((state) => DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    ))
                        .toList(),
                    onChanged: (newState) {
                      if (newState != null) {
                        _controller
                            .updateRequestState(request, newState)
                            .then((_) {
                          setState(() {}); // Refresh the page
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Request state updated to '$newState'."),
                            ),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Failed to update state: $error"),
                            ),
                          );
                        });
                      }
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
