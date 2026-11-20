import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/desktop_menu_controller.dart';
import '../core/desktop_menu_keyboard.dart';
import '../core/desktop_menu_scope.dart';
import '../core/desktop_menu_theme.dart';
import '../core/desktop_menu_types.dart';
import 'desktop_menu_overlay.dart';
import 'desktop_menu_panel.dart';

/// A cascading menu item that opens another panel to the side.
class DesktopSubmenu extends StatefulWidget {
  const DesktopSubmenu({
    super.key,
    required this.label,
    required this.children,
    this.icon,
    this.trailing,
    this.trigger,
    this.style,
    this.keyboard,
    this.interactionMode,
    this.openOnHover,
    this.width,
    this.openDelay = Duration.zero,
    this.closeDelay = const Duration(milliseconds: 180),
    this.focusNode,
    this.controllerKey,
    this.onOpen,
    this.onClose,
    this.onKeyEvent,
  });

  final String label;
  final List<Widget> children;
  final Widget? icon;
  final Widget? trailing;
  final Widget? trigger;
  final DesktopMenuStyle? style;
  final DesktopMenuKeyboardConfig? keyboard;
  final DesktopMenuInteractionMode? interactionMode;
  final bool? openOnHover;
  final double? width;
  final Duration openDelay;
  final Duration closeDelay;
  final FocusNode? focusNode;
  final Object? controllerKey;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;
  final KeyEventResult Function(
    FocusNode node,
    KeyEvent event,
  )? onKeyEvent;

  @override
  State<DesktopSubmenu> createState() => _DesktopSubmenuState();
}

class _DesktopSubmenuState extends State<DesktopSubmenu> {
  final LayerLink _link = LayerLink();

  final FocusNode _internalFocus = FocusNode(
    debugLabel: 'desktop-submenu',
  );

  OverlayEntry? _entry;

  bool _hover = false;
  bool _panelHover = false;
  bool _focus = false;

  DesktopMenuController? _registeredController;
  DesktopMenuHandle? _handle;
  final Object _siblingRegistrationKey = Object();
  DesktopMenuController? _siblingController;
  DesktopMenuHandle? _siblingHandle;

  DesktopMenuScope get _scope =>
      DesktopMenuScope.of(context);

  DesktopMenuStyle get _style =>
      widget.style ?? _scope.theme.menu;

  DesktopMenuKeyboardConfig get _keyboard =>
      widget.keyboard ?? _scope.keyboard;

  DesktopMenuInteractionMode get _interactionMode =>
      widget.interactionMode ?? _scope.interactionMode;

  bool get _hoverMode =>
      widget.openOnHover ??
      _interactionMode == DesktopMenuInteractionMode.hover;

  bool get isOpen => _entry != null;

  double _submenuGap(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return (screenWidth * 0.01).clamp(
      6.0,
      12.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerController();
    _registerSiblingSubmenu();
  }

  @override
  void didUpdateWidget(
    covariant DesktopSubmenu oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controllerKey !=
        widget.controllerKey) {
      _unregisterController();
      _registerController();
    }
  }

  void _registerSiblingSubmenu() {
    final controller = _scope.controller;
    if (identical(_siblingController, controller) &&
        _siblingHandle != null) {
      return;
    }
    if (_siblingController != null && _siblingHandle != null) {
      _siblingController!.unregisterSubmenu(
        _siblingRegistrationKey,
        _siblingHandle!,
      );
    }
    _siblingHandle = DesktopMenuHandle(
      open: () {},
      close: close,
      toggle: () {
        if (isOpen) {
          close();
        } else {
          open();
        }
      },
      focus: () => FocusScope.of(context).requestFocus(
        widget.focusNode ?? _internalFocus,
      ),
      isOpen: () => isOpen,
    );
    _siblingController = controller;
    controller.registerSubmenu(
      _siblingRegistrationKey,
      _siblingHandle!,
    );
  }

  void _registerController() {
    if (!mounted) {
      return;
    }

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
      toggle: () {
        if (!mounted) {
          return;
        }

        if (isOpen) {
          close();
        } else {
          open();
        }
      },
      focus: () {
        if (!mounted) {
          return;
        }

        FocusScope.of(context).requestFocus(
          widget.focusNode ?? _internalFocus,
        );
      },
      isOpen: () => isOpen,
    );

    controller.register(
      key,
      _handle!,
    );

