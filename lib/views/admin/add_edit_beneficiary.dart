import 'package:flutter/material.dart';
import '../../models/beneficiary.dart';
import '../../models/db_handlers/FireStore.dart';

class AddEditBeneficiaryPage extends StatefulWidget {
  final Beneficiary? beneficiary;

  const AddEditBeneficiaryPage({Key? key, this.beneficiary}) : super(key: key);

  @override
  _AddEditBeneficiaryPageState createState() => _AddEditBeneficiaryPageState();
}

class _AddEditBeneficiaryPageState extends State<AddEditBeneficiaryPage> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreDatabaseService _dbservice = FirestoreDatabaseService();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _needsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.beneficiary?.name ?? '');
    _ageController = TextEditingController(text: widget.beneficiary?.age.toString() ?? '');
    _needsController = TextEditingController(text: widget.beneficiary?.needs ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beneficiary == null ? 'Add Beneficiary' : 'Edit Beneficiary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid age' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _needsController,
                decoration: const InputDecoration(labelText: 'Needs'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the needs' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Beneficiary beneficiary = Beneficiary(
                      id: widget.beneficiary?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      age: int.parse(_ageController.text),
                      needs: _needsController.text,
                      allocatedBudget: widget.beneficiary?.allocatedBudget ?? 0,
                    );

                    if (widget.beneficiary == null) {
                      await _dbservice.addBeneficiary(beneficiary);
                    } else {
                      await _dbservice.updateBeneficiary(beneficiary);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.beneficiary == null ? 'Add' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
