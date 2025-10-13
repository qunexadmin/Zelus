import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/services/oembed_service.dart';
import '../../data/models/oembed_data.dart';

/// Embedded Post Widget
/// Renders external platform posts (Instagram, TikTok) using oEmbed
class EmbeddedPostWidget extends ConsumerStatefulWidget {
  final String url;
  final double? height;

  const EmbeddedPostWidget({
    super.key,
    required this.url,
    this.height = 480,
  });

  @override
  ConsumerState<EmbeddedPostWidget> createState() => _EmbeddedPostWidgetState();
}

class _EmbeddedPostWidgetState extends ConsumerState<EmbeddedPostWidget> {
  late WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEmbed();
  }

  Future<void> _loadEmbed() async {
    try {
      final service = ref.read(oembedServiceProvider);
      final data = await service.fetch(widget.url);

      if (data == null) {
        setState(() {
          _error = 'Failed to load embed';
          _isLoading = false;
        });
        return;
      }

      _initializeWebView(data);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _initializeWebView(OEmbedData data) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadHtmlString(_buildHtmlWrapper(data))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      );
  }

  String _buildHtmlWrapper(OEmbedData data) {
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              margin: 0;
              padding: 0;
              display: flex;
              justify-content: center;
              align-items: center;
              min-height: 100vh;
              background: #fff;
            }
            .embed-container {
              max-width: 100%;
            }
          </style>
          ${_getPlatformScript(data.platform)}
        </head>
        <body>
          <div class="embed-container">
            ${data.html}
          </div>
        </body>
      </html>
    ''';
  }

  String _getPlatformScript(String platform) {
    switch (platform) {
      case 'instagram':
        return '<script async src="//www.instagram.com/embed.js"></script>';
      case 'tiktok':
        return '<script async src="https://www.tiktok.com/embed.js"></script>';
      case 'pinterest':
        return '<script async defer src="//assets.pinterest.com/js/pinit.js"></script>';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // WebView Content
          if (!_isLoading && _error == null)
            WebViewWidget(controller: _controller),

          // Loading State
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Error State
          if (_error != null)
            _buildErrorState(),

          // Attribution Footer
          if (!_isLoading && _error == null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildAttributionFooter(),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Unable to load post',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _openInBrowser(widget.url),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open in Browser'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributionFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
      ),
      child: Row(
        children: [
          Icon(
            _getPlatformIcon(),
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Content from ${_getPlatformName()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _openInBrowser(widget.url),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Open', style: TextStyle(fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.open_in_new, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon() {
    if (widget.url.contains('instagram')) return Icons.photo_camera;
    if (widget.url.contains('tiktok')) return Icons.music_note;
    if (widget.url.contains('pinterest')) return Icons.push_pin;
    return Icons.link;
  }

  String _getPlatformName() {
    if (widget.url.contains('instagram')) return 'Instagram';
    if (widget.url.contains('tiktok')) return 'TikTok';
    if (widget.url.contains('pinterest')) return 'Pinterest';
    return 'External';
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

