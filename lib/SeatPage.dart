import 'package:flutter/material.dart';
import 'StationListPage.dart';
import 'reservation.dart';

class SeatPage extends StatefulWidget {
  final String departure;
  final String arrival;
  final int seatCount;

  const SeatPage({
    Key? key,
    required this.departure,
    required this.arrival,
    required this.seatCount,
  }) : super(key: key);

  @override
  State<SeatPage> createState() => _SeatPageState();
}

class _SeatPageState extends State<SeatPage> {
  List<Map<String, int>> selectedSeats = [];

  bool isSelected(int row, int col) {
    return selectedSeats.any(
      (seat) => seat['row'] == row && seat['col'] == col,
    );
  }

  void toggleSeat(int row, int col) {
    setState(() {
      if (isSelected(row, col)) {
        selectedSeats.removeWhere(
          (seat) => seat['row'] == row && seat['col'] == col,
        );
      } else if (selectedSeats.length < widget.seatCount) {
        selectedSeats.add({'row': row, 'col': col});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color seatSelectedColor = Colors.purple;
    final Color seatUnselectedColor = Colors.grey[300]!;
    final Color seatLabelColor = Colors.black;
    final Color seatStateBoxUnselected = Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(title: const Text('좌석 선택')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 출발역-도착역 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.departure,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_circle_right_outlined, size: 30),
                const SizedBox(width: 8),
                Text(
                  widget.arrival,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 좌석 상태 안내
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SeatStateBox(color: seatSelectedColor, label: '선택됨'),
                const SizedBox(width: 20),
                SeatStateBox(color: seatStateBoxUnselected, label: '선택 안됨'),
              ],
            ),
            const SizedBox(height: 20),
            // 좌석 리스트
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, row) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int col = 0; col < 4; col++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: GestureDetector(
                              onTap: () {
                                toggleSeat(row, col);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected(row, col)
                                      ? seatSelectedColor
                                      : seatUnselectedColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(
                                      65 + col,
                                    ), // 'A', 'B', 'C', 'D'
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: seatLabelColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '${row + 1}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // 예매하기 버튼
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
                onPressed: selectedSeats.length == widget.seatCount
                    ? () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('예매 확인'),
                            content: Text(
                              '선택한 좌석: ${selectedSeats.map((s) => '${String.fromCharCode(65 + s['col']!)}${s['row']! + 1}').join(', ')}\n예매를 완료하시겠습니까?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          final reservation = Reservation(
                            departure: widget.departure,
                            arrival: widget.arrival,
                            seats: selectedSeats
                                .map(
                                  (s) =>
                                      '${String.fromCharCode(65 + s['col']!)}${s['row']! + 1}',
                                )
                                .toList(),
                            reservedAt: DateTime.now(),
                          );
                          await showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              content: const Text('예매가 완료되었습니다'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // 팝업 닫기
                                    Navigator.pop(
                                      context,
                                      reservation,
                                    ); // HomePage로 반환
                                  },
                                  child: const Text('확인'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    : null,
                child: Text(
                  '예매 하기 (${selectedSeats.length}/${widget.seatCount})',
                  style: const TextStyle(
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

// 좌석 상태 안내 박스 위젯
class SeatStateBox extends StatelessWidget {
  final Color color;
  final String label;

  const SeatStateBox({Key? key, required this.color, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
