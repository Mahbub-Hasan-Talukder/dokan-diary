///filter by date, by item
enum QueryTypes { calender, item }

///sort in ascending, descending
enum SortingOrder { descending, ascending }

///sort by attribute
enum TargetAttribute { date, purchase, sell, percentage }

class FilterEntity {
  QueryTypes? queryType = QueryTypes.calender;
  SortingOrder? sortingOrder = SortingOrder.descending;
  TargetAttribute? targetAttribute = TargetAttribute.percentage;

  FilterEntity({
    this.queryType,
    this.sortingOrder,
    this.targetAttribute,
  });

  FilterEntity.copyWith({
    this.queryType = QueryTypes.calender,
    this.sortingOrder = SortingOrder.descending,
    this.targetAttribute = TargetAttribute.date,
  }) {
    FilterEntity(
      queryType: queryType,
      sortingOrder: sortingOrder,
      targetAttribute: targetAttribute,
    );
  }
}
