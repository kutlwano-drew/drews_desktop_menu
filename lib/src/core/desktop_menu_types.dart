import 'package:flutter/material.dart';

/// Determines how a menu is opened by pointer input.
enum DesktopMenuInteractionMode {
  /// Menus open while the pointer is over their trigger.
  hover,

  /// Menus open and close when their trigger is clicked.
  click,
}

/// Semantic actions understood by the keyboard navigation layer.
enum DesktopMenuKeyboardAction {
  select,
  open,
  close,
  next,
  previous,
  nextMenu,
  previousMenu,
  first,
  last,
  openSubmenu,
  closeSubmenu,
}

/// A small description of an input event that can be observed by applications.
class DesktopMenuInputEvent {
  const DesktopMenuInputEvent({
    required this.action,
    required this.keyEvent,
    this.menuKey,
  });

  /// The semantic action resolved from the key event.
  final DesktopMenuKeyboardAction action;

  /// The original Flutter keyboard event.
  final KeyEvent keyEvent;

  /// The optional application-defined key of the affected menu.
  final Object? menuKey;
}
