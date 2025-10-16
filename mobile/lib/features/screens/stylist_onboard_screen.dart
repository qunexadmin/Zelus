import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';

class StylistOnboardScreen extends ConsumerStatefulWidget {
  const StylistOnboardScreen({super.key});

  @override
  ConsumerState<StylistOnboardScreen> createState() => _StylistOnboardScreenState();
}

class _StylistOnboardScreenState extends ConsumerState<StylistOnboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _bio = TextEditingController();
  final _specialties = <String>{};

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _toggleSpecialty(String s) {
    setState(() {
      if (_specialties.contains(s)) {
        _specialties.remove(s);
      } else {
        _specialties.add(s);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stylist profile created (mock).')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Become a Stylist')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(prefixText: '@', labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bio,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Text('Specialties', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Haircut', 'Color', 'Balayage', 'Highlights', 'Styling', 'Barber', 'Nails', 'Spa'
                ].map((s) {
                  final selected = _specialties.contains(s);
                  return ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) => _toggleSpecialty(s),
                    selectedColor: AppTheme.primaryColor.withOpacity(0.15),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Create Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



