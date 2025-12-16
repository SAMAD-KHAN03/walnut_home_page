import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:walnut_home_page/healt_expert_screens/customer_health_experts.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/utility/utility_function_class.dart';

class HealthExpert_Screen extends StatefulWidget {
  const HealthExpert_Screen({super.key});

  @override
  State<HealthExpert_Screen> createState() => _HealthExpert_Screen();
}

class _HealthExpert_Screen extends State<HealthExpert_Screen> {
  late List<SearchFieldListItem<HealthExpert>> healthexperts;
  late List<HealthExpert> allExperts;
  SearchFieldListItem<HealthExpert>? _selected;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _isSearching = false;
  String? _selectedFilter;
  File? selectedfile;

  @override
  void initState() {
    super.initState();
    healthexperts = [];
    allExperts = [];
    _fetchHealthExpert();
    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHealthExpert() async {
    // simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Raw HealthExpert list (use Strings for `type` via enum.name)
    final rawExperts = <HealthExpert>[
      HealthExpert(
        id: "1",
        name: "Dr. Aarav Mehta",
        type: Type.fitnessCoach.name,
        imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=Aarav",
        description:
            "Dr. Aarav Mehta is a certified strength and conditioning specialist with over 12 years of experience in sports rehabilitation and performance optimization. He helps clients build sustainable fitness routines focusing on mobility, strength balance, and recovery. Aarav has worked with professional athletes and corporate teams to improve endurance, posture, and mental resilience through structured fitness programs.",
        latestwebinar: DateTime(2025, 10, 25, 18, 30),
        oneToOneMeet: [
          DateTime(2025, 11, 1, 10, 0),
          DateTime(2025, 11, 2, 12, 0),
          DateTime(2025, 11, 4, 18, 30),
        ],
        rating: "4.5",
        location: "Jaipur",
        privatewebinarUrl: "",
        publicWebinarUrl: "https://meet.google.com/yye-wzrt-oso",
      ),
      HealthExpert(
        id: "2",
        name: "Dr. Ananya Kapoor",
        type: Type.gynecologist.name,
        imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=Ananya",
        description:
            "Dr. Ananya Kapoor is a senior gynecologist and women's health specialist with a focus on hormonal health, fertility, and menstrual wellness. She integrates modern gynecological science with lifestyle interventions to help women achieve hormonal balance and reproductive well-being. Her sessions often include education on PCOS management, prenatal care, and postnatal recovery.",
        latestwebinar: DateTime(2025, 10, 28, 17, 0),
        oneToOneMeet: [
          DateTime(2025, 11, 2, 15, 0),
          DateTime(2025, 11, 4, 16, 30),
          DateTime(2025, 11, 5, 18, 0),
        ],
        rating: "3.9",
        location: "Dharwad",
        privatewebinarUrl: "",
        publicWebinarUrl: "https://meet.google.com/yye-wzrt-oso",
      ),
      HealthExpert(
        id: "3",
        name: "Dr. Raghav Sinha",
        type: Type.andrologist.name,
        imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=Raghav",
        description:
            "Dr. Raghav Sinha is a leading andrologist specializing in men's reproductive health, hormonal therapy, and sexual wellness. He emphasizes preventive care, testosterone optimization, and lifestyle modifications for better metabolic health. His consultations are known for their openness and focus on destigmatizing men's health issues through awareness and holistic care.",
        latestwebinar: DateTime(2025, 10, 29, 19, 0),
        oneToOneMeet: [
          DateTime(2025, 11, 3, 10, 0),
          DateTime(2025, 11, 5, 11, 30),
          DateTime(2025, 11, 6, 17, 0),
        ],
        rating: "4.0",
        location: "Delhi",
        privatewebinarUrl: "",
        publicWebinarUrl: "https://meet.google.com/yye-wzrt-oso",
      ),
      HealthExpert(
        id: "4",
        name: "Dr. Meera Iyer",
        type: Type.psyotherapist.name,
        imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=Meera",
        description:
            "Dr. Meera Iyer is a licensed psychotherapist with over 15 years of experience in cognitive behavioral therapy (CBT), trauma recovery, and mindfulness-based therapy. She helps clients manage stress, anxiety, and emotional burnout using evidence-based psychological techniques. Her practice integrates neuroscience, behavioral tracking, and compassion-centered therapy.",
        latestwebinar: DateTime(2025, 10, 30, 20, 0),
        oneToOneMeet: [
          DateTime(2025, 11, 1, 11, 0),
          DateTime(2025, 11, 3, 14, 0),
          DateTime(2025, 11, 5, 19, 0),
        ],
        rating: "4.8",
        location: "Bangalore",
        privatewebinarUrl: "",
        publicWebinarUrl: "https://meet.google.com/yye-wzrt-oso",
      ),
      HealthExpert(
        id: "5",
        name: "Dr. Neel Rajan",
        type: Type.fitnessCoach.name,
        imageUrl: "https://api.dicebear.com/7.x/avataaars/png?seed=Neel",
        description:
            "Dr. Neel Rajan is a functional movement and strength optimization coach who focuses on injury prevention and posture correction. His programs combine resistance training, flexibility, and breathwork to enhance body control and long-term mobility. Neel's sessions are data-driven, utilizing wearable analytics to personalize every client's training intensity and recovery cycle.",
        latestwebinar: DateTime(2025, 10, 27, 18, 0),
        oneToOneMeet: [
          DateTime(2025, 11, 2, 17, 0),
          DateTime(2025, 11, 3, 18, 30),
          DateTime(2025, 11, 6, 9, 30),
        ],
        rating: "3.8",
        location: "Mumbai",
        privatewebinarUrl: "",
        publicWebinarUrl: "https://meet.google.com/yye-wzrt-oso",
      ),
    ];

    // Map raw list to SearchFieldListItem<HealthExpert>
    allExperts = rawExperts;
    _applyFilter();

    // update UI
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilter() {
    List<HealthExpert> filteredExperts;

    if (_selectedFilter == null || _selectedFilter == 'All') {
      filteredExperts = allExperts;
    } else {
      filteredExperts = allExperts
          .where((expert) => expert.type == _selectedFilter)
          .toList();
    }

    healthexperts = filteredExperts
        .map(
          (h) => SearchFieldListItem<HealthExpert>(
            h.name,
            item: h,
            child: _buildSearchItem(h),
          ),
        )
        .toList();
  }

  Widget _buildSearchItem(HealthExpert expert) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(expert.imageUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              expert.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 'All',
          child: Row(
            children: [
              Icon(
                _selectedFilter == null || _selectedFilter == 'All'
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: Colors.teal,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text('All Experts'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Type.fitnessCoach.name,
          child: Row(
            children: [
              Icon(
                _selectedFilter == Type.fitnessCoach.name
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: Colors.teal,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text('Fitness Coach'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Type.gynecologist.name,
          child: Row(
            children: [
              Icon(
                _selectedFilter == Type.gynecologist.name
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: Colors.teal,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text('Gynecologist'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Type.andrologist.name,
          child: Row(
            children: [
              Icon(
                _selectedFilter == Type.andrologist.name
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: Colors.teal,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text('Andrologist'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Type.psyotherapist.name,
          child: Row(
            children: [
              Icon(
                _selectedFilter == Type.psyotherapist.name
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: Colors.teal,
                size: 20,
              ),
              const SizedBox(width: 12),
              const Text('Psychotherapist'),
            ],
          ),
        ),
      ],
      elevation: 8,
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedFilter = value == 'All' ? null : value;
          _applyFilter();
        });
      }
    });
  }

  Future<void> pickfile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedfile = File(result.files.single.path!);
        log(selectedfile.runtimeType.toString());
      });
    } else {
      log("user canceled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Experts'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CustomerHealthExperts(),
                            ),
                          );
                        },
                        child: Text("Your Experts"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                      child: TextButton(
                        onPressed: () async {
                          await pickfile();
                        },
                        child: Text("Upload Health Report"),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchField<HealthExpert>(
                          controller: _searchController,
                          suggestions: healthexperts,
                          suggestionState: Suggestion.expand,
                          hint: 'Search for health experts...',
                          searchInputDecoration: SearchInputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _isSearching
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.teal,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          maxSuggestionsInViewPort: 4,
                          itemHeight: 60,
                          onSuggestionTap: (suggestion) {
                            UtilityFunctionClass.navigateToDetails(
                              suggestion.item!,
                              context,
                              true,
                            );
                            _searchController.clear();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: _selectedFilter != null
                              ? Colors.teal
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFilter != null
                                ? Colors.teal
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_list,
                            color: _selectedFilter != null
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                          onPressed: _showFilterMenu,
                          tooltip: 'Filter by type',
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedFilter != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Chip(
                      label: Text(
                        'Filter: ${UtilityFunctionClass.formatType(_selectedFilter!)}',
                      ),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedFilter = null;
                          _applyFilter();
                        });
                      },
                      backgroundColor: Colors.teal[50],
                      labelStyle: const TextStyle(color: Colors.teal),
                      deleteIconColor: Colors.teal,
                    ),
                  ),
                if (!_isSearching)
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                0.78, // Adjust for proportions like the screenshot
                          ),
                      itemCount: healthexperts.length,
                      itemBuilder: (context, index) {
                        final expert = healthexperts[index].item!;
                        return GestureDetector(
                          onTap: () {
                            UtilityFunctionClass.navigateToDetails(
                              expert,
                              context,
                              true,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                CircleAvatar(
                                  radius: 34,
                                  backgroundImage: NetworkImage(
                                    expert.imageUrl,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  expert.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  UtilityFunctionClass.formatType(expert.type),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 0.8,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber.shade600,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        expert.rating,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Start typing to search...',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

// ignore: must_be_immutable
class HealthExpertDetailScreen extends StatelessWidget {
  final HealthExpert expert;
  bool showAddButton;
  HealthExpertDetailScreen({
    super.key,
    required this.expert,
    required this.showAddButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(expert.name),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(expert.imageUrl),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    expert.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    UtilityFunctionClass.formatType(expert.type),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    expert.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Latest Webinar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      UtilityFunctionClass.launchGoogleMeet(
                        expert.publicWebinarUrl,
                      );
                    },
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        leading: Icon(Icons.video_library, color: Colors.teal),
                        title: Text('Upcoming Webinar'),
                        subtitle: Text(
                          UtilityFunctionClass.formatDateTime(
                            expert.latestwebinar,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Available Slots for One-to-One Meeting',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...expert.oneToOneMeet.map(
                    (slot) => Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Colors.teal,
                        ),
                        title: Text(UtilityFunctionClass.formatDateTime(slot)),
                        trailing: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Booking slot: ${UtilityFunctionClass.formatDateTime(slot)}',
                                ),
                                backgroundColor: Colors.teal,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Book'),
                        ),
                      ),
                    ),
                  ),
                  if (showAddButton)
                    Center(
                      child: IgnorePointer(
                        ignoring: context
                            .watch<CustomerHealthExpertProvider>()
                            .expertslist
                            .any((item) => item.id == expert.id),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.read<CustomerHealthExpertProvider>().add(
                              expert,
                            );
                            context
                                    .read<CustomerHealthExpertProvider>()
                                    .expertslist
                                    .any((item) => item.id == expert.id)
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Health Expert Added to your Profile",
                                      ),
                                    ),
                                  )
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Health Expert Already Addedd",
                                      ),
                                    ),
                                  );
                          },
                          child: Text("Consult the Health Expert"),
                        ),
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

enum Type { fitnessCoach, gynecologist, andrologist, psyotherapist }

class HealthExpert {
  String id;
  String name;
  String description;
  DateTime latestwebinar;
  String type;
  String imageUrl;
  List<DateTime> oneToOneMeet;
  String rating;
  String location;
  String publicWebinarUrl;
  String privatewebinarUrl;
  HealthExpert({
    required this.id,
    required this.name,
    required this.description,
    required this.latestwebinar,
    required this.oneToOneMeet,
    required this.type,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.publicWebinarUrl,
    required this.privatewebinarUrl,
  });
}
