import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

/// Chat Message Model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? senderName;
  final String? senderPhoto;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.senderName,
    this.senderPhoto,
  });
}

/// Chat Screen
/// Unified messaging with AI assistant + direct stylist chat
class ChatScreen extends ConsumerStatefulWidget {
  final String? recipientId;
  final String? recipientName;
  final String? recipientPhoto;

  const ChatScreen({
    super.key,
    this.recipientId,
    this.recipientName,
    this.recipientPhoto,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isAIChat = false;

  @override
  void initState() {
    super.initState();
    _isAIChat = widget.recipientId == null;
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    // Mock messages
    if (_isAIChat) {
      _messages.addAll([
        ChatMessage(
          id: '1',
          content: 'Hi! I\'m your Zelus AI assistant. I can help you find stylists, answer questions about services, or provide hair care advice. How can I help you today?',
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          senderName: 'Zelus AI',
        ),
      ]);
    } else if (widget.recipientName != null) {
      _messages.addAll([
        ChatMessage(
          id: '1',
          content: 'Hi! Thanks for reaching out. How can I help you?',
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          senderName: widget.recipientName,
          senderPhoto: widget.recipientPhoto,
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
        ),
        title: Row(
          children: [
            if (_isAIChat)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple.shade400,
                      Colors.blue.shade400,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              )
            else if (widget.recipientPhoto != null)
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.recipientPhoto!),
              )
            else
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryColor,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isAIChat ? 'AI Assistant' : widget.recipientName ?? 'Chat',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (_isAIChat)
                    const Text(
                      'Always here to help',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textSecondary,
                      ),
                    )
                  else
                    const Text(
                      'Typically replies in minutes',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (!_isAIChat) ...[
            IconButton(
              icon: const Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showCallOption();
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppTheme.primaryColor),
              onPressed: () {
                HapticFeedback.lightImpact();
                _showMoreOptions();
              },
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),

          // AI Quick Actions (only for AI chat)
          if (_isAIChat && _messages.length <= 1) _buildQuickActions(),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isAIChat ? Icons.auto_awesome : Icons.chat_bubble_outline,
                size: 64,
                color: _isAIChat ? Colors.purple : AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isAIChat ? 'AI Assistant Ready' : 'Start Conversation',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isAIChat
                  ? 'Ask me anything about hair care, styling, or finding the perfect professional.'
                  : 'Send a message to start chatting.',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.search, 'text': 'Find a stylist'},
      {'icon': Icons.content_cut, 'text': 'Service prices'},
      {'icon': Icons.lightbulb_outline, 'text': 'Hair care tips'},
      {'icon': Icons.calendar_today, 'text': 'Book appointment'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions.map((action) {
              return InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _sendMessage(action['text'] as String);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        size: 16,
                        color: AppTheme.accentColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        action['text'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: message.isUser ? 48 : 0,
        right: message.isUser ? 0 : 48,
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isUser && message.senderName != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                message.senderName!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isUser ? AppTheme.primaryColor : AppTheme.surfaceColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                bottomRight: Radius.circular(message.isUser ? 4 : 16),
              ),
              border: message.isUser
                  ? null
                  : Border.all(color: AppTheme.borderLight),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: message.isUser ? Colors.white : Colors.black,
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
            child: Text(
              _formatTime(message.timestamp),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w300,
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.borderLight),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: _isAIChat
                        ? 'Ask me anything...'
                        : 'Type a message...',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: AppTheme.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (_messageController.text.trim().isNotEmpty) {
                  _sendMessage(_messageController.text.trim());
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String content) {
    if (content.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate response
    if (_isAIChat) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add(ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: _getAIResponse(content),
              isUser: false,
              timestamp: DateTime.now(),
              senderName: 'Zelus AI',
            ));
          });

          // Scroll to bottom after AI response
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    } else {
      // For regular chats, just acknowledge
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${widget.recipientName} is typing...'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
  }

  String _getAIResponse(String userMessage) {
    final lower = userMessage.toLowerCase();

    if (lower.contains('find') || lower.contains('stylist')) {
      return 'I can help you find the perfect stylist! What are you looking for? You can browse our Explore tab or tell me your preferences like location, specialty, or style.';
    } else if (lower.contains('price') || lower.contains('cost') || lower.contains('service')) {
      return 'Service prices vary by stylist and location. Most haircuts range from \$50-\$150, while color services typically run \$100-\$300. I can help you find stylists in your budget - what service are you interested in?';
    } else if (lower.contains('book') || lower.contains('appointment')) {
      return 'To book an appointment, visit a stylist\'s profile and tap "Book Now". You can also message them directly if you have questions first. Need help finding someone?';
    } else if (lower.contains('tip') || lower.contains('advice') || lower.contains('care')) {
      return 'Here are some quick hair care tips:\n\n• Use sulfate-free shampoo for color-treated hair\n• Deep condition weekly\n• Trim every 6-8 weeks\n• Protect from heat with a thermal spray\n\nWhat specific hair concern do you have?';
    } else if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hello! How can I help you today? I can assist with finding stylists, answering service questions, or providing hair care advice.';
    } else {
      return 'I\'m here to help! I can assist you with:\n\n• Finding stylists near you\n• Information about services and pricing\n• Booking appointments\n• Hair care tips and advice\n\nWhat would you like to know more about?';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }

  void _showCallOption() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video Call'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Starting video call...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
                if (widget.recipientId != null) {
                  context.push('/stylist/${widget.recipientId}');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: const Text('Mute Notifications'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Block'),
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),
      ),
    );
  }
}