    _registeredController = controller;
  }

  void _unregisterController() {
    if (_registeredController != null &&
        _handle != null) {
      final key = widget.controllerKey;

      if (key != null) {
        _registeredController!.unregister(
          key,
          _handle!,
        );
      }
    }

    _registeredController = null;
    _handle = null;
  }

  @override
  void dispose() {
    _unregisterController();
    if (_siblingController != null && _siblingHandle != null) {
      _siblingController!.unregisterSubmenu(
        _siblingRegistrationKey,
        _siblingHandle!,
      );
    }

    final entry = _entry;

    _entry = null;

    entry?.remove();

    _internalFocus.dispose();

    super.dispose();
  }

  void open() {
    if (!mounted || isOpen) {
      return;
    }

    final scope = _scope;
    final hoverMode = _hoverMode;
    scope.controller.closeOtherSubmenus(_siblingRegistrationKey);

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
          child: _buildOverlay(
            hoverMode: hoverMode,
          ),
        );
      },
    );

    Overlay.of(
      context,
      rootOverlay: true,
    ).insert(_entry!);

    widget.onOpen?.call();

    if (mounted) {
      setState(() {});
    }
  }

  void close() {
    if (!mounted || !isOpen) {
      return;
    }

    final entry = _entry;

    _entry = null;

    entry?.remove();

    widget.onClose?.call();

    if (mounted) {
      setState(() {});
    }
  }

  void _emit(
    DesktopMenuKeyboardAction action,
    KeyEvent event,
  ) {
    if (!mounted) {
      return;
    }

    _scope.onInput?.call(
      DesktopMenuInputEvent(
        action: action,
        keyEvent: event,
      ),
    );
  }

  KeyEventResult _onKey(
    FocusNode node,
    KeyEvent event,
  ) {
    if (!mounted) {
      return KeyEventResult.ignored;
    }

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
      case DesktopMenuKeyboardAction.openSubmenu:
        open();
        return KeyEventResult.handled;

      case DesktopMenuKeyboardAction.close:
      case DesktopMenuKeyboardAction.closeSubmenu:
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
      case DesktopMenuKeyboardAction.last:
        return KeyEventResult.ignored;
    }
  }

  Widget _defaultTrigger() {
    return Row(
      children: [
        if (widget.icon != null) ...[
          IconTheme.merge(
            data: IconThemeData(
              color: _style.foregroundColor,
              size: 16,
            ),
            child: widget.icon!,
          ),
          SizedBox(
            width: _style.itemSpacing,
          ),
        ],
        Expanded(
          child: Text(
            widget.label,
            style: _style.textStyle.copyWith(
              color: _style.foregroundColor,
            ),
          ),
        ),
        if (widget.trailing != null) ...[
          SizedBox(
            width: _style.itemSpacing,
          ),
          widget.trailing!,
        ] else
          Icon(
            Icons.chevron_right,
            size: 14,
            color: _style.foregroundColor.withOpacity(.38),
          ),
      ],
    );
  }

  Widget _buildOverlay({
    required bool hoverMode,
  }) {
    final menuWidth =
        widget.width ?? _style.width;

    final gap = _submenuGap(context);

    final interactionWidth =
        menuWidth + gap;

    return DesktopMenuOverlay(
      link: _link,
      width: interactionWidth,
      offset: Offset(
        0,
        _style.submenuOffset,
      ),
      targetAnchor: Alignment.topRight,
      followerAnchor: Alignment.topLeft,
      onEnter: (_) {
        if (!mounted) {
          return;
        }

        _panelHover = true;
      },
      onExit: (_) {
        if (!mounted) {
          return;
        }

        /*
         * Do not close immediately here.
         *
         * The pointer can briefly leave the follower's exact render bounds
         * while moving through the cascade gap or between nested panels.
         * Closing directly from this callback was the source of the
         * "submenu runs away" behavior.
         *
         * The actual panel MouseRegion below owns the hover state. Once the
         * pointer has genuinely left the interaction area, the submenu can
         * be closed from there.
         */
      },
      child: SizedBox(
        width: interactionWidth,
        child: MouseRegion(
          opaque: false,
          hitTestBehavior:
              HitTestBehavior.translucent,
          onEnter: (_) {
            if (!mounted) {
              return;
            }

            _panelHover = true;
          },
          onExit: (_) {
            if (!mounted) {
              return;
            }

            _panelHover = false;

            /*
             * Keep the submenu alive when using hover mode.
             *
             * The parent menu owns the initial cascade transition and the
             * submenu itself must not disappear simply because the pointer
             * crossed a render boundary between the gap and panel.
             */
            if (hoverMode) {
              final pointerPosition =
                  _.position;

              final box = context.findRenderObject();

              if (box is RenderBox) {
                final local =
                    box.globalToLocal(
                  pointerPosition,
                );

                final size = box.size;

                final insideExpandedArea =
                    local.dx >= -gap &&
                        local.dx <=
                            size.width + gap &&
                        local.dy >= -gap &&
                        local.dy <=
                            size.height + gap;

                if (insideExpandedArea) {
                  return;
                }
              }
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: gap,
            ),
            child: DesktopMenuPanel(
              style: _style,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children:
                    widget.children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: Semantics(
        container: true,
        button: true,
        label: widget.label,
        hint: isOpen ? 'Submenu expanded' : 'Open submenu',
        onTap: () {
          if (isOpen) {
            close();
          } else {
            open();
          }
        },
        child: Focus(
        focusNode:
            widget.focusNode ?? _internalFocus,
        onFocusChange: (value) {
          if (!mounted) {
            return;
          }

          setState(() {
            _focus = value;
          });
        },
        onKeyEvent: _onKey,
        child: MouseRegion(
          cursor: _scope.theme.cursor,
          onEnter: (_) {
            if (!mounted) {
              return;
            }

            _hover = true;

            if (_hoverMode && !isOpen) {
              open();
            }

            setState(() {});
          },
          onExit: (_) {
            if (!mounted) {
              return;
            }

            _hover = false;

            /*
             * Do not close from the trigger exit.
             *
             * Moving from a submenu trigger toward its cascading panel
             * necessarily causes this region to receive an exit event.
             */
            setState(() {});
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!mounted) {
                return;
              }

              if (isOpen) {
                close();
              } else {
                open();
              }
            },
            child: Container(
              padding: _style.itemPadding,
              decoration: BoxDecoration(
                color: (_hover ||
                        _focus ||
                        isOpen)
                    ? _style.hoverColor
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(
                  _style.itemBorderRadius,
                ),
              ),
              child: widget.trigger ??
                  _defaultTrigger(),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
