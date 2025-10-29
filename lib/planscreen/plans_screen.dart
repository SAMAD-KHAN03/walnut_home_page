import 'package:flutter/material.dart';
import 'package:walnut_home_page/planscreen/models/mock_data.dart';
import 'package:walnut_home_page/planscreen/models/protocol_data.dart';
import 'package:walnut_home_page/planscreen/plan_details_screen.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final mockProtocols = mockdataArray;
  int itemcount = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riya's Plans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ProtocolListView(protocols: mockProtocols),
    );
  }
}

class ProtocolListView extends StatelessWidget {
  final List<ProtocolData> protocols;

  const ProtocolListView({Key? key, required this.protocols}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: protocols.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int index) {
        final data = protocols[index];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    PlanDetailsScreen(mockProtocolData: protocols[index]),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🟦 Title
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🟩 Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: data.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🟨 Phase
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.phase,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        data.phaseDetail,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
