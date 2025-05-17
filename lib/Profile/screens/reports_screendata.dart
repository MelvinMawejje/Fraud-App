import 'package:flutter/material.dart';
import 'package:fraud_watch/Profile/models/prediction_record.dart';
import 'package:fraud_watch/Profile/services/prediction_storage.dart';
import 'package:fraud_watch/baselayout.dart';

class ReportsDataScreen extends StatefulWidget {
  const ReportsDataScreen({super.key});

  @override
  State<ReportsDataScreen> createState() => _ReportsDataScreenState();
}

class _ReportsDataScreenState extends State<ReportsDataScreen> {
  final PredictionStorage _storage = PredictionStorage();
  late Future<List<PredictionRecord>> _predictionsFuture;
  String _filterStatus = 'ALL'; // State variable to hold the current filter

  @override
  void initState() {
    super.initState();
    _predictionsFuture = _storage.getPredictions();
  }

  void _refreshData() {
    setState(() {
      // Reset filter when refreshing or keep current filter?
      // _filterStatus = 'ALL'; // Uncomment to reset filter on refresh
      _predictionsFuture = _storage.getPredictions();
    });
  }

  Future<void> _deleteRecord(int originalIndex, List<PredictionRecord> allRecords) async {
    // Find the actual record to delete based on the original list
    final recordToDelete = allRecords[originalIndex];
    // Find the index in the storage (assuming order might not match if filtered)
    // A more robust way would be to use a unique ID if available.
    // For now, let's assume the index corresponds if not filtered,
    // but it's safer to find the record by timestamp or another unique property.
    // This simple index approach might fail if the list order changes drastically.
    // A better approach: find the index in the original list before filtering.
    // Let's refactor to pass the original index.

    // Find the index in the storage based on a unique property like timestamp
    final allPredictions = await _storage.getPredictions();
    final storageIndex = allPredictions.indexWhere((p) => p.timestamp == recordToDelete.timestamp && p.text == recordToDelete.text);

    if (storageIndex != -1) {
        await _storage.deletePrediction(storageIndex);
        _refreshData(); // Refresh fetches all data again and applies filter
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record deleted')),
          );
        }
    } else {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Could not find record to delete')),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      appBarTitle:'Reports' ,
      actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: _refreshData,
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.filter_list,
              // Optionally indicate if a filter is active
              color: _filterStatus != 'ALL' ? Theme.of(context).colorScheme.primary : null,
            ),
            tooltip: 'Filter: $_filterStatus', // Show current filter in tooltip
            onSelected: (String result) {
              // Update the filter state when an option is selected
              setState(() {
                _filterStatus = result;
                // No need to call _refreshData here, FutureBuilder will rebuild
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'ALL',
                child: Text('Show All'),
              ),
              const PopupMenuItem<String>(
                value: 'SCAM',
                child: Text('Show SCAM Only'),
              ),
              const PopupMenuItem<String>(
                value: 'NOTSCAM', // Ensure value matches PredictionRecord result
                child: Text('Show NOT SCAM Only'),
              ),
            ],
          ),
      ],
      body: FutureBuilder<List<PredictionRecord>>(
        future: _predictionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
             return Center(child: Text('Error loading records: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No prediction records found'));
          }

          // Filter the data based on the _filterStatus
          final allRecords = snapshot.data!;
          final filteredRecords = allRecords.where((record) {
            if (_filterStatus == 'ALL') {
              return true; // Show all records
            }
            // Ensure case-insensitive comparison
            return record.result.toUpperCase() == _filterStatus;
          }).toList();

          if (filteredRecords.isEmpty) {
             return Center(child: Text('No records found matching filter: $_filterStatus'));
          }

          // Build the list using the filtered data
          return ListView.builder(
            itemCount: filteredRecords.length,
            itemBuilder: (context, index) {
              final record = filteredRecords[index];
              // Find the original index in the unfiltered list to ensure correct deletion
              final originalIndex = allRecords.indexOf(record);

              return Dismissible(
                key: Key(record.timestamp.toIso8601String() + record.text), // Make key more unique
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  // Pass the original index and the full list to delete correctly
                  await _deleteRecord(originalIndex, allRecords);
                },
                child: ListTile(
                  title: Text(
                    record.result,
                    style: TextStyle(
                      color: record.result.toUpperCase() == 'SCAM'
                        ? Colors.red
                        : record.result.toUpperCase() == 'NOTSCAM'
                          ? Colors.green
                          : null, // Default color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${(record.probability * 100).toStringAsFixed(1)}% - '
                    '${record.timestamp.toString().substring(0, 16)}'
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        tooltip: 'View Details',
                        onPressed: () => _showDetails(record),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        tooltip: 'Delete Record',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text('Are you sure you want to delete this record?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                             // Pass the original index and the full list
                             await _deleteRecord(originalIndex, allRecords);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetails(PredictionRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Prediction Details - ${record.result}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Probability: ${(record.probability * 100).toStringAsFixed(1)}%'),
              const SizedBox(height: 10),
              const Text('Analyzed Text:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(record.text),
              const SizedBox(height: 10),
              Text('Date: ${record.timestamp.toString().substring(0, 16)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}