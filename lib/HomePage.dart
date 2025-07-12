import 'package:flutter/material.dart';
import 'SeatPage.dart';
import 'StationListPage.dart';
import 'reservation.dart';

// 역 목록
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
  List<Reservation> reservations = [];

  // 예매내역 취소(확인 팝업 포함)
  Future<void> _cancelReservation(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예매취소 확인'),
        content: const Text('정말로 예매내역을 취소하시겠습니까?\n취소된 내역은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        reservations.removeAt(index);
      });
    }
  }

  Future<void> _goToSeatPage() async {
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
                Text('$tempCount', style: const TextStyle(fontSize: 24)),
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
              onPressed: () => Navigator.pop(context, tempCount),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
    if (seatCount != null) {
      final reservation = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SeatPage(
            departure: departure!,
            arrival: arrival!,
            seatCount: seatCount,
          ),
        ),
      );
      if (reservation != null && reservation is Reservation) {
        setState(() {
          reservations.add(reservation);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기차 예매')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 예매내역 영역 (항상 표시)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예매내역',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (reservations.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: const Text(
                      '예매내역이 없습니다',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final r = reservations[index];
                      return Card(
                        child: ListTile(
                          title: Text('${r.departure} → ${r.arrival}'),
                          subtitle: Text(
                            '좌석: ${r.seats.join(", ")}\n시간: ${_formatDateTime(r.reservedAt)}',
                          ),
                          trailing: TextButton.icon(
                            onPressed: () => _cancelReservation(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              '예매취소하기',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
            // 예매/역 선택 영역
            Expanded(
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
                          ? _goToSeatPage
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
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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

// 기차역 리스트 페이지
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
