import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../core/theme/app_theme.dart';

class AIPreviewScreen extends ConsumerStatefulWidget {
  const AIPreviewScreen({super.key});

  @override
  ConsumerState<AIPreviewScreen> createState() => _AIPreviewScreenState();
}

class _AIPreviewScreenState extends ConsumerState<AIPreviewScreen> {
  File? _selectedImage;
  bool _isGenerating = false;
  List<Map<String, dynamic>> _generatedPreviews = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _generatedPreviews = [];
        });
      }
    } catch (e) {
      _showError('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _generatePreviews() async {
    if (_selectedImage == null) {
      _showError('Please select an image first');
      return;
    }

    setState(() => _isGenerating = true);

    try {
      // TODO: Call API to generate AI previews
      // final response = await ref.read(aiServiceProvider).generatePreview(_selectedImage!);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock generated previews
      setState(() {
        _generatedPreviews = [
          {
            'id': '1',
            'name': 'Modern Fade',
            'confidence': 0.92,
          },
          {
            'id': '2',
            'name': 'Classic Cut',
            'confidence': 0.88,
          },
          {
            'id': '3',
            'name': 'Textured Crop',
            'confidence': 0.85,
          },
        ];
      });
    } catch (e) {
      _showError('Failed to generate previews: ${e.toString()}');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Style Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Try Before You Style',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your photo to see AI-generated style previews',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Image upload section
            if (_selectedImage == null)
              _buildImageUploadCard()
            else
              _buildSelectedImageCard(),

            const SizedBox(height: 24),

            // Generate button
            if (_selectedImage != null && _generatedPreviews.isEmpty)
              ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generatePreviews,
                icon: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(_isGenerating ? 'Generating...' : 'Generate Previews'),
              ),

            // Generated previews
            if (_generatedPreviews.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'Style Previews',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ..._generatedPreviews.map((preview) => _buildPreviewCard(preview)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                    _generatedPreviews = [];
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Another Photo'),
              ),
            ],

            const SizedBox(height: 32),
            Text(
              'TODO: Integrate with Nano Banana or similar AI service for real style previews',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Upload Your Photo',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a selfie or upload from gallery',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImageCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.file(
            _selectedImage!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Your Photo',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      _generatedPreviews = [];
                    });
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(Map<String, dynamic> preview) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Placeholder for preview image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.style, size: 32, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preview['name'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: AppTheme.successColor),
                      const SizedBox(width: 4),
                      Text(
                        '${(preview['confidence'] * 100).toStringAsFixed(0)}% match',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // TODO: Save or share preview
              },
              icon: const Icon(Icons.bookmark_border),
            ),
          ],
        ),
      ),
    );
  }
}

