import 'package:diary/core/services/date_time_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di.dart';
import '../../../records/domain/entities/day_wise_entity.dart';
import '../../../records/presentation/bloc/day_wise_records/day_wise_cubit.dart';
import '../widgets/filter_options.dart';
import '../widgets/line_chart.dart';
import '../widgets/merge_item.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _dayWiseCubit = getIt.get<DayWiseCubit>();

  @override
  void initState() {
    _dayWiseCubit.fetchDateWiseRecords(
      startDate: DateTimeFormat.getYMD(
        DateTime.now().subtract(const Duration(days: 30)),
      ),
      endDate: DateTimeFormat.getYMD(
        DateTime.now(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          FilterOptions(dayWiseCubit: _dayWiseCubit),
          BlocBuilder<DayWiseCubit, DayWiseState>(
            bloc: _dayWiseCubit,
            builder: (context, state) {
              if (state is DayWiseSuccess) {
                return Column(
                  children: [
                    _shortSummary(state.records),
                    const SizedBox(height: 16),
                    (state.records.isEmpty)
                        ? const Text('No data to show')
                        : LineChartSample1(records: state.records),
                    const SizedBox(height: 16),
                    const MergeItem(),
                  ],
                );
              }
              if (state is DayWiseError) {
                return Center(child: Text(state.error));
              }
              if (state is DayWiseLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _shortSummary(List<DayWiseEntity> records) {
    double totalSell = 0;
    double totalBuy = 0;
    for (var record in records) {
      totalSell += record.totalSell ?? 0;
      totalBuy += record.purchaseCost ?? 0;
    }
    double profit = totalSell - totalBuy;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   'Summary',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem(
                  'Total Sales',
                  totalSell,
                  Colors.blue,
                ),
                _summaryItem(
                  'Total Purchase',
                  totalBuy,
                  Colors.orange,
                ),
                _summaryItem(
                  'Total Profit',
                  profit,
                  profit >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _commaSeparatedString(amount.toStringAsFixed(2)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _commaSeparatedString(String num) {
    // Split the number into whole and decimal parts
    List<String> parts = num.split('.');
    String wholePart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Add commas to the whole part
    final RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String result = wholePart.replaceAllMapped(
      reg,
      (Match match) => '${match[1]},',
    );
    return result + decimalPart;
  }
}















  // LineChartData getSampleData1() => LineChartData(
  //       gridData: gridData,
  //       titlesData: titlesData,
  //       // lineTouchData: lineTouchData,
  //       lineBarsData: lineBarsData,
  //       borderData: borderData,
  //       minX: 0,
  //       maxX: 14,
  //       minY: 0,
  //       maxY: 4,
  //     );

  // List<LineChartBarData> get lineBarsData => [
  //       lineChartBarsData,
  //     ];

  // FlTitlesData get titlesData => FlTitlesData(
  //       show: true,
  //       leftTitles: AxisTitles(sideTitles: leftTiles()),
  //       bottomTitles: AxisTitles(sideTitles: bottomTiles),
  //       rightTitles:
  //           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //     );

  // Widget leftTileWidget(double value, TitleMeta meta) {
  //   final style = TextStyle(
  //     fontSize: 12,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.black,
  //   );
  //   String? text;
  //   switch (value.toInt()) {
  //     case 1:
  //       text = '1M';
  //       break;
  //     case 2:
  //       text = '2M';
  //       break;
  //     case 3:
  //       text = '3M';
  //       break;
  //     case 4:
  //       text = '4M';
  //       break;
  //     case 5:
  //       text = '5M';
  //       break;
  //     default:
  //       return const SizedBox.shrink();
  //   }

  //   return Text(text, style: style, textAlign: TextAlign.center);
  // }

  // SideTitles leftTiles() => SideTitles(
  //       getTitlesWidget: leftTileWidget,
  //       showTitles: true,
  //       reservedSize: 40,
  //       interval: 1,
  //     );

  // Widget bottomTileWidget(double value, TitleMeta meta) {
  //   final style = TextStyle(
  //     fontSize: 12,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.black,
  //   );
  //   String? text;
  //   switch (value.toInt()) {
  //     case 0:
  //       text = '2021-01 ';
  //       break;
  //     case 1:
  //       text = '2022-01';
  //       break;
  //     case 2:
  //       text = '2023-01';
  //       break;
  //     default:
  //       text = '';
  //   }
  //   Widget textWidget = Text(text, style: style, textAlign: TextAlign.center);
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,

  //     space: 10,
  //     child: textWidget,
  //   );
  // }

  // SideTitles get bottomTiles => SideTitles(
  //       getTitlesWidget: bottomTileWidget,
  //       showTitles: true,
  //       reservedSize: 40,
  //       interval: 1,
  //     );

  // FlGridData get gridData => const FlGridData(
  //       show: false,
  //     );

  // FlBorderData get borderData => FlBorderData(
  //       show: true,
  //       border: Border.all(color: Colors.grey, width: 1),
  //     );

  // LineChartBarData get lineChartBarsData => LineChartBarData(
  //       isCurved: true,
  //       color: Colors.blue,
  //       barWidth: 2,
  //       isStrokeCapRound: true,
  //       dotData: FlDotData(
  //         show: false,
  //       ),
  //       belowBarData: BarAreaData(
  //         show: true,
  //         color: Colors.blue.withOpacity(0.1),
  //       ),
  //       spots: [
  //         FlSpot(0, 1),
  //         FlSpot(6, 2),
  //         FlSpot(12, 3),
  //       ],
  //     );