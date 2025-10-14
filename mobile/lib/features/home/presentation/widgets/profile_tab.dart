import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get user from auth state
    // final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Demo User',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'demo@zelux.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // NEW: Quick Access Section
          Text(
            'Quick Access',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  'Trending',
                  Icons.trending_up,
                  Colors.orange,
                  () => context.push('/trending'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  'Upload',
                  Icons.add_photo_alternate,
                  Colors.blue,
                  () => context.push('/upload'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  'Reels',
                  Icons.play_circle_filled,
                  Colors.purple,
                  () => context.push('/reels'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAccessCard(
                  context,
                  'AI Preview',
                  Icons.auto_awesome,
                  Colors.green,
                  () => context.push('/ai-preview'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Menu items
          _buildMenuItem(
            context,
            'Edit Profile',
            Icons.edit_outlined,
            () {
              // TODO: Navigate to edit profile
            },
          ),
          _buildMenuItem(
            context,
            'Payment Methods',
            Icons.payment_outlined,
            () {
              // TODO: Navigate to payment methods
            },
          ),
          _buildMenuItem(
            context,
            'Notifications',
            Icons.notifications_outlined,
            () {
              // TODO: Navigate to notifications settings
            },
          ),
          _buildMenuItem(
            context,
            'Help & Support',
            Icons.help_outline,
            () {
              // TODO: Navigate to help
            },
          ),
          _buildMenuItem(
            context,
            'Settings',
            Icons.settings_outlined,
            () {
              // TODO: Navigate to settings
            },
          ),
          
          const SizedBox(height: 16),
          
          // Logout button
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement logout
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

