import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/desktop_menu_controller.dart';
import '../core/desktop_menu_keyboard.dart';
import '../core/desktop_menu_scope.dart';
import '../core/desktop_menu_theme.dart';
import '../core/desktop_menu_types.dart';
import 'desktop_menu_overlay.dart';
import 'desktop_menu_panel.dart';

/// A top-level menu trigger for [DesktopAppBar].
///
/// Use [children] for normal menu content or [menu] when the application needs
/// complete control over the panel. [trigger] can replace the default text
/// trigger with any Flutter widget.
class DesktopAppBarMenu extends StatefulWidget {
  const DesktopAppBarMenu({
    super.key,
    this.label,
    this.trigger,
    this.children,
    this.menu,
    this.style,
    this.keyboard,
    this.interactionMode,
    this.openOnHover,
    this.closeOnOutsideTap = true,
    this.hoverOpenDelay = Duration.zero,
    this.hoverCloseDelay = const Duration(milliseconds: 100),
    this.width,
    this.triggerPadding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 10,
    ),
    this.onOpen,
    this.onClose,
    this.controllerKey,
    this.focusNode,
    this.onTriggerTap,
    this.toggleOnTriggerTap = true,
    this.onKeyEvent,
  })  : assert(
          (children != null) != (menu != null),
          'Provide exactly one of children or menu.',
        ),
        assert(
          label != null || trigger != null,
          'Provide label or trigger.',
        );

  final String? label;
  final Widget? trigger;
  final List<Widget>? children;
  final Widget? menu;
  final DesktopMenuStyle? style;
  final DesktopMenuKeyboardConfig? keyboard;
  final DesktopMenuInteractionMode? interactionMode;
  final bool? openOnHover;
  final bool closeOnOutsideTap;
  final Duration hoverOpenDelay;
  final Duration hoverCloseDelay;
  final double? width;
  final EdgeInsets triggerPadding;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final Object? controllerKey;
  final FocusNode? focusNode;
  final VoidCallback? onTriggerTap;
  final bool toggleOnTriggerTap;
  final KeyEventResult Function(
    FocusNode node,
    KeyEvent event,
  )? onKeyEvent;

  @override
  State<DesktopAppBarMenu> createState() => DesktopAppBarMenuState();
}

/// Public state object so an application can obtain it with a [GlobalKey].
class DesktopAppBarMenuState extends State<DesktopAppBarMenu> {
  final LayerLink _link = LayerLink();

  final FocusNode _internalFocus = FocusNode(
    debugLabel: 'desktop-app-bar-menu',
  );

  OverlayEntry? _entry;

  Timer? _openTimer;
  Timer? _closeTimer;

  bool _triggerHover = false;
  bool _panelHover = false;
  bool _focused = false;

  DesktopMenuController? _registeredController;
  DesktopMenuHandle? _handle;

  DesktopMenuScope get _scope => DesktopMenuScope.of(context);

  DesktopMenuStyle get _style =>
      widget.style ?? _scope.theme.menu;

  DesktopMenuKeyboardConfig get _keyboard =>
      widget.keyboard ?? _scope.keyboard;

  DesktopMenuInteractionMode get _mode =>
      widget.interactionMode ?? _scope.interactionMode;

  bool get _hoverMode =>
      widget.openOnHover ??
      _mode == DesktopMenuInteractionMode.hover;

