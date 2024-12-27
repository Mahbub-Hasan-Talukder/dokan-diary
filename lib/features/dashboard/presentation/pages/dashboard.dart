import 'package:diary/core/services/date_time_format.dart';
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
                    MergeItem(),
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

    // Combine with decimal part
    return result + decimalPart;
  }

  // DropdownButton<String> _dropdownFilterOptions(BuildContext context) {
  //   return DropdownButton<String>(
  //     isExpanded: true,
  //     value: selectedFilter,
  //     items: ['Today', 'Last Week', 'Last Month', 'Last Year', 'Custom Range']
  //         .map((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: ListTile(
  //           title: Text(value),
  //           textColor: Theme.of(context).colorScheme.primary,
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (String? newValue) async {
  //       if (newValue == 'Custom Range') {
  //         final DateTimeRange? picked = await showDateRangePicker(
  //           context: context,
  //           firstDate: DateTime(2020),
  //           lastDate: DateTime.now(),
  //         );
  //         if (picked != null) {
  //           setState(() {
  //             customDateRange = picked;
  //             selectedFilter = newValue!;
  //           });
  //         }
  //       } else {
  //         setState(() {
  //           selectedFilter = newValue!;
  //           customDateRange = null;
  //         });
  //       }
  //       _applyFilter();
  //     },
  //   );
  // }

  // void _applyFilter() {
  //   DateTime startDate;
  //   DateTime endDate = DateTime.now();

  //   switch (selectedFilter) {
  //     case 'Today':
  //       startDate = DateTime.now().subtract(const Duration(days: 1));
  //     case 'Last Week':
  //       startDate = DateTime.now().subtract(const Duration(days: 7));
  //     case 'Last Month':
  //       startDate = DateTime.now().subtract(const Duration(days: 30));
  //     case 'Last Year':
  //       startDate = DateTime.now().subtract(const Duration(days: 365));
  //     case 'Custom Range':
  //       startDate = customDateRange?.start ?? DateTime.now();
  //       endDate = customDateRange?.end ?? DateTime.now();
  //     default:
  //       startDate = DateTime.now();
  //   }

  // TODO: Implement your filter logic here using startDate and endDate
  // You can fetch and display data based on these dates
  // print('Filtering from $startDate to $endDate');
  // }
}
