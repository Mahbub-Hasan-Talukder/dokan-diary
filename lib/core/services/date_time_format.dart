class DateTimeFormat{
  static String getPrettyDate(DateTime dateTime){
    String formatedDateTime = dateTime.toIso8601String().substring(0,10);
    String month = _getMonth(formatedDateTime);
    String day = dateTime.toIso8601String().substring(8,10);
    String year = dateTime.toIso8601String().substring(0,4);
    return "$day $month, $year";
  }
  static String getYMD(DateTime date){
    return date.toIso8601String().substring(0,10);
  }
   static String _getMonth(String date){
    int month = int.tryParse(date.substring(5,7)) ?? 0;
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Wrong date format';
    }
  }
}