import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/date_time_format.dart';
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
    // double maxPurchase = purchaseCost.reduce((a, b) => a > b ? a : b);
    double maxSell = totalSell.reduce((a, b) => a > b ? a : b);
    // for (var i = 0; i < dates.length; i++) {
    //   print(
    //       'dbg ${(purchaseCost[i] / maxSell) * 5}  ${(totalSell[i] / maxSell) * 5}');
    // }
    double size = MediaQuery.of(context).size.width;
    print('dbg ${widget.records.length}');
    return Column(
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
        Card(
          child: SizedBox(
            height: size * 0.6,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, left: 6, top: 10),
                child: Container(
                  width: widget.records.length * 60.0,
                  child: _MyLineChart(
                    isShowingMainData: isShowingMainData,
                    dataWrapper: _DataWrapper(
                      purchaseCost,
                      totalSell,
                      profit,
                      dates,
                      maxSell,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
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
        handleBuiltInTouches: false,
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
        lineChartBarData1_1(
          dataWrapper.dates,
          dataWrapper.totalSell,
          dataWrapper.maxSell,
        ),
        lineChartBarData1_2(
          dataWrapper.dates,
          dataWrapper.purchaseCost,
          dataWrapper.maxSell,
        ),
        lineChartBarData1_3(
          dataWrapper.dates,
          dataWrapper.profit,
          dataWrapper.maxSell,
        ),
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
      case 5:
        text = 'H';
        break;
      case 4:
        text = 'M2';
        break;
      case 3:
        text = 'M1';
        break;
      case 2:
        text = 'L2';
        break;
      case 1:
        text = 'L1';
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

    if (value.toInt() == -1 || value.toInt() == readyDatesForChart.length) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: const Text(''),
      );
    }

    int index = value.toInt();

    Widget text = Text(
      DateTimeFormat.getPrettyDate(
        DateTime.parse(readyDatesForChart[index]),
      ).substring(0, 6),
    );

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
      List<String> dates, List<double> totalSell, double maxSell) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    List<double> sell = totalSell.map((e) => (e / maxSell) * 5).toList();
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
          days[index].toDouble(),
          sell[index],
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData1_2(
      List<String> dates, List<double> purchaseCost, double maxSell) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    List<double> purchase = purchaseCost.map((e) => (e / maxSell) * 5).toList();
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
          days[index].toDouble(),
          purchase[index],
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData1_3(
      List<String> dates, List<double> profits, double maxSell) {
    int initialDay = totalDays(DateTime.parse(dates[0]));
    List<int> days =
        dates.map((e) => totalDays(DateTime.parse(e)) - initialDay).toList();
    List<double> newProfit = profits.map((e) => (e / maxSell) * 5).toList();
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
          days[index].toDouble(),
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
  final double maxSell;

  _DataWrapper(
    this.purchaseCost,
    this.totalSell,
    this.profit,
    this.dates,
    this.maxSell,
  );
}
