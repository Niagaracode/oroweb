import 'package:flutter/material.dart';

class DynamicTableLayout extends StatelessWidget {
  final String title;
  final List<String> pumpNames;
  final List<String> pumpTypes;
  final List<List<Widget>> cellWidgets;
  final BuildContext context;

  const DynamicTableLayout({super.key,
    required this.pumpNames,
    required this.pumpTypes,
    required this.cellWidgets,
    required this.context, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableRows(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    final List<Widget> headerChildren = [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Text(title , style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    ];

    for (final type in pumpTypes) {
      headerChildren.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
    }

    return Table(
      columnWidths: {
        0: const FlexColumnWidth(1.5),
        for (int i = 1; i < pumpTypes.length + 1; i++) i: const FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          children: headerChildren,
        ),
      ],
    );
  }

  Widget _buildTableRows() {
    final List<TableRow> rows = [];

    for (int index = 0; index < pumpNames.length; index++) {
      final String pump = pumpNames[index];
      final List<Widget> rowChildren = [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Text(pump),
            ),
          ),
        ),
      ];

      for (final widget in cellWidgets[index]) {
        rowChildren.add(
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Center(child: widget),
          ),
        );
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? null : Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          children: rowChildren,
        ),
      );
    }

    return Table(
      columnWidths: {
        0: const FlexColumnWidth(1.5),
        for (int i = 1; i < pumpTypes.length + 1; i++) i: const FlexColumnWidth(1),
      },
      children: rows,
    );
  }
}
