///filter by date, by item
enum QueryTypes { calender, item }

///sort in ascending, descending
enum SortingOrder { descending, ascending }

///sort by attribute
enum TargetAttribute { date, purchase, sell, percentage }

class DateRange {
  DateTime startDate;
  DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });
}

class FilterEntity {
  QueryTypes? queryType = QueryTypes.calender;
  SortingOrder? sortingOrder = SortingOrder.descending;
  TargetAttribute? targetAttribute = TargetAttribute.percentage;
  DateRange? dateRange = DateRange(
    startDate: DateTime.now().subtract(const Duration(days: 366)),
    endDate: DateTime.now(),
  );

  FilterEntity({
    this.queryType,
    this.sortingOrder,
    this.targetAttribute,
    this.dateRange,
  });

  FilterEntity.copyWith({
    this.queryType = QueryTypes.calender,
    this.sortingOrder = SortingOrder.descending,
    this.targetAttribute = TargetAttribute.date,
    this.dateRange,
  }) {
    FilterEntity(
      queryType: queryType,
      sortingOrder: sortingOrder,
      targetAttribute: targetAttribute,
      dateRange: dateRange,
    );
  }
}
