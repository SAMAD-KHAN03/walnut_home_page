import 'package:flutter/material.dart';

class LabParameterCard extends StatelessWidget {
  final String parameterName;
  final String observedValue;
  final String normalRange;
  final String shortTip;
  final Color? accentColor;

  const LabParameterCard({
    Key? key,
    required this.parameterName,
    required this.observedValue,
    required this.normalRange,
    required this.shortTip,
    this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.orange;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Parameter Name
            Text(
              parameterName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Values Row
            Row(
              children: [
                // Observed Value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Value',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        observedValue,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  height: 35,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),

                // Normal Range
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Normal Range',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        normalRange,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Divider
            Divider(color: Colors.grey[300], height: 1),

            const SizedBox(height: 10),

            // Tip Section
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      shortTip,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[800],
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example Usage - Standalone Widget
class LabResultsScreen extends StatelessWidget {
  const LabResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Heading
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Report Analysis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(onPressed: () {}, child: Text("View Details")),
            ],
          ),
        ),

        // Horizontal scrolling cards
        SizedBox(
          height: 190,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: const [
              LabParameterCard(
                parameterName: 'Bilirubin, Direct',
                observedValue: '0.32 mg/dL',
                normalRange: '0-0.3 mg/dL',
                shortTip:
                    'Slightly high; mainly points to potential bile duct or liver focus. Needs Doctor review.',
                accentColor: Colors.orange,
              ),
              LabParameterCard(
                parameterName: 'Red Blood Cells (RBC) Count',
                observedValue: '5.49 mill/mm³',
                normalRange: '4.5-5.5 mill/mm³',
                shortTip:
                    'At the high end of normal; could be related to hydration. Follow-up with a doctor.',
                accentColor: Colors.amber,
              ),
              LabParameterCard(
                parameterName: 'Mean Platelet Volume (MPV)',
                observedValue: '13.1 fL',
                normalRange: '7-13 fL',
                shortTip:
                    'Slightly high (platelets are larger); needs context from a doctor.',
                accentColor: Colors.orange,
              ),
              LabParameterCard(
                parameterName: 'Vitamin B12 (Cyanocobalamin)',
                observedValue: '217 pg/mL',
                normalRange: '107.2-653.3 pg/mL',
                shortTip:
                    'Low-end of normal; check with a doctor about potential supplements or diet changes.',
                accentColor: Colors.deepOrange,
              ),
              LabParameterCard(
                parameterName: 'Thyroid Stimulating Hormone (TSH)',
                observedValue: '3.764 µlU/mL',
                normalRange: '0.4-4.049 µlU/mL',
                shortTip:
                    'At the high end of normal; may need re-testing and Free T4 check.',
                accentColor: Colors.amber,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Full Screen Version (if needed)
class LabResultsFullScreen extends StatelessWidget {
  const LabResultsFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Lab Results'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: const SingleChildScrollView(child: LabResultsScreen()),
    );
  }
}