  /// Whether this menu currently has an overlay open.
  bool get isOpen => _entry != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerController();
  }

  @override
  void didUpdateWidget(
    covariant DesktopAppBarMenu oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controllerKey != widget.controllerKey ||
        oldWidget.focusNode != widget.focusNode) {
      _unregisterController();
      _registerController();
    }
  }

  void _registerController() {
    final key = widget.controllerKey;

    if (key == null) {
      return;
    }

    final controller = _scope.controller;

    if (identical(
          _registeredController,
          controller,
        ) &&
        _handle != null) {
      return;
    }

    _unregisterController();

    _handle = DesktopMenuHandle(
      open: open,
      close: close,
      toggle: toggle,
      focus: focus,
      isOpen: () => isOpen,
    );

    controller.register(
      key,
      _handle!,
    );

    _registeredController = controller;
  }

  void _unregisterController() {
    final key = widget.controllerKey;

    if (key != null &&
        _handle != null &&
        _registeredController != null) {
      _registeredController!.unregister(
        key,
        _handle!,
      );
    }

    _registeredController = null;
    _handle = null;
  }

  @override
  void dispose() {
    _unregisterController();

    _openTimer?.cancel();
    _closeTimer?.cancel();

    _removeEntry();

    _internalFocus.dispose();

    super.dispose();
  }

  /// Opens the menu programmatically.
  void open() {
    if (!mounted || _entry != null) {
      return;
    }

    _openTimer?.cancel();
    _closeTimer?.cancel();

    final scope = _scope;
    if (widget.controllerKey != null) {
      scope.controller.closeOthers(widget.controllerKey);
    }

    _entry = OverlayEntry(
      builder: (_) {
        return DesktopMenuScope(
          theme: scope.theme,
          interactionMode: scope.interactionMode,
          keyboard: scope.keyboard,
          controller: scope.controller,
          onInput: scope.onInput,
          onMenuOpened: scope.onMenuOpened,
          onMenuClosed: scope.onMenuClosed,
          child: _buildOverlay(),
        );
      },
    );

    Overlay.of(
      context,
      rootOverlay: true,
    ).insert(_entry!);

    widget.onOpen?.call();
    scope.onMenuOpened?.call(widget.controllerKey);

    if (mounted) {
      setState(() {});
    }
  }

  /// Closes the menu programmatically.
  void close() {
    _openTimer?.cancel();
    _closeTimer?.cancel();

    if (_entry == null) {
      return;
    }

    _scope.controller.closeAllSubmenus();
    _removeEntry();

    widget.onClose?.call();
    _scope.onMenuClosed?.call(widget.controllerKey);

    if (mounted) {
      setState(() {});
    }
  }

  /// Toggles the menu.
  void toggle() {
    if (isOpen) {
      close();
    } else {
      open();
    }
  }

  /// Gives keyboard focus to this trigger.
  void focus() {
    FocusScope.of(context).requestFocus(
      widget.focusNode ?? _internalFocus,
    );
  }

  void _removeEntry() {
    final entry = _entry;

    _entry = null;

    entry?.remove();
  }

  void _scheduleOpen() {
    _openTimer?.cancel();

    if (widget.hoverOpenDelay == Duration.zero) {
      open();
      return;
    }

    _openTimer = Timer(
      widget.hoverOpenDelay,
      () {
        if (!mounted) {
          return;
        }

        open();
      },
    );
  }

  void _scheduleClose() {
    _closeTimer?.cancel();

    _closeTimer = Timer(
      widget.hoverCloseDelay,
      () {
        if (!mounted) {
          return;
        }

        if (_triggerHover || _panelHover) {
          return;
        }

        close();
      },
    );
  }

  void _triggerEnter(
    PointerEnterEvent event,
  ) {
    if (!mounted) {
      return;
    }

    _triggerHover = true;
    _closeTimer?.cancel();

    if (widget.controllerKey != null) {
      _scope.controller.closeOthers(widget.controllerKey);
    }

    if (_hoverMode) {
      _scheduleOpen();
    }

    setState(() {});
  }

  void _triggerExit(
    PointerExitEvent event,
  ) {
    if (!mounted) {
      return;
    }

    _triggerHover = false;

    if (_hoverMode) {
      _scheduleClose();
    }

    setState(() {});
  }

  void _panelEnter(
    PointerEnterEvent event,
  ) {
    if (!mounted) {
      return;
    }

    _panelHover = true;
    _closeTimer?.cancel();
  }

  void _panelExit(
    PointerExitEvent event,
  ) {
    if (!mounted) {
      return;
    }

    _panelHover = false;

    if (!_hoverMode) {
      return;
    }

    /*
     * A cascading submenu opens to the right of this panel.
     *
     * Do not immediately tear down the top-level overlay when the pointer
     * leaves through the right-hand edge. The submenu has its own overlay
     * and needs the parent overlay/link to remain alive while the pointer
     * crosses the gap.
     *
     * For exits through the other three sides, the normal close behavior
     * remains unchanged.
     */
    final box = context.findRenderObject();

    if (box is RenderBox) {
      final localPosition = box.globalToLocal(
        event.position,
      );

      final size = box.size;

      final exitsRight = localPosition.dx >= size.width;

      if (exitsRight) {
        _closeTimer?.cancel();
        return;
      }
    }

    _scheduleClose();
  }

  void _emit(
    DesktopMenuKeyboardAction action,
    KeyEvent event,
  ) {
    _scope.onInput?.call(
      DesktopMenuInputEvent(
        action: action,
        keyEvent: event,
        menuKey: widget.controllerKey,
      ),
    );
  }

  KeyEventResult _onKey(
    FocusNode node,
    KeyEvent event,
  ) {
    final custom = widget.onKeyEvent?.call(
      node,
      event,
    );

    if (custom != null &&
        custom != KeyEventResult.ignored) {
      return custom;
    }

    if (event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }

    final action = _keyboard.actionFor(event);

    if (action == null) {
      return KeyEventResult.ignored;
    }

    _emit(
      action,
      event,
    );

    switch (action) {
      case DesktopMenuKeyboardAction.select:
      case DesktopMenuKeyboardAction.open:
        toggle();
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.close:
        close();
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.next:
      case DesktopMenuKeyboardAction.nextMenu:
        FocusScope.of(context).nextFocus();
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.previous:
      case DesktopMenuKeyboardAction.previousMenu:
        FocusScope.of(context).previousFocus();
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.first:
        FocusScope.of(context).focusInDirection(
          TraversalDirection.left,
        );
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.last:
        FocusScope.of(context).focusInDirection(
          TraversalDirection.right,
        );
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.openSubmenu:
      case DesktopMenuKeyboardAction.closeSubmenu:
        return KeyEventResult.ignored;
    }
  }

  Widget _trigger() {
    final child = widget.trigger ??
        Padding(
          padding: widget.triggerPadding,
          child: Text(
            widget.label!,
            style: _scope.theme.triggerTextStyle.copyWith(
              color: _scope.theme.appBar.foregroundColor,
            ),
          ),
        );

    return Semantics(
      container: true,
      button: true,
      label: widget.label ?? 'Menu',
      hint: isOpen ? 'Menu expanded' : 'Open menu',
      onTap: widget.toggleOnTriggerTap ? toggle : null,
      child: MouseRegion(
      cursor: _scope.theme.cursor,
      onEnter: _triggerEnter,
      onExit: _triggerExit,
      child: Focus(
        focusNode: widget.focusNode ?? _internalFocus,
        onFocusChange: (value) {
          if (!mounted) {
            return;
          }

          setState(() {
            _focused = value;
          });
        },
        onKeyEvent: _onKey,
        child: Material(
          color: (_triggerHover ||
                  isOpen ||
                  _focused)
              ? _style.hoverColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            _style.itemBorderRadius,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              _style.itemBorderRadius,
            ),
            onTap: () {
              widget.onTriggerTap?.call();

              if (widget.toggleOnTriggerTap) {
                toggle();
              }
            },
            child: child,
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildOverlay() {
    final content = widget.menu ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children!,
        );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (widget.closeOnOutsideTap)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: close,
              child: const SizedBox.expand(),
            ),
          ),
        DesktopMenuOverlay(
          link: _link,
          width: widget.width ?? _style.width,
          offset: Offset(
            0,
            _scope.theme.appBar.height - 4,
          ),
          onEnter: _panelEnter,
          onExit: _panelExit,
          child: DesktopMenuPanel(
            style: _style,
            child: content,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: _trigger(),
    );
  }
}
