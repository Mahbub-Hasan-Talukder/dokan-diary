import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../records/domain/entities/day_wise_entity.dart';

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key, required this.records});
  final List<DayWiseEntity> records;

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    List<double> purchaseCost =
        widget.records.map((e) => e.purchaseCost ?? 0).toList();
    List<double> totalSell =
        widget.records.map((e) => e.totalSell ?? 0).toList();
    List<double> profit = widget.records
        .map((e) => ((e.totalSell ?? 0) - (e.purchaseCost ?? 0)))
        .toList();
    List<String> dates = widget.records.map((e) => e.date ?? '').toList();
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                'Sales Chart',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              SizedBox(
                width: 300,
                height: 200,
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 6),
                    child: _MyLineChart(
                      isShowingMainData: isShowingMainData,
                      dataWrapper: _DataWrapper(
                        purchaseCost,
                        totalSell,
                        profit,
                        dates,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}

class _MyLineChart extends StatelessWidget {
  _MyLineChart({
    required this.isShowingMainData,
    required this.dataWrapper,
  });

  final bool isShowingMainData;
  final _DataWrapper dataWrapper;
  List<String> readyDatesForChart = [];

  @override
  Widget build(BuildContext context) {
    readyDatesForChart = dataWrapper.dates;

    return LineChart(
      sampleData1(dataWrapper),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData sampleData1(_DataWrapper dataWrapper) => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1(dataWrapper),
        minX: -1,
        maxX: dataWrapper.dates.length.toDouble(),
        maxY: 5,
        minY: 0,
      );

  // LineChartData get sampleData2 => LineChartData(
  //       lineTouchData: lineTouchData2,
  //       gridData: gridData,
  //       titlesData: titlesData2,
  //       borderData: borderData,
  //       lineBarsData: lineBarsData2,
  //       minX: 0,
  //       maxX: 14,
  //       maxY: 6,
  //       minY: 0,
  //     );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              const Color.fromARGB(255, 209, 210, 211).withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> lineBarsData1(_DataWrapper dataWrapper) => [
        lineChartBarData1_1(dataWrapper.dates, dataWrapper.totalSell),
        lineChartBarData1_2(dataWrapper.dates, dataWrapper.purchaseCost),
        lineChartBarData1_3(dataWrapper.dates, dataWrapper.profit),
      ];

  // LineTouchData get lineTouchData2 => const LineTouchData(
  //       enabled: false,
  //     );

  // FlTitlesData get titlesData2 => FlTitlesData(
  //       bottomTitles: AxisTitles(
  //         sideTitles: bottomTitles,
  //       ),
  //       rightTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       topTitles: const AxisTitles(
  //         sideTitles: SideTitles(showTitles: false),
  //       ),
  //       leftTitles: AxisTitles(
  //         sideTitles: leftTitles(),
  //       ),
  //     );

  // List<LineChartBarData> get lineBarsData2 => [
  //       lineChartBarData2_1,
  //       lineChartBarData2_2,
  //       lineChartBarData2_3,
  //     ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1m';
        break;
      case 2:
        text = '2m';
        break;
      case 3:
        text = '3m';
        break;
      case 4:
        text = '4m';
        break;
      case 5:
        text = '5m';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    if (value.toInt() == -1 ||
        value.toInt() ~/ 4 == readyDatesForChart.length ||
        value.toInt() % 4 != 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: const Text(''),
      );
    }

    int index = value.toInt() ~/ 4;

    Widget text = Text(readyDatesForChart[index]);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.2), width: 4),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData lineChartBarData1_1(
      List<String> dates, List<double> totalSell) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    double maxSell = totalSell.reduce((a, b) => a > b ? a : b);
    List<double> sell = totalSell.map((e) => (e / maxSell) * 5).toList();
    return LineChartBarData(
      isCurved: true,
      color: Colors.green,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: List.generate(
        days.length,
        (index) => FlSpot(
          2 * days[index].toDouble() - 1,
          sell[index],
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData1_2(
      List<String> dates, List<double> purchaseCost) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    double maxPurchase = purchaseCost.reduce((a, b) => a > b ? a : b);
    List<double> purchase =
        purchaseCost.map((e) => (e / maxPurchase) * 5).toList();
    return LineChartBarData(
      isCurved: true,
      color: Colors.orange,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: false,
        color: Colors.blueGrey.withOpacity(0.2),
      ),
      spots: List.generate(
        days.length,
        (index) => FlSpot(
          2 * days[index].toDouble() - 1,
          purchase[index],
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData1_3(
      List<String> dates, List<double> profits) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    double maxProfit = profits.reduce((a, b) => a > b ? a : b);
    List<double> newProfit = profits.map((e) => (e / maxProfit) * 5).toList();
    return LineChartBarData(
      isCurved: true,
      color: Colors.blue,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: List.generate(
        days.length,
        (index) => FlSpot(
          2 * days[index].toDouble() - 1,
          newProfit[index],
        ),
      ),
    );
  }

  // LineChartBarData get lineChartBarData2_1 => LineChartBarData(
  //       isCurved: true,
  //       curveSmoothness: 0,
  //       color: Colors.blueGrey,
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: const FlDotData(show: false),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 4),
  //         FlSpot(5, 1.8),
  //         FlSpot(7, 5),
  //         FlSpot(10, 2),
  //         FlSpot(12, 2.2),
  //         FlSpot(13, 1.8),
  //       ],
  //     );

  // LineChartBarData get lineChartBarData2_2 => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.blueGrey,
  //       barWidth: 4,
  //       isStrokeCapRound: true,
  //       dotData: const FlDotData(show: false),
  //       belowBarData: BarAreaData(
  //         show: true,
  //         color: Colors.blueGrey.withOpacity(0.2),
  //       ),
  //       spots: const [
  //         FlSpot(1, 1),
  //         FlSpot(3, 2.8),
  //         FlSpot(7, 1.2),
  //         FlSpot(10, 2.8),
  //         FlSpot(12, 2.6),
  //         FlSpot(13, 3.9),
  //       ],
  //     );

  // LineChartBarData get lineChartBarData2_3 => LineChartBarData(
  //       isCurved: true,
  //       curveSmoothness: 0,
  //       color: Colors.blueGrey,
  //       barWidth: 2,
  //       isStrokeCapRound: true,
  //       dotData: const FlDotData(show: true),
  //       belowBarData: BarAreaData(show: false),
  //       spots: const [
  //         FlSpot(1, 3.8),
  //         FlSpot(3, 1.9),
  //         FlSpot(6, 5),
  //         FlSpot(10, 3.3),
  //         FlSpot(13, 4.5),
  //       ],
  //     );
  int totalDays(DateTime date) {
    return date.day + date.month * 30 + date.year * 365;
  }
}

class _DataWrapper {
  final List<double> purchaseCost;
  final List<double> totalSell;
  final List<double> profit;
  final List<String> dates;

  _DataWrapper(this.purchaseCost, this.totalSell, this.profit, this.dates);
}
