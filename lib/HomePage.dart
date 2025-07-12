import 'package:flutter/material.dart';
import 'package:flutter_train_app/SeatPage.dart';
import 'package:flutter_train_app/StationListPage.dart';

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
                    ? () async {
                        int? seatCount = await showDialog<int>(
                          context: context,
                          builder: (context) {
                            int tempCount = 1;
                            return AlertDialog(
                              title: const Text('몇 좌석을 예매하시겠습니까?'),
                              content: StatefulBuilder(
                                builder: (context, setState) => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: tempCount > 1
                                          ? () => setState(() => tempCount--)
                                          : null,
                                    ),
                                    Text(
                                      '$tempCount',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: tempCount < 6
                                          ? () => setState(() => tempCount++)
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, tempCount),
                                  child: const Text('확인'),
                                ),
                              ],
                            );
                          },
                        );
                        if (seatCount != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SeatPage(
                                departure: departure!,
                                arrival: arrival!,
                                seatCount: seatCount,
                              ),
                            ),
                          );
                        }
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

// 출발역/도착역 선택 박스 위젯
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
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value ?? '선택',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 기차역 리스트 페이지 (필요시 별도 파일로 분리)
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
