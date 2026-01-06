// questionnaire_section_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/models/questionnare_section.dart';
import 'package:walnut_home_page/provider/questionnaire_section_provider.dart';

class QuestionnaireSectionScreen extends StatefulWidget {
  final String sectionKey;
  final VoidCallback? onComplete;

  const QuestionnaireSectionScreen({
    Key? key,
    required this.sectionKey,
    this.onComplete,
  }) : super(key: key);

  @override
  State<QuestionnaireSectionScreen> createState() =>
      _QuestionnaireSectionScreenState();
}

class _QuestionnaireSectionScreenState
    extends State<QuestionnaireSectionScreen> {
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionnaireSectionProvider>().fetchSection(
        widget.sectionKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuestionnaireSectionProvider>();

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F6F8),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF195DE6)),
        ),
      );
    }

    if (provider.section == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F6F8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to load section',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => provider.fetchSection(widget.sectionKey),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF195DE6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final section = provider.section!;

    if (section.questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F6F8),
        body: Center(child: Text('No questions available')),
      );
    }

    final currentQuestion = section.questions[_currentQuestionIndex];
    final isAnswered = provider.answerFor(currentQuestion.questionKey) != null;
    final canProceed = !currentQuestion.required || isAnswered;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress
            _buildHeader(provider, section),

            // Question content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question title
                    Text(
                      currentQuestion.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.5,
                        color: Color(0xFF111621),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Question options/input
                    _buildQuestionContent(currentQuestion, provider),

                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom action button
      bottomNavigationBar: _buildBottomBar(provider, section, canProceed),
    );
  }

  Widget _buildHeader(
    QuestionnaireSectionProvider provider,
    QuestionnareSection section,
  ) {
    final progress = provider.totalQuestions > 0
        ? (_currentQuestionIndex + 1) / provider.totalQuestions
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F8).withOpacity(0.95),
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.05),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF637588),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),

          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Step ${_currentQuestionIndex + 1} ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF195DE6),
                            ),
                          ),
                          TextSpan(
                            text: 'of ${provider.totalQuestions}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF637588),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${provider.answeredCount} answered',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF637588),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF195DE6),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(
    Question question,
    QuestionnaireSectionProvider provider,
  ) {
    switch (question.type.toLowerCase()) {
      case 'single_choice':
        return _SingleChoiceOptions(
          question: question,
          selectedOption: provider.answerFor(question.questionKey) as String?,
          onSelect: (optionKey) =>
              provider.updateSingleChoice(question.questionKey, optionKey),
        );

      case 'multi_choice':
        return _MultiChoiceOptions(
          question: question,
          selectedOptions:
              provider.answerFor(question.questionKey) as Set<String>?,
          onToggle: (optionKey, selected) => provider.updateMultiChoice(
            question.questionKey,
            optionKey,
            selected,
          ),
        );

      case 'short_text':
        return _ShortTextInput(
          question: question,
          initialValue: provider.answerFor(question.questionKey) as String?,
          onChanged: (text) =>
              provider.updateTextAnswer(question.questionKey, text),
        );

      case 'number':
        return _NumericInput(
          question: question,
          initialValue: provider.answerFor(question.questionKey) as String?,
          onChanged: (text) =>
              provider.updateTextAnswer(question.questionKey, text),
        );

      default:
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange),
          ),
          child: Text(
            'Unknown question type: ${question.type}',
            style: const TextStyle(color: Colors.orange),
          ),
        );
    }
  }

  Widget _buildBottomBar(
    QuestionnaireSectionProvider provider,
    QuestionnareSection section,
    bool canProceed,
  ) {
    final isLastQuestion =
        _currentQuestionIndex >= section.questions.length - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F8).withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  side: const BorderSide(color: Color(0xFF195DE6)),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF195DE6),
                  ),
                ),
              ),
            ),

          if (_currentQuestionIndex > 0) const SizedBox(width: 12),

          Expanded(
            flex: _currentQuestionIndex > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: canProceed
                  ? () async {
                      if (isLastQuestion) {
                        // Save section
                        await _saveSection(provider, section);
                      } else {
                        setState(() {
                          _currentQuestionIndex++;
                        });
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF195DE6),
                disabledBackgroundColor: Colors.grey[300],
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 8,
                shadowColor: const Color(0xFF195DE6).withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastQuestion ? 'Complete' : 'Continue',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isLastQuestion ? Icons.check : Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSection(
    QuestionnaireSectionProvider provider,
    QuestionnareSection section,
  ) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF195DE6)),
        ),
      );

      await provider.saveSection(widget.sectionKey);

      // Close loading
      if (mounted) Navigator.pop(context);

      // Show success and navigate back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Section completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Call the onComplete callback before popping
        widget.onComplete?.call();

        Navigator.pop(context, true); // Return true to indicate completion
      }
    } catch (e) {
      // Close loading
      if (mounted) Navigator.pop(context);

      // Show error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save section: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}

// ==================== OPTION WIDGETS ====================

class _SingleChoiceOptions extends StatelessWidget {
  final Question question;
  final String? selectedOption;
  final Function(String) onSelect;

  const _SingleChoiceOptions({
    required this.question,
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (question.options.isEmpty) {
      return const Text('No options available');
    }

    return Column(
      children: question.options.map((option) {
        final isSelected = selectedOption == option.optionKey;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onSelect(option.optionKey),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF195DE6).withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF195DE6)
                      : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF195DE6).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF195DE6)
                              : const Color(0xFF111621),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Radio indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xFF195DE6)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF195DE6)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MultiChoiceOptions extends StatelessWidget {
  final Question question;
  final Set<String>? selectedOptions;
  final Function(String, bool) onToggle;

  const _MultiChoiceOptions({
    required this.question,
    required this.selectedOptions,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (question.options.isEmpty) {
      return const Text('No options available');
    }

    return Column(
      children: question.options.map((option) {
        final isSelected = selectedOptions?.contains(option.optionKey) ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onToggle(option.optionKey, !isSelected),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF195DE6).withOpacity(0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF195DE6)
                      : const Color(0xFFE5E7EB),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF195DE6)
                              : const Color(0xFF111621),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Checkbox indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isSelected
                            ? const Color(0xFF195DE6)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF195DE6)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ShortTextInput extends HookWidget {
  final Question question;
  final String? initialValue;
  final Function(String) onChanged;

  const _ShortTextInput({
    required this.question,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue ?? '');

    useEffect(() {
      void listener() => onChanged(controller.text);
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: const TextStyle(fontSize: 16, color: Color(0xFF111621)),
        decoration: InputDecoration(
          hintText: 'Type your answer here...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}

class _NumericInput extends HookWidget {
  final Question question;
  final String? initialValue;
  final Function(String) onChanged;

  const _NumericInput({
    required this.question,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue ?? '');

    useEffect(() {
      void listener() => onChanged(controller.text);
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [controller]);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111621),
        ),
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
