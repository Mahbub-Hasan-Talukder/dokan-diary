import 'package:flutter/material.dart';
import '../widgets/filter_options.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // String selectedFilter = 'Last Month';
  // DateTimeRange? customDateRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Column(
        children: [
          const FilterOptions(),

          // if (customDateRange != null)
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Selected Range: ${customDateRange!.start.toString().split(' ')[0]} to ${customDateRange!.end.toString().split(' ')[0]}',
          //     ),
          //   ),
          const Expanded(
            child: Center(
              child: Text('Dashboard Content'),
            ),
          ),
        ],
      ),
    );
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
