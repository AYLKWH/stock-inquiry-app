import 'package:flutter/material.dart';
import 'main.dart' show kRed, kBlue;

String s(dynamic v, {String dash = '---'}) =>
    (v == null || v.toString().isEmpty) ? dash : v.toString();

String num2(dynamic v) =>
    v == null ? '0.00' : (v as num).toDouble().toStringAsFixed(2);
String num3(dynamic v) =>
    v == null ? '0.000' : (v as num).toDouble().toStringAsFixed(3);
String num4(dynamic v) =>
    v == null ? '0.0000' : (v as num).toDouble().toStringAsFixed(4);

/// Outlined label/value box like the ones in the screenshots.
class FieldBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color? valueColor;
  final double minHeight;
  const FieldBox(this.label, this.value,
      {super.key, this.color = kRed, this.valueColor, this.minHeight = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 13)),
          const SizedBox(height: 8),
          Center(
            child: Text(value,
                style: TextStyle(
                    color: valueColor ?? Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

Widget row2(Widget a, Widget b) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ]),
    );

Widget dashHeader(String text, {Color color = kBlue}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text('- - - - - - - - -  $text  - - - - - - - - -',
            style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ),
    );

Widget pad(Widget child) =>
    SingleChildScrollView(padding: const EdgeInsets.all(16), child: child);
