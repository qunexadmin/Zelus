import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/feature_flags.dart';
import '../../../../ai/vision/auto_tagger.dart';
import '../../../../ai/caption/caption_suggester.dart';
import '../../../../data/services/cloudflare_stream_service.dart';

/// Upload Screen
/// Content upload interface with AI assistance
class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _captionController = TextEditingController();
  File? _selectedFile;
  String _mediaType = 'photo';
  List<String> _tags = [];
  List<String> _suggestedCaptions = [];
  bool _isUploading = false;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
        actions: [
          TextButton(
            onPressed: _isUploading ? null : _handleUpload,
            child: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Post'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Media picker
            if (_selectedFile == null) _buildMediaPicker() else _buildMediaPreview(),
            
            const SizedBox(height: 16),
            
            // Caption field
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
                hintText: 'Write a caption...',
              ),
              maxLines: 3,
            ),
            
            // Caption suggestions
            if (FeatureFlags.aiCaptionSuggestions && _suggestedCaptions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'AI Suggestions:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedCaptions.map((caption) {
                  return ActionChip(
                    label: Text(
                      caption,
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      _captionController.text = caption;
                    },
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Tags
            if (_tags.isNotEmpty) ...[
              Text(
                'Auto-detected tags:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() => _tags.remove(tag));
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPicker() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Select a photo or video',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickMedia(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickMedia(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaPreview() {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: _mediaType == 'photo'
              ? Image.file(_selectedFile!, fit: BoxFit.cover)
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(color: Colors.black),
                    const Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            _selectedFile = null;
            _tags = [];
            _suggestedCaptions = [];
          }),
          icon: const Icon(Icons.close),
          label: const Text('Remove'),
        ),
      ],
    );
  }

  Future<void> _pickMedia(ImageSource source) async {
    final picker = ImagePicker();
    
    // Pick image
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
        _mediaType = 'photo';
      });
      await _processMedia();
    }
  }

  Future<void> _processMedia() async {
    if (_selectedFile == null) return;

    // Auto-tag
    if (FeatureFlags.aiAutoTagging) {
      final autoTagger = ref.read(autoTaggerProvider);
      final tags = await autoTagger.detectTagsFromImage(_selectedFile!);
      setState(() => _tags = tags);
    }

    // Generate caption suggestions
    if (FeatureFlags.aiCaptionSuggestions) {
      final captionSuggester = ref.read(captionSuggesterProvider);
      final captions = await captionSuggester.generateCaptions(
        imageFile: _selectedFile,
        tags: _tags,
      );
      setState(() => _suggestedCaptions = captions);
    }
  }

  Future<void> _handleUpload() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo or video')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // TODO: Implement actual upload to backend
      if (_mediaType == 'video' && FeatureFlags.videoUpload) {
        final streamService = ref.read(cloudflareStreamServiceProvider);
        await streamService.uploadVideo(_selectedFile!);
      }

      await Future.delayed(const Duration(seconds: 2)); // Simulate upload

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Posted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }
}

