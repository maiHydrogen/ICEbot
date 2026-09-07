import 'package:flutter/material.dart';
import '../../core/controllers/faq_chat_controller.dart';
import '../../core/repositories/faq_repository.dart';
import '../../core/repositories/asset_faq_repository.dart';
import '../../core/repositories/memory_faq_repository.dart';
import '../../core/models/faq_item.dart';
import '../../config/icebot_config.dart';
import '../theme/chat_theme.dart';
import 'faq_chat_screen.dart';

/// A [FloatingActionButton] that opens a [FaqChatScreen] when tapped.
///
/// Use [FaqFloatingButton.fromAsset] or [FaqFloatingButton.fromFaqList] to let
/// the widget create and own its [FaqChatController] (it is disposed with the
/// widget). Use the default constructor to supply an existing controller whose
/// lifecycle you manage yourself.
class FaqFloatingButton extends StatefulWidget {
  /// Caller-owned controller. When set, this widget will not dispose it.
  final FaqChatController? controller;

  /// Set only by [fromAsset] / [fromFaqList]; the widget owns the controller it
  /// builds from this and disposes it.
  final FaqRepository? _repository;
  final IcebotConfig _config;

  final ChatTheme theme;
  final String? tooltip;
  final double size;
  final Widget? icon;

  const FaqFloatingButton({
    super.key,
    required FaqChatController this.controller,
    this.theme = const ChatTheme(),
    this.tooltip = 'Open FAQ Chat',
    this.size = 56,
    this.icon,
  }) : _repository = null,
       _config = const IcebotConfig();

  const FaqFloatingButton._selfManaged({
    super.key,
    required FaqRepository repository,
    required IcebotConfig config,
    this.theme = const ChatTheme(),
    this.tooltip = 'Open FAQ Chat',
    this.size = 56,
    this.icon,
  }) : controller = null,
       _repository = repository,
       _config = config;

  /// Loads FAQs from a bundled JSON asset. The widget owns the controller.
  factory FaqFloatingButton.fromAsset({
    Key? key,
    required String assetPath,
    IcebotConfig config = const IcebotConfig(),
    ChatTheme theme = const ChatTheme(),
    String? tooltip,
    double size = 56,
    Widget? icon,
  }) {
    return FaqFloatingButton._selfManaged(
      key: key,
      repository: AssetFaqRepository(assetPath),
      config: config,
      theme: theme,
      tooltip: tooltip ?? 'Open FAQ Chat',
      size: size,
      icon: icon,
    );
  }

  /// Uses an in-memory FAQ list. The widget owns the controller.
  factory FaqFloatingButton.fromFaqList({
    Key? key,
    required List<FaqItem> faqs,
    IcebotConfig config = const IcebotConfig(),
    ChatTheme theme = const ChatTheme(),
    String? tooltip,
    double size = 56,
    Widget? icon,
  }) {
    return FaqFloatingButton._selfManaged(
      key: key,
      repository: MemoryFaqRepository(faqs),
      config: config,
      theme: theme,
      tooltip: tooltip ?? 'Open FAQ Chat',
      size: size,
      icon: icon,
    );
  }

  @override
  State<FaqFloatingButton> createState() => _FaqFloatingButtonState();
}

class _FaqFloatingButtonState extends State<FaqFloatingButton> {
  FaqChatController? _ownedController;

  FaqChatController get _controller => widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = FaqChatController(
        repository: widget._repository!,
        config: widget._config,
      );
    }
  }

  @override
  void dispose() {
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openChat(context),
      tooltip: widget.tooltip,
      backgroundColor: widget.theme.primaryColor,
      elevation: 4,
      child:
          widget.icon ??
          const Icon(Icons.support_agent, color: Colors.white, size: 28),
    );
  }

  void _openChat(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FaqChatScreen(controller: _controller, theme: widget.theme),
        fullscreenDialog: true,
      ),
    );
  }
}
