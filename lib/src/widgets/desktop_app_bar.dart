import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/desktop_menu_controller.dart';
import '../core/desktop_menu_keyboard.dart';
import '../core/desktop_menu_scope.dart';
import '../core/desktop_menu_theme.dart';
import '../core/desktop_menu_types.dart';

/// A compact, extensible desktop application bar.
///
/// Put [DesktopAppBarMenu] widgets, custom triggers, spacers, branding, or any
/// other Flutter widgets in [children]. The package does not impose an
/// application-specific menu model.
class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DesktopAppBar({
    super.key,
    required this.children,
    this.style = const DesktopMenuTheme(),
    this.interactionMode = DesktopMenuInteractionMode.hover,
    this.keyboard = const DesktopMenuKeyboardConfig(),
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.onKeyEvent,
    this.onInput,
    this.onMenuOpened,
    this.onMenuClosed,
    this.center,
    this.trailing,
  });

  final List<Widget> children;
  final DesktopMenuTheme style;
  final DesktopMenuInteractionMode interactionMode;
  final DesktopMenuKeyboardConfig keyboard;
  final DesktopMenuController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent;
  final void Function(DesktopMenuInputEvent event)? onInput;
  final void Function(Object? menuKey)? onMenuOpened;
  final void Function(Object? menuKey)? onMenuClosed;
  final Widget? center;
  final List<Widget>? trailing;

  @override
  Size get preferredSize => Size.fromHeight(style.appBar.height);

  @override
  State<DesktopAppBar> createState() => _DesktopAppBarState();
}

class _DesktopAppBarState extends State<DesktopAppBar> {
  late final FocusNode _internalFocusNode = FocusNode(debugLabel: 'drews-desktop-app-bar');
  late final DesktopMenuController _internalController = DesktopMenuController();

  DesktopMenuController get _controller => widget.controller ?? _internalController;

  @override
  void dispose() {
    _internalFocusNode.dispose();
    _internalController.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final custom = widget.onKeyEvent?.call(node, event);
    if (custom != null && custom != KeyEventResult.ignored) return custom;
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final action = widget.keyboard.actionFor(event);
    if (action == null) return KeyEventResult.ignored;
    widget.onInput?.call(DesktopMenuInputEvent(action: action, keyEvent: event));
    if (action == DesktopMenuKeyboardAction.close) {
      _controller.closeAll();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  List<Widget> _spaced(List<Widget> widgets) {
    final result = <Widget>[];
    for (var i = 0; i < widgets.length; i++) {
      if (i > 0) result.add(SizedBox(width: widget.style.appBar.itemSpacing));
      result.add(widgets[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bar = widget.style.appBar;
    return DesktopMenuScope(
      theme: widget.style,
      interactionMode: widget.interactionMode,
      keyboard: widget.keyboard,
      controller: _controller,
      onInput: widget.onInput,
      onMenuOpened: widget.onMenuOpened,
      onMenuClosed: widget.onMenuClosed,
      child: Container(
        height: bar.height,
        padding: bar.padding,
        decoration: BoxDecoration(
          color: bar.backgroundColor,
          border: Border(
            bottom: BorderSide(color: bar.borderColor, width: bar.borderWidth),
          ),
        ),
        child: Focus(
          focusNode: widget.focusNode ?? _internalFocusNode,
          autofocus: widget.autofocus,
          onKeyEvent: _onKey,
          child: Row(
            children: [
              ..._spaced(widget.children),
              if (widget.center != null) ...[
                const Spacer(), widget.center!, const Spacer(),
              ] else
                const Spacer(),
              if (widget.trailing != null) ..._spaced(widget.trailing!),
            ],
          ),
        ),
      ),
    );
  }
}
