import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/chat_message.dart';
import '../theme/chat_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ChatTheme theme;
  final bool showTimestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.theme,
    this.showTimestamp = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(isUser),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: GestureDetector(
              onLongPress: () => _copyToClipboard(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? theme.userBubbleColor : theme.botBubbleColor,
                  borderRadius: BorderRadius.circular(theme.borderRadius)
                      .copyWith(
                        bottomLeft: isUser
                            ? Radius.circular(theme.borderRadius)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : Radius.circular(theme.borderRadius),
                      ),
                  border: isUser ? Border.all(color: Colors.black12) : null,
                  boxShadow: theme.bubbleElevation > 0
                      ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: theme.bubbleElevation,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: isUser ? theme.userTextStyle : theme.botTextStyle,
                    ),
                    if (showTimestamp) ...[
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(message.timestamp),
                        style: theme.timestampStyle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser) _buildAvatar(isUser),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser ? Colors.grey.shade300 : Colors.transparent,
      child: isUser
          ? Icon(Icons.person, size: 18, color: Colors.grey.shade700)
          : Image(
              image: AssetImage('images/plus.png', package: 'icebot'),
              height: 32,
            ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
