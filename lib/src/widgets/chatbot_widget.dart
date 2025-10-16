import 'package:flutter/material.dart';
import 'package:icebot/index.dart';

class ChatbotWidget extends StatefulWidget {
  final List<FAQItem> faqs;
  final ChatbotConfig config;
  final double? height;
  final double? width;

  const ChatbotWidget({
    super.key,
    required this.faqs,
    this.config = const ChatbotConfig(),
    this.height,
    this.width,
  });

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  late ChatService _chatService;
  late FAQService _faqService;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _faqService = FAQService(widget.faqs);
    _chatService = ChatService(_faqService, widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: widget.height ,
          width: widget.width,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMessageList()),
              if (widget.config.enableSuggestions) _buildSuggestions(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.config.primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Image(
              image: AssetImage("images/plus.png", package: "icebot"),
              height: 32,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.config.botName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _chatService.clearChat,
            icon: const Icon(Icons.refresh, color: Colors.black),
          ),
          const Spacer(),
          IconButton(
            onPressed: _scrollToBottom,
            icon: const Icon(Icons.arrow_circle_down_rounded, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return AnimatedBuilder(
      animation:
          _chatService,
      builder: (context, child) {
        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: _chatService.messages.length,
          itemBuilder: (context, index) {
            final message = _chatService.messages[index];
            return ChatBubble(message: message, config: widget.config);
          },
        );
      },
    );
  }

  Widget _buildSuggestions() {
    final suggestions = _faqService.getSuggestions(
      widget.config.maxSuggestions,
    );
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(suggestion.question),
              onPressed: () => _chatService.selectSuggestion(suggestion),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: widget.config.primaryColor,
            onPressed: () => _sendMessage(_controller.text),
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      _chatService.sendMessage(text.trim());
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
