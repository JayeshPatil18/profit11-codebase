import 'package:flutter/material.dart';

class CreateChallengePage extends StatefulWidget {
  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  final _formKey = GlobalKey<FormState>();
  double _entryFee = 0.0;
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Entry Fee'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _entryFee = double.tryParse(value ?? '0.0') ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an entry fee';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_startTime != null
                    ? "Start Time: ${_startTime.toString()}"
                    : "Select Start Time"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _startTime = date;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_endTime != null
                    ? "End Time: ${_endTime.toString()}"
                    : "Select End Time"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _endTime = date;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Submit the challenge creation logic here
                  }
                },
                child: Text("Create Challenge"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
