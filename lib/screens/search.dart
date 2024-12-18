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
  @override
  void initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.addListener(_onAuthProviderChange);
  }

  @override
  void dispose() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.removeListener(_onAuthProviderChange);
    super.dispose();
  }

  void _onAuthProviderChange() {
    // Handle changes from AuthProvider if needed
    setState(() {
      // Rebuild the widget with the updated data
    });
  }
  final _formKey = GlobalKey<FormState>();
  String _selectedCriteria = 'Mobile';
  String _searchQuery = '';
  List<PatientInfoModel> _searchResults = [];
  DateTime? _fromDate = DateTime.now();
  DateTime? _toDate = DateTime.now();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fromDate)
      setState(() {
        fromDateController.text = '${picked.day}/${picked.month}/${picked.year}';
        _fromDate = picked;
      });
  }
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fromDate)
      setState(() {
        toDateController.text = '${picked.day}/${picked.month}/${picked.year}';
        _toDate = picked;
      });
  }
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
      } else if (_selectedCriteria == 'Referral') {
        searchResults = await ap.getPatientByReferral(_searchQuery, _fromDate!, _toDate!);
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
              // if search criteria is referral. then show a date range picker
              if (_selectedCriteria == 'Referral')
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text('Select Date Range'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: 
                          // change this to date picker
                          InkWell(
                            onTap: () async {
                              await _selectFromDate(context);
                            },
                            child: IgnorePointer(
                              child: TextField(
                                controller: fromDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'From',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: 
                          // change this to date picker
                          InkWell(
                            onTap: () async {
                              await _selectToDate(context);
                            },
                            child: IgnorePointer(
                              child: TextField(
                                controller: toDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'To',
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

