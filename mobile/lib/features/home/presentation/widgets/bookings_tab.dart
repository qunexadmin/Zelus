import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// Temporarily disabled in social-only MVP
// Keeping file to avoid breaking imports if referenced elsewhere.
import '../../../../core/theme/app_theme.dart';

class BookingsTab extends ConsumerWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch bookings from API
    // final bookings = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Upcoming bookings
          Text(
            'Upcoming',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildBookingCard(
            context,
            'Modern Haircut',
            'Jane Smith',
            'Elite Salon',
            DateTime.now().add(const Duration(days: 2)),
            'confirmed',
          ),
          const SizedBox(height: 12),
          _buildBookingCard(
            context,
            'Balayage Color',
            'Sarah Johnson',
            'Color Studio',
            DateTime.now().add(const Duration(days: 5)),
            'pending',
          ),
          
          const SizedBox(height: 32),
          
          // Past bookings
          Text(
            'Past',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildBookingCard(
            context,
            'Classic Cut',
            'Mike Brown',
            'Downtown Barbers',
            DateTime.now().subtract(const Duration(days: 15)),
            'completed',
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    String serviceName,
    String stylistName,
    String salonName,
    DateTime dateTime,
    String status,
  ) {
    Color statusColor;
    String statusText;
    
    switch (status) {
      case 'confirmed':
        statusColor = AppTheme.successColor;
        statusText = 'Confirmed';
        break;
      case 'pending':
        statusColor = AppTheme.accentColor;
        statusText = 'Pending';
        break;
      case 'completed':
        statusColor = AppTheme.textSecondary;
        statusText = 'Completed';
        break;
      default:
        statusColor = AppTheme.textTertiary;
        statusText = status;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  serviceName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(
                  stylistName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.store, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(
                  salonName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.textSecondary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (status == 'confirmed' || status == 'pending') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Cancel booking
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: View details or reschedule
                      },
                      child: const Text('Details'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

