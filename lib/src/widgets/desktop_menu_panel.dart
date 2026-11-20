import 'package:flutter/material.dart';

import '../core/desktop_menu_scope.dart';
import '../core/desktop_menu_theme.dart';

/// The visual shell used for dropdown and cascading menu content.
class DesktopMenuPanel extends StatelessWidget {
  const DesktopMenuPanel({
    super.key,
    required this.child,
    this.style,
    this.padding = const EdgeInsets.all(8),
  });

  final Widget child;
  final DesktopMenuStyle? style;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final resolved = style ?? DesktopMenuScope.of(context).theme.menu;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: resolved.backgroundColor,
          borderRadius: BorderRadius.circular(
            resolved.borderRadius,
          ),
          border: Border.all(
            color: resolved.borderColor,
            width: resolved.borderWidth,
          ),
          boxShadow: resolved.shadow == null
              ? null
              : [resolved.shadow!],
        ),
        child: FocusTraversalGroup(
          child: child,
        ),
      ),
    );
  }
}
