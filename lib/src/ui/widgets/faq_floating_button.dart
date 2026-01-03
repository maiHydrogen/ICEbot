import 'package:flutter/material.dart';
import '../../core/controllers/faq_chat_controller.dart';
import '../../core/repositories/asset_faq_repository.dart';
import '../../core/repositories/memory_faq_repository.dart';
import '../../core/models/faq_item.dart';
import '../../config/icebot_config.dart';
import '../theme/chat_theme.dart';
import 'faq_chat_screen.dart';

class FaqFloatingButton extends StatelessWidget {
  final FaqChatController? controller;
  final ChatTheme theme;
  final String? tooltip;
  final double size;
  final Widget? icon;

  const FaqFloatingButton({
    super.key,
    this.controller,
    this.theme = const ChatTheme(),
    this.tooltip = 'Open FAQ Chat',
    this.size = 56,
    this.icon,
  });

  /// Create from asset JSON file
  factory FaqFloatingButton.fromAsset({
    Key? key,
    required String assetPath,
    IcebotConfig config = const IcebotConfig(),
    ChatTheme theme = const ChatTheme(),
    String? tooltip,
    double size = 56,
    Widget? icon,
  }) {
    final repository = AssetFaqRepository(assetPath);
    final controller = FaqChatController(
      repository: repository,
      config: config,
    );

    return FaqFloatingButton(
      key: key,
      controller: controller,
      theme: theme,
      tooltip: tooltip,
      size: size,
      icon: icon,
    );
  }

  /// Create from FAQ list
  factory FaqFloatingButton.fromFaqList({
    Key? key,
    required List<FaqItem> faqs,
    IcebotConfig config = const IcebotConfig(),
    ChatTheme theme = const ChatTheme(),
    String? tooltip,
    double size = 56,
    Widget? icon,
  }) {
    final repository = MemoryFaqRepository(faqs);
    final controller = FaqChatController(
      repository: repository,
      config: config,
    );

    return FaqFloatingButton(
      key: key,
      controller: controller,
      theme: theme,
      tooltip: tooltip,
      size: size,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openChat(context),
      tooltip: tooltip,
      backgroundColor: theme.primaryColor,
      elevation: 4,
      child: icon ??
          const Icon(
            Icons.support_agent,
            color: Colors.white,
            size: 28,
          ),
    );
  }

  void _openChat(BuildContext context) {
    if (controller == null) {
      throw StateError('FaqFloatingButton requires a controller');
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FaqChatScreen(
          controller: controller!,
          theme: theme,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}
