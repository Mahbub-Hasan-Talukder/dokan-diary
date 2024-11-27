abstract class RecordsDataSource{
  Future<List<Map<String, dynamic>>> fetchDayWiseSellInfo({
    String? startDate,
    String? endDate,
  });

  Future<List<Map<String, dynamic>>> fetchItemWiseSellInfo({
    String? startDate,
    String? endDate,
  });
}