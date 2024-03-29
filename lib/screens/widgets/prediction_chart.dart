import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Widget to draw a chart given the prediction values
class PredictionChart extends StatelessWidget {
  final List<double> predictions;
  final String domain = 'Yield (Kg)';

  const PredictionChart({
    Key key,
    @required this.predictions,
  })  : assert(predictions != null),
        assert(predictions.length == 3),
        super(key: key);

  List<charts.Series<double, String>> _convertData(List<double> prediction) {
    return [
      new charts.Series(
        id: 'value',
        data: [predictions[1]],
        domainFn: (value, _) => domain,
        measureFn: (value, _) => value,
        colorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
      new charts.Series(
        id: 'value',
        data: [predictions[2]],
        domainFn: (value, _) => domain,
        measureFn: (value, _) => value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      new charts.Series(
        id: 'value',
        data: [predictions[1]],
        domainFn: (value, _) => domain,
        measureFn: (value, _) => value,
        colorFn: (_, __) => charts.MaterialPalette.transparent,
      ),
      new charts.Series(
        id: 'value line',
        data: [predictions[0]],
        domainFn: (value, _) => domain,
        measureFn: (value, _) => value,
      )..setAttribute(charts.rendererIdKey, 'customTargetLine')
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      _convertData(predictions),
      animate: true,
      vertical: false,
      barGroupingType: charts.BarGroupingType.stacked,
      customSeriesRenderers: [
        new charts.BarTargetLineRendererConfig<String>(
            // ID used to link series to this renderer.
            customRendererId: 'customTargetLine',
            groupingType: charts.BarGroupingType.stacked)
      ],
    );
  }
}
