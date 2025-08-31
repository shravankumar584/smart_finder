import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/location_service.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'other';
  int _age = 25;
  String _status = 'single';
  bool _hasKids = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Find')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['male', 'female', 'other'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _gender = v!),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (v) => _age = int.tryParse(v) ?? 0,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (v) => (int.tryParse(v!) ?? 0) > 0 ? null : 'Enter valid age',
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['single', 'married', 'other'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => _status = v!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              SwitchListTile(
                title: const Text('Traveling with kids?'),
                value: _hasKids,
                onChanged: (v) => setState(() => _hasKids = v),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final provider = Provider.of<UserProvider>(context, listen: false);
                    provider.updateUser(_gender, _age, _status, _hasKids);
                    final position = await LocationService.getCurrentLocation();
                    await provider.fetchRecommendations(position.latitude, position.longitude);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ResultsScreen()));
                  }
                },
                child: const Text('Find Places'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
