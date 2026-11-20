import 'package:flutter/widgets.dart';

import 'desktop_menu_controller.dart';
import 'desktop_menu_keyboard.dart';
import 'desktop_menu_theme.dart';
import 'desktop_menu_types.dart';

/// Internal inherited state shared by all menu descendants.
class DesktopMenuScope extends InheritedWidget {
  const DesktopMenuScope({
    super.key,
    required this.theme,
    required this.interactionMode,
    required this.keyboard,
    required this.controller,
    required this.onInput,
    required this.onMenuOpened,
    required this.onMenuClosed,
    required super.child,
  });

  final DesktopMenuTheme theme;
  final DesktopMenuInteractionMode interactionMode;
  final DesktopMenuKeyboardConfig keyboard;
  final DesktopMenuController controller;
  final void Function(DesktopMenuInputEvent event)? onInput;
  final void Function(Object? menuKey)? onMenuOpened;
  final void Function(Object? menuKey)? onMenuClosed;

  static DesktopMenuScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DesktopMenuScope>();
    if (scope == null) {
      throw FlutterError(
        'No DesktopMenuScope found. Desktop menu widgets must be descendants '
        'of DesktopAppBar.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(DesktopMenuScope oldWidget) =>
      theme != oldWidget.theme ||
      interactionMode != oldWidget.interactionMode ||
      keyboard != oldWidget.keyboard ||
      controller != oldWidget.controller ||
      onInput != oldWidget.onInput;
}
