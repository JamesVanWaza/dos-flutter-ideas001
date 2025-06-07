import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LedgerSearchDelegate extends SearchDelegate {
  // Replace with your Typesense server details
  final String typesenseUrl = 'http://localhost:8108';
  final String apiKey = 'YOUR_TYPESENSE_API_KEY';

  Future<List<Map<String, dynamic>>> searchLedger(String query) async {
    final url = Uri.parse('$typesenseUrl/collections/ledger_entries/documents/search');
    final response = await http.post(
      url,
      headers: {
        'X-TYPESENSE-API-KEY': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'q': query,
        'query_by': 'description',
        'sort_by': 'timestamp:desc',
        'per_page': 20,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final hits = (data['hits'] ?? []) as List;
      return hits.map<Map<String, dynamic>>((e) => e['document'] as Map<String, dynamic>).toList();
    } else {
      return [];
    }
  }

  @override
  String get searchFieldLabel => 'Search description...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Optional: show recent queries or nothing
    return const Center(child: Text('Search ledger entries by description.'));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: searchLedger(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snapshot.data!;
        if (results.isEmpty) {
          return const Center(child: Text('No matching results.'));
        }
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final entry = results[index];
            return ListTile(
              leading: Icon(
                (entry['amount'] as num) < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                color: (entry['amount'] as num) < 0 ? Colors.red : Colors.green,
              ),
              title: Text(
                '\$${(entry['amount'] as num).toStringAsFixed(2)}',
                style: TextStyle(
                  color: (entry['amount'] as num) < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(entry['description'] ?? ''),
              trailing: entry['timestamp'] != null
                  ? Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              (entry['timestamp'] as int) * 1000)
                          .toLocal()
                          .toString()
                          .split('.')[0],
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
