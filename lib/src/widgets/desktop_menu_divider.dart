import 'package:flutter/material.dart';

import '../core/desktop_menu_scope.dart';

/// A divider styled from the active menu theme.
class DesktopMenuDivider extends StatelessWidget {
  const DesktopMenuDivider({
    super.key,
    this.height = 8,
    this.indent = 0,
    this.endIndent = 0,
  });

  final double height;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final style = DesktopMenuScope.of(context).theme.menu;
    return Divider(
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: style.borderColor,
    );
  }
}
