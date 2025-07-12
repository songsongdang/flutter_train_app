class Reservation {
  final String departure;
  final String arrival;
  final List<String> seats; // 예: ["A1", "B2"]
  final DateTime reservedAt;

  Reservation({
    required this.departure,
    required this.arrival,
    required this.seats,
    required this.reservedAt,
  });
}
