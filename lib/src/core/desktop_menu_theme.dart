import 'package:flutter/material.dart';

/// Styling for the app-bar chrome.
class DesktopAppBarStyle {
  const DesktopAppBarStyle({
    this.height = 40,
    this.backgroundColor = const Color(0xFF101016),
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.white10,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.itemSpacing = 4,
  });

  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double itemSpacing;
}

/// Styling shared by menu panels and standard menu controls.
class DesktopMenuStyle {
  const DesktopMenuStyle({
    this.width = 220,
    this.backgroundColor = const Color(0xFF16161F),
    this.foregroundColor = Colors.white,
    this.hoverColor = Colors.white10,
    this.borderColor = Colors.white10,
    this.borderWidth = 1,
    this.borderRadius = 10,
    this.itemBorderRadius = 4,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    this.itemSpacing = 10,
    this.shadow = const BoxShadow(
      color: Colors.black54,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
    this.submenuGap = 4,
    this.submenuOffset = -6,
    this.textStyle = const TextStyle(fontSize: 13),
  });

  final double width;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color hoverColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double itemBorderRadius;
  final EdgeInsets itemPadding;
  final double itemSpacing;
  final BoxShadow? shadow;
  final double submenuGap;
  final double submenuOffset;
  final TextStyle textStyle;
}

/// Complete visual configuration for [DesktopAppBar].
class DesktopMenuTheme {
  const DesktopMenuTheme({
    this.appBar = const DesktopAppBarStyle(),
    this.menu = const DesktopMenuStyle(),
    this.triggerTextStyle = const TextStyle(fontSize: 12),
    this.cursor = SystemMouseCursors.click,
  });

  final DesktopAppBarStyle appBar;
  final DesktopMenuStyle menu;
  final TextStyle triggerTextStyle;
  final MouseCursor cursor;
}
