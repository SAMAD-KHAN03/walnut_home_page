import 'package:flutter/material.dart';

class Abc extends StatefulWidget {
  const Abc({super.key});

  @override
  State<Abc> createState() => _AbcState();
}

class _AbcState extends State<Abc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abc'),
      ),
      body: const Center(
        child: Text('Hello from Abc'),
      ),
    );
  }
}