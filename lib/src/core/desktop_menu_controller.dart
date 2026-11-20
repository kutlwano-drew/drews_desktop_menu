import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A public handle to one registered menu.
class DesktopMenuHandle {
  const DesktopMenuHandle({
    required this.open,
    required this.close,
    required this.toggle,
    required this.focus,
    required this.isOpen,
  });

  final VoidCallback open;
  final VoidCallback close;
  final VoidCallback toggle;
  final VoidCallback focus;
  final bool Function() isOpen;
}

/// Application-facing controller for programmatic menu state.
///
/// Register a menu by giving [DesktopAppBarMenu.controllerKey]. The controller
/// becomes an imperative escape hatch without preventing normal widget state,
/// pointer interaction, or keyboard navigation.
class DesktopMenuController extends ChangeNotifier {
  final Map<Object, DesktopMenuHandle> _menus = {};
  final Map<Object, DesktopMenuHandle> _submenus = {};
  final ValueNotifier<Object?> _focused = ValueNotifier<Object?>(null);
  final ValueNotifier<Object?> _open = ValueNotifier<Object?>(null);

  bool get hasRegisteredMenus => _menus.isNotEmpty;
  Object? get focusedKey => _focused.value;
  Object? get openKey => _open.value;
  ValueListenable<Object?> get focusedKeyListenable => _focused;
  ValueListenable<Object?> get openKeyListenable => _open;

  /// Registers a menu implementation under an application-defined key.
  void register(Object key, DesktopMenuHandle handle) {
    _menus[key] = handle;
    _syncOpenKey();
  }

  /// Removes a menu registration. Safe to call repeatedly.
  void unregister(Object key, DesktopMenuHandle handle) {
    if (identical(_menus[key], handle)) _menus.remove(key);
    _syncOpenKey();
  }

  /// Closes every other top-level menu and all cascading submenus.
  void closeOthers(Object? keepKey) {
    for (final entry in _menus.entries.toList()) {
      if (entry.key != keepKey) entry.value.close();
    }
    closeAllSubmenus();
    _open.value = keepKey != null && _menus[keepKey]?.isOpen() == true
        ? keepKey
        : null;
    notifyListeners();
  }

  /// Registers a cascading submenu for sibling-exclusive hover behavior.
  void registerSubmenu(Object key, DesktopMenuHandle handle) {
    _submenus[key] = handle;
  }

  void unregisterSubmenu(Object key, DesktopMenuHandle handle) {
    if (identical(_submenus[key], handle)) _submenus.remove(key);
  }

  /// Closes sibling cascading submenus before one submenu is opened.
  void closeOtherSubmenus(Object key) {
    for (final entry in _submenus.entries.toList()) {
      if (entry.key != key) entry.value.close();
    }
  }

  void closeAllSubmenus() {
    for (final handle in _submenus.values.toList()) {
      handle.close();
    }
  }

  /// Opens a registered menu. Unknown keys are ignored.
  void open(Object key) {
    final menu = _menus[key];
    if (menu == null) return;
    menu.open();
    _open.value = key;
    notifyListeners();
  }

  /// Closes a registered menu.
  void close(Object key) {
    _menus[key]?.close();
    if (_open.value == key) _open.value = null;
    notifyListeners();
  }

  /// Toggles a registered menu.
  void toggle(Object key) {
    final menu = _menus[key];
    if (menu == null) return;
    if (menu.isOpen()) {
      menu.close();
      _open.value = null;
    } else {
      menu.open();
      _open.value = key;
    }
    notifyListeners();
  }

  /// Closes every registered top-level menu.
  void closeAll({bool notify = true}) {
    for (final menu in _menus.values) {
      menu.close();
    }
    closeAllSubmenus();
    _open.value = null;
    if (notify) notifyListeners();
  }

  /// Gives focus to a registered menu trigger.
  void focus(Object key) {
    _focused.value = key;
    _menus[key]?.focus();
    notifyListeners();
  }

  /// Clears the recorded application-level focused key.
  void clearFocus() {
    _focused.value = null;
    notifyListeners();
  }

  void _syncOpenKey() {
    Object? found;
    for (final entry in _menus.entries) {
      if (entry.value.isOpen()) {
        found = entry.key;
        break;
      }
    }
    _open.value = found;
  }

  @override
  void dispose() {
    _menus.clear();
    _submenus.clear();
    _focused.dispose();
    _open.dispose();
    super.dispose();
  }
}
