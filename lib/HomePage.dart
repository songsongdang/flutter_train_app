import 'package:flutter/material.dart';
import 'package:flutter_train_app/SeatPage.dart';
import 'package:flutter_train_app/StationListPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? departure;
  String? arrival;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기차 예매')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StationSelectBox(
              label: '출발역',
              value: departure,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StationListPage(
                      title: '출발역 선택',
                      excludeStation: arrival,
                    ),
                  ),
                );
                if (result != null) setState(() => departure = result);
              },
            ),
            const SizedBox(height: 20),
            StationSelectBox(
              label: '도착역',
              value: arrival,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StationListPage(
                      title: '도착역 선택',
                      excludeStation: departure,
                    ),
                  ),
                );
                if (result != null) setState(() => arrival = result);
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: (departure != null && arrival != null)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SeatPage(
                              departure: departure!,
                              arrival: arrival!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  '좌석 선택',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StationSelectBox extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const StationSelectBox({
    Key? key,
    required this.label,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value ?? '선택',
                style: const TextStyle(fontSize: 40, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
