abstract class RecordsDataSource{
  Future<List<Map<String, dynamic>>> fetchDayWiseSellInfo({
    String? startDate,
    String? endDate,
  });
}