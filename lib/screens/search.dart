import 'package:digi_diagnos/screens/profile.dart';
import 'package:digi_diagnos/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/user_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCriteria = 'Mobile';
  String _searchQuery = '';
  List<PatientInfoModel> _searchResults = [];
  

  void _search() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform the search in the database and update _searchResults
      final ap = Provider.of<AuthProvider>(context, listen: false);
      List<PatientInfoModel> searchResults = [];
      if (_selectedCriteria == 'Mobile') {
      searchResults = await ap.getPatientByMobile(_searchQuery);
      } else if (_selectedCriteria == 'Name') {
        searchResults = await ap.getPatientByName(_searchQuery);
      } else if (_selectedCriteria == 'Diagnosys') {
        searchResults = await ap.getPatientByDiagnosys(_searchQuery);
      }
      // For demonstration, we'll use a dummy list
      setState(() {
        _searchResults = searchResults;
      });
    }
  }

  String? _validateSearchQuery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a search query';
    }
    if (_selectedCriteria == 'Mobile' && !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      drawer : DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCriteria,
                items: ['Mobile', 'Name', 'Diagnosys'].map((String criteria) {
                  return DropdownMenuItem<String>(
                    value: criteria,
                    child: Text(criteria),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCriteria = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search Criteria',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Search Query',
                ),
                validator: _validateSearchQuery,
                onSaved: (String? value) {
                  _searchQuery = value!;
                },
                onFieldSubmitted: (value) => _search(),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _search,
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: 
                // change this to future builder
                _searchResults.isEmpty
                    ? Center(
                        child: Text('No results found'),
                      )
                    :
                ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final patient = _searchResults[index];
                    return PatientCard(patientInfoModel: patient);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

