import 'package:flutter/services.dart';

import 'desktop_menu_types.dart';

/// A key plus optional modifier requirements.
///
/// This intentionally uses Flutter's [LogicalKeyboardKey], allowing callers to
/// bind normal keys, function keys, media keys, and their own combinations.
class DesktopKeyBinding {
  const DesktopKeyBinding({
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  final LogicalKeyboardKey key;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  bool matches(KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    return event.logicalKey == key &&
        keyboard.isControlPressed == control &&
        keyboard.isShiftPressed == shift &&
        keyboard.isAltPressed == alt &&
        keyboard.isMetaPressed == meta;
  }
}

/// Configurable keyboard map for the whole menu system.
///
/// Every list is public so an application can replace the defaults completely.
/// Set [enabled] or [handleKeyEvent] to false when the application wants to
/// own keyboard handling itself.
class DesktopMenuKeyboardConfig {
  const DesktopMenuKeyboardConfig({
    this.select = const [
      DesktopKeyBinding(key: LogicalKeyboardKey.enter),
      DesktopKeyBinding(key: LogicalKeyboardKey.space),
    ],
    this.open = const [
      DesktopKeyBinding(key: LogicalKeyboardKey.enter),
      DesktopKeyBinding(key: LogicalKeyboardKey.space),
      DesktopKeyBinding(key: LogicalKeyboardKey.arrowDown),
    ],
    this.close = const [DesktopKeyBinding(key: LogicalKeyboardKey.escape)],
    this.next = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowDown)],
    this.previous = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowUp)],
    this.nextMenu = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowRight)],
    this.previousMenu = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowLeft)],
    this.first = const [DesktopKeyBinding(key: LogicalKeyboardKey.home)],
    this.last = const [DesktopKeyBinding(key: LogicalKeyboardKey.end)],
    this.openSubmenu = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowRight)],
    this.closeSubmenu = const [DesktopKeyBinding(key: LogicalKeyboardKey.arrowLeft)],
    this.enabled = true,
    this.handleKeyEvent = true,
  });

  final List<DesktopKeyBinding> select;
  final List<DesktopKeyBinding> open;
  final List<DesktopKeyBinding> close;
  final List<DesktopKeyBinding> next;
  final List<DesktopKeyBinding> previous;
  final List<DesktopKeyBinding> nextMenu;
  final List<DesktopKeyBinding> previousMenu;
  final List<DesktopKeyBinding> first;
  final List<DesktopKeyBinding> last;
  final List<DesktopKeyBinding> openSubmenu;
  final List<DesktopKeyBinding> closeSubmenu;
  final bool enabled;
  final bool handleKeyEvent;

  /// Resolves a physical event to the first matching semantic action.
  DesktopMenuKeyboardAction? actionFor(KeyEvent event) {
    if (!enabled || !handleKeyEvent) return null;
    for (final entry in _bindings) {
      if (entry.$2.any((binding) => binding.matches(event))) return entry.$1;
    }
    return null;
  }

  bool matches(DesktopMenuKeyboardAction action, KeyEvent event) =>
      enabled && handleKeyEvent && _bindingsByAction(action).any((b) => b.matches(event));

  List<(DesktopMenuKeyboardAction, List<DesktopKeyBinding>)> get _bindings => [
        (DesktopMenuKeyboardAction.select, select),
        (DesktopMenuKeyboardAction.openSubmenu, openSubmenu),
        (DesktopMenuKeyboardAction.closeSubmenu, closeSubmenu),
        (DesktopMenuKeyboardAction.close, close),
        (DesktopMenuKeyboardAction.next, next),
        (DesktopMenuKeyboardAction.previous, previous),
        (DesktopMenuKeyboardAction.nextMenu, nextMenu),
        (DesktopMenuKeyboardAction.previousMenu, previousMenu),
        (DesktopMenuKeyboardAction.first, first),
        (DesktopMenuKeyboardAction.last, last),
        (DesktopMenuKeyboardAction.open, open),
      ];

  List<DesktopKeyBinding> _bindingsByAction(DesktopMenuKeyboardAction action) =>
      switch (action) {
        DesktopMenuKeyboardAction.select => select,
        DesktopMenuKeyboardAction.open => open,
        DesktopMenuKeyboardAction.close => close,
        DesktopMenuKeyboardAction.next => next,
        DesktopMenuKeyboardAction.previous => previous,
        DesktopMenuKeyboardAction.nextMenu => nextMenu,
        DesktopMenuKeyboardAction.previousMenu => previousMenu,
        DesktopMenuKeyboardAction.first => first,
        DesktopMenuKeyboardAction.last => last,
        DesktopMenuKeyboardAction.openSubmenu => openSubmenu,
        DesktopMenuKeyboardAction.closeSubmenu => closeSubmenu,
      };
}
