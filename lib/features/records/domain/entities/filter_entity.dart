///filter by date, by item
enum QueryTypes { date, item }

///sort in ascending, descending
enum SortingOrder { descending, ascending }

///sort by attribute
enum TargetAttribute { purchase, sell, percentage }

class FilterEntity {
  QueryTypes? queryType = QueryTypes.date;
  SortingOrder? sortingOrder = SortingOrder.descending;
  TargetAttribute? targetAttribute = TargetAttribute.percentage;

  FilterEntity({
    this.queryType,
    this.sortingOrder,
    this.targetAttribute,
  });
}
