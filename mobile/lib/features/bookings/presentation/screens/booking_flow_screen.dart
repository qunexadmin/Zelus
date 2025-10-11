import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final String? stylistId;
  final String? serviceId;
  
  const BookingFlowScreen({
    super.key,
    this.stylistId,
    this.serviceId,
  });

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  int _currentStep = 0;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String? _selectedService;
  final _notesController = TextEditingController();

  final List<String> _availableTimeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _handleStepContinue,
        onStepCancel: _handleStepCancel,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Confirm Booking' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Select Service'),
            content: _buildServiceStep(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Select Date'),
            content: _buildDateStep(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Select Time'),
            content: _buildTimeStep(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment & Confirm'),
            content: _buildPaymentStep(),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStep() {
    return Column(
      children: [
        _buildServiceOption('Haircut & Style', 45, 50.0, 'service-1'),
        _buildServiceOption('Color Treatment', 90, 120.0, 'service-2'),
        _buildServiceOption('Balayage', 120, 180.0, 'service-3'),
        _buildServiceOption('Styling Only', 30, 35.0, 'service-4'),
      ],
    );
  }

  Widget _buildServiceOption(String name, int duration, double price, String id) {
    final isSelected = _selectedService == id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      child: ListTile(
        title: Text(name),
        subtitle: Text('$duration min'),
        trailing: Text(
          '\$${price.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        onTap: () => setState(() => _selectedService = id),
      ),
    );
  }

  Widget _buildDateStep() {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 90)),
      focusedDay: _selectedDate,
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _selectedDate = selectedDay);
      },
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available times for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTimeSlots.map((time) {
            final isSelected = _selectedTime == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedTime = selected ? time : null);
              },
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Booking summary
        Text(
          'Booking Summary',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow('Service', 'Haircut & Style'),
                const Divider(height: 24),
                _buildSummaryRow('Date', DateFormat('MMM dd, yyyy').format(_selectedDate)),
                const Divider(height: 24),
                _buildSummaryRow('Time', _selectedTime ?? 'Not selected'),
                const Divider(height: 24),
                _buildSummaryRow('Duration', '45 min'),
                const Divider(height: 24),
                _buildSummaryRow(
                  'Total',
                  '\$50.00',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Notes
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Additional Notes (Optional)',
            hintText: 'Any specific requests or preferences...',
          ),
        ),
        const SizedBox(height: 24),
        
        // Payment method (placeholder)
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Card ending in 4242'),
            trailing: TextButton(
              onPressed: () {
                // TODO: Change payment method
              },
              child: const Text('Change'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'TODO: Integrate with Stripe for payment processing',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textTertiary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppTheme.primaryColor : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  void _handleStepContinue() {
    if (_currentStep == 0 && _selectedService == null) {
      _showError('Please select a service');
      return;
    }
    if (_currentStep == 2 && _selectedTime == null) {
      _showError('Please select a time slot');
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Final step - create booking
      _createBooking();
    }
  }

  void _handleStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _createBooking() async {
    // TODO: Call API to create booking
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 64,
          ),
          title: const Text('Booking Confirmed!'),
          content: const Text(
            'Your appointment has been successfully booked. You will receive a confirmation email shortly.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
  }
}

