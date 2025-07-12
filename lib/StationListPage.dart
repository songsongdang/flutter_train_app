import 'package:flutter/material.dart';

const stations = [
  '수서',
  '동탄',
  '평택지제',
  '천안아산',
  '오송',
  '대전',
  '김천구미',
  '동대구',
  '경주',
  '울산',
  '부산',
];

class StationListPage extends StatelessWidget {
  final String title;
  final String? excludeStation;

  const StationListPage({Key? key, required this.title, this.excludeStation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filteredStations = excludeStation == null
        ? stations
        : stations.where((s) => s != excludeStation).toList();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        itemCount: filteredStations.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Colors.grey),
        itemBuilder: (context, index) {
          final station = filteredStations[index];
          return ListTile(
            title: Text(
              station,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.pop(context, station),
          );
        },
      ),
    );
  }
}
