/// Bar chart example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:monitoring_apps/model/monitoring.dart';

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withSampleData(Monthly data) {
    return new GroupedBarChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      Monthly data) {
    List<OrdinalSales> desktopSalesData = [];
    List<OrdinalSales> tableSalesData = [];
    data.labelLokasi.asMap().forEach((index, value) => {
          desktopSalesData.insert(
            index,
            new OrdinalSales(data.labelLokasi[index], data.bulanLalu[index]),
          ),
          tableSalesData.insert(
            index,
            new OrdinalSales(data.labelLokasi[index], data.bulanIni[index]),
          )
        });

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Bulan Ini',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Bulan Lalu',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String month;
  final int sales;

  OrdinalSales(this.month, this.sales);
}
