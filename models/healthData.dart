class HealthData {
  final String type;
  final double value;
  final String unit;
  final DateTime dateFrom;
  final DateTime dateTo;

  HealthData({
      required this.type,
      required this.value,
      required this.unit,
      required this.dateFrom,
      required this.dateTo});
}
