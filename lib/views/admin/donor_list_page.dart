import 'package:flutter/material.dart';
import '../../models/iterators/donor_collection.dart';
import '../../controllers/donor_controller.dart';
import '../../models/iterators/donor_iterator.dart';
import '../../models/users/donor.dart';

class DonorListPage extends StatefulWidget {
  const DonorListPage({Key? key}) : super(key: key);

  @override
  _DonorListPageState createState() => _DonorListPageState();
}

class _DonorListPageState extends State<DonorListPage> {
  final DonorController _controller = DonorController();
  DonorCollection? _donorCollection;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  Future<void> _loadDonors() async {
    setState(() {
      _isLoading = true;
    });

    List<Donor> donors = await _controller.getAllDonors();
    _donorCollection = DonorCollection(donors);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor List'),
        backgroundColor: Colors.red.shade700,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_donorCollection == null || !_donorCollection!.getIterator().hasNext())
          ? const Center(child: Text('No donors found'))
          : ListView(
        padding: const EdgeInsets.all(8.0),
        children: _buildDonorCards(),
      ),
    );
  }

  List<Widget> _buildDonorCards() {
    DonorIterator iterator = _donorCollection!.getIterator();
    List<Widget> donorWidgets = [];

    while (iterator.hasNext()) {
      Donor donor = iterator.next();
      donorWidgets.add(
        Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        donor.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Email: ${donor.email}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (donor.history.isNotEmpty)
                  Text(
                    "Donations: ${donor.history.join(', ')}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return donorWidgets;
  }
}
