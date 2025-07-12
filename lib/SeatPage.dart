import 'package:flutter/material.dart';

class SeatPage extends StatefulWidget {
  final String departure;
  final String arrival;
  final int seatCount; // 추가

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

  void popToHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('좌석 선택'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
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
                            onTap: () => toggleSeat(row, col),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected(row, col)
                                    ? Colors.purple
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + col),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
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
                        await showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            content: const Text('예매가 완료되었습니다'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  popToHome();
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
