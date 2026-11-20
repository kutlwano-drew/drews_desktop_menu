import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/desktop_menu_keyboard.dart';
import '../core/desktop_menu_scope.dart';
import '../core/desktop_menu_theme.dart';
import '../core/desktop_menu_types.dart';

/// A standard menu command.
///
/// The command itself belongs to the application: the package only invokes
/// [onPressed]. Supply [child] when you need completely custom rendering.
class DesktopMenuItem extends StatefulWidget {
  const DesktopMenuItem({
    super.key,
    this.label,
    this.icon,
    this.trailing,
    this.child,
    this.onPressed,
    this.enabled = true,
    this.style,
    this.keyboard,
    this.focusNode,
    this.semanticLabel,
    this.autofocus = false,
    this.onKeyEvent,
  }) : assert(label != null || child != null, 'Provide label or child.');

  final String? label;
  final Widget? icon;
  final Widget? trailing;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool enabled;
  final DesktopMenuStyle? style;
  final DesktopMenuKeyboardConfig? keyboard;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final bool autofocus;
  final KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent;

  @override
  State<DesktopMenuItem> createState() => _DesktopMenuItemState();
}

class _DesktopMenuItemState extends State<DesktopMenuItem> {
  bool _hover = false;
  bool _focus = false;

  DesktopMenuScope get _scope => DesktopMenuScope.of(context);
  DesktopMenuStyle get _style => widget.style ?? _scope.theme.menu;
  DesktopMenuKeyboardConfig get _keyboard => widget.keyboard ?? _scope.keyboard;

  void _select() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final custom = widget.onKeyEvent?.call(node, event);
    if (custom != null && custom != KeyEventResult.ignored) return custom;
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final action = _keyboard.actionFor(event);
    if (action == DesktopMenuKeyboardAction.select ||
        action == DesktopMenuKeyboardAction.open) {
      _select();
      _scope.onInput?.call(DesktopMenuInputEvent(
        action: action!,
        keyEvent: event,
      ));
      return KeyEventResult.handled;
    }
    if (action == DesktopMenuKeyboardAction.close) {
      _scope.controller.closeAll();
      _scope.onInput?.call(DesktopMenuInputEvent(action: action!, keyEvent: event));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final base = _style.foregroundColor;
    final foreground = widget.enabled ? base : base.withOpacity(.35);
    final content = widget.child ?? Row(
      children: [
        if (widget.icon != null) ...[
          IconTheme.merge(
            data: IconThemeData(color: foreground, size: 16),
            child: widget.icon!,
          ),
          SizedBox(width: _style.itemSpacing),
        ],
        Expanded(
          child: Text(
            widget.label!,
            overflow: TextOverflow.ellipsis,
            style: _style.textStyle.copyWith(color: foreground),
            semanticsLabel: widget.semanticLabel,
          ),
        ),
        if (widget.trailing != null) ...[
          SizedBox(width: _style.itemSpacing),
          widget.trailing!,
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: widget.enabled && widget.onPressed != null,
      label: widget.semanticLabel ?? widget.label,
      onTap: widget.enabled ? _select : null,
      child: Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) => setState(() => _focus = value),
      onKeyEvent: _onKey,
      child: MouseRegion(
        cursor: widget.enabled ? _scope.theme.cursor : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? _select : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            padding: _style.itemPadding,
            decoration: BoxDecoration(
              color: (_hover || _focus) ? _style.hoverColor : Colors.transparent,
              borderRadius: BorderRadius.circular(_style.itemBorderRadius),
            ),
            child: content,
          ),
        ),
      ),
      ),
    );
  }
}
