<a id="top"></a>

# Drews Desktop Menu

A desktop-first Flutter app bar and cascading menu system with hover, click, keyboard, focus, and programmatic control.

**Table of Contents**

- [**Introduction**](#introduction)

- [**Features**](#features)

- [**Installation**](#installation)

- [**Quick Start**](#quick-start)

- [**Examples**](#examples)

- [**1. App bar basics**](#example-1-app-bar-basics)

- [**2. Menu items & commands**](#example-2-menu-items--commands)

- [**3. Dividers & grouping**](#example-3-dividers--grouping)

- [**4. Cascading submenus**](#example-4-cascading-submenus)

- [**5. Custom triggers**](#example-5-custom-triggers)

- [**6. Custom menu panel**](#example-6-custom-menu-panel)

- [**7. Hover vs click**](#example-7-hover-vs-click)

- [**8. Programmatic controller**](#example-8-programmatic-controller)

- [**9. Keyboard configuration**](#example-9-keyboard-configuration)

- [**10. App bar hooks & events**](#example-10-app-bar-hooks--events)

- [**11. Menu item API**](#example-11-menu-item-api)

- [**12. Submenu API**](#example-12-submenu-api)

- [**13. Pointer timing & dismissal**](#example-13-pointer-timing--dismissal)

- [**14. Theme & style overrides**](#example-14-theme--style-overrides)

- [**15. Live color theming**](#example-15-live-color-theming)

- [**16. Focus & accessibility**](#example-16-focus--accessibility)

- [**17. Advanced scope & overlay APIs**](#example-17-advanced-scope--overlay-apis)

- [**Tester category map**](#tester-category-map)

- [**API Overview**](#api-overview)

- [**Testing**](#testing)

- [**License**](#license)

- [**Developer**](#developer)

---

<a id="introduction"></a>

## Introduction

A flexible, desktop-first Flutter app bar and cascading menu system.

![Drew's Desktop Menu](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/drews%20flutter%20package.gif)

visit Drew's package tester at https://drewspackages.web.app/ for live examples.

[Back to Top](#top)

---

<a id="features"></a>

## Features

- Desktop app bar composition with arbitrary children.

- Hover and click interaction modes.

- Cascading and nested submenus.

- Custom triggers and arbitrary menu content.

- Shared and per-menu/per-item styling.

- Disabled items, focus handling, and keyboard bindings.

- Programmatic open, close, and focus control.

- No application-specific actions or platform service dependencies.

[Back to Top](#top)

---

<a id="installation"></a>

## Installation

```yaml

dependencies:

drews_desktop_menu: ^0.1.0

```

[Back to Top](#top)

---

<a id="quick-start"></a>

## Quick Start

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBar(
  children: [
    DesktopAppBarMenu(
      label: 'File',
      children: [
        DesktopMenuItem(label: 'Open', onPressed: openFile),
        DesktopMenuItem(label: 'Save', onPressed: saveFile),
      ],
    ),
  ],
)

```

[Back to Top](#top)

---

<a id="examples"></a>

## Examples

Each example below corresponds to an entry in the `drews_desktop_menu` tester. Select the matching example in the tester, then capture its live preview for the screenshot or GIF in that section.

---

<a id="example-1-app-bar-basics"></a>

### Example 1: App bar basics

Compose a desktop app bar from menu triggers and standard Flutter widgets.

[Code](#example-1-code) · [Top](#top)

<a id="example-1-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

final controller = DesktopMenuController();

DesktopAppBar(
  style: const DesktopMenuTheme(
    appBar: DesktopAppBarStyle(
      height: 46,
      backgroundColor: Color(0xFF111318),
      foregroundColor: Colors.white,
      borderColor: Color(0xFF303744),
      padding: EdgeInsets.symmetric(horizontal: 14),
      itemSpacing: 6,
    ),
    menu: DesktopMenuStyle(width: 248),
    triggerTextStyle: TextStyle(fontSize: 12),
    cursor: SystemMouseCursors.click,
  ),
  controller: controller,
  children: [
    DesktopAppBarMenu(
      label: 'File',
      children: [
        DesktopMenuItem(label: 'New', onPressed: createFile),
        DesktopMenuItem(label: 'Open', onPressed: openFile),
      ],
    ),
  ],
)

```

[Visual](#example-1-visual) · [Top](#top)

<a id="example-1-visual"></a>

![Example 1: Appbar Basics](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/app%20basics.png)

[Back to Top](#top) · [Next Example →](#example-2-menu-items--commands)

---

<a id="example-2-menu-items--commands"></a>

### Example 2: Menu items & commands

Demonstrates icons, trailing keyboard hints, callbacks, disabled actions, and grouped commands.

[Code](#example-2-code) · [Top](#top)

<a id="example-2-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  label: 'File',
  width: 260,
  children: [
    DesktopMenuItem(
      label: 'New project',
      icon: const Icon(Icons.add),
      trailing: const Text('Ctrl+N'),
      onPressed: createProject,
    ),
    DesktopMenuItem(
      label: 'Save all',
      icon: const Icon(Icons.save_outlined),
      enabled: false,
      onPressed: saveAll,
    ),
    const DesktopMenuDivider(),
    DesktopMenuItem(label: 'Close', onPressed: closeProject),
  ],
)

```

[Visual](#example-2-visual) · [Top](#top)

<a id="example-2-visual"></a>

![Example 2: Menu items & commands demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/menu%20items.png)

[Back to Top](#top) · [Next Example →](#example-3-dividers--grouping)

---

<a id="example-3-dividers--grouping"></a>

### Example 3: Dividers & grouping

Use dividers with custom height and indents to visually group related actions.

[Code](#example-3-code) · [Top](#top)

<a id="example-3-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  label: 'Workspace',
  children: [
    DesktopMenuItem(label: 'New file', onPressed: newFile),
    const DesktopMenuDivider(height: 12, indent: 8, endIndent: 8),
    DesktopMenuItem(label: 'Rename', onPressed: rename),
    const DesktopMenuDivider(height: 18),
    DesktopMenuItem(label: 'Delete', onPressed: delete),
  ],
)

```

[Visual](#example-3-visual) · [Top](#top)

<a id="example-3-visual"></a>

![Example 3: Dividers & grouping demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/dividers.png)

[Back to Top](#top) · [Next Example →](#example-4-cascading-submenus)

---

<a id="example-4-cascading-submenus"></a>

### Example 4: Cascading submenus

Build nested cascading menus with icons, trailing affordances, custom widths, and open/close callbacks.

[Code](#example-4-code) · [Top](#top)

<a id="example-4-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  label: 'Project',
  children: [
    DesktopSubmenu(
      label: 'Import',
      icon: const Icon(Icons.download_outlined),
      trailing: const Icon(Icons.chevron_right),
      width: 250,
      onOpen: onImportOpen,
      onClose: onImportClose,
      children: [
        DesktopMenuItem(label: 'From device', onPressed: importDevice),
        DesktopSubmenu(
          label: 'Cloud provider',
          children: [
            DesktopMenuItem(label: 'Drive', onPressed: importDrive),
            DesktopSubmenu(
              label: 'More providers',
              children: [DesktopMenuItem(label: 'OneDrive')],
            ),
          ],
        ),
      ],
    ),
  ],
)

```

[Visual](#example-4-visual) · [Top](#top)

<a id="example-4-visual"></a>

![Example 4: Cascading submenus demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/cascading.png)

[Back to Top](#top) · [Next Example →](#example-5-custom-triggers)

---

<a id="example-5-custom-triggers"></a>

### Example 5: Custom triggers

Replace the default label trigger with a custom account button or another widget.

[Code](#example-5-code) · [Top](#top)

<a id="example-5-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  trigger: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blueAccent),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_outline),
        SizedBox(width: 8),
        Text('Account'),
      ],
    ),
  ),
  triggerPadding: EdgeInsets.zero,
  children: [
    DesktopMenuItem(label: 'Profile', onPressed: openProfile),
  ],
)

```

[Visual](#example-5-visual) · [Top](#top)

<a id="example-5-visual"></a>

![Example 5: Custom triggers demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/custom%20triggers.png)

[Back to Top](#top) · [Next Example →](#example-6-custom-menu-panel)

---

<a id="example-6-custom-menu-panel"></a>

### Example 6: Custom menu panel

Supply a custom panel when a standard list of menu items is not enough.

[Code](#example-6-code) · [Top](#top)

<a id="example-6-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  label: 'Quick launch',
  menu: DesktopMenuPanel(
    style: const DesktopMenuStyle(width: 310),
    padding: const EdgeInsets.all(14),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('RECENT ITEMS'),
        ListTile(title: const Text('Project Alpha'), onTap: openAlpha),
        ListTile(title: const Text('Project Beta'), onTap: openBeta),
        DesktopMenuItem(label: 'Command palette', onPressed: openPalette),
      ],
    ),
  ),
)

```

[Visual](#example-6-visual) · [Top](#top)

<a id="example-6-visual"></a>

![Example 6: Custom menu panel demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/custom%20panel.png)

[Back to Top](#top) · [Next Example →](#example-7-hover-vs-click)

---

<a id="example-7-hover-vs-click"></a>

### Example 7: Hover vs click

Set hover or click behaviour globally and override it for individual menus.

[Code](#example-7-code) · [Top](#top)

<a id="example-7-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBar(
  interactionMode: DesktopMenuInteractionMode.hover,
  children: [
    DesktopAppBarMenu(
      label: 'Inherit hover mode',
      children: [DesktopMenuItem(label: 'Hover to open')],
    ),
    DesktopAppBarMenu(
      label: 'Click override',
      interactionMode: DesktopMenuInteractionMode.click,
      children: [DesktopMenuItem(label: 'Click to open')],
    ),
    DesktopAppBarMenu(
      label: 'Hover override',
      interactionMode: DesktopMenuInteractionMode.hover,
      children: [DesktopMenuItem(label: 'Hover to open')],
    ),
  ],
)

```

[Visual](#example-7-visual) · [Top](#top)

<a id="example-7-visual"></a>

![Example 7: Hover vs click demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/hover%20vs%20click.png)

[Back to Top](#top) · [Next Example →](#example-8-programmatic-controller)

---

<a id="example-8-programmatic-controller"></a>

### Example 8: Programmatic controller

Open, close, toggle, focus, and observe registered menus through a controller.

[Code](#example-8-code) · [Top](#top)

<a id="example-8-code"></a>

```dart
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

final controller = DesktopMenuController();

DesktopAppBar(
  controller: controller,
  children: [
    DesktopAppBarMenu(
      label: 'File',
      controllerKey: 'file',
      children: [DesktopMenuItem(label: 'Open')],
    ),
  ],
)

// Call from buttons or application commands:
controller.open('file');
controller.toggle('file');
controller.close('file');
controller.focus('file');
controller.clearFocus();
controller.closeAll();
final openKey = controller.openKeyListenable;
final focusedKey = controller.focusedKeyListenable;

```

[Visual](#example-8-visual) · [Top](#top)

<a id="example-8-visual"></a>

![Example 8: Programmatic controller demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/programatic%20tools.png)

[Back to Top](#top) · [Next Example →](#example-9-keyboard-configuration)

---

<a id="example-9-keyboard-configuration"></a>

### Example 9: Keyboard configuration

Configure keyboard bindings and observe keyboard input from the app bar.

[Code](#example-9-code) · [Top](#top)

<a id="example-9-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';
import 'package:flutter/services.dart';

const keyboard = DesktopMenuKeyboardConfig(
  select: [
    DesktopKeyBinding(key: LogicalKeyboardKey.enter),
    DesktopKeyBinding(
      key: LogicalKeyboardKey.keyK,
      control: true,
      shift: false,
      alt: false,
      meta: false,
    ),
  ],
  open: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowDown)],
  close: [DesktopKeyBinding(key: LogicalKeyboardKey.escape)],
  next: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowDown)],
  previous: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowUp)],
  nextMenu: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowRight)],
  previousMenu: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowLeft)],
  first: [DesktopKeyBinding(key: LogicalKeyboardKey.home)],
  last: [DesktopKeyBinding(key: LogicalKeyboardKey.end)],
  openSubmenu: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowRight)],
  closeSubmenu: [DesktopKeyBinding(key: LogicalKeyboardKey.arrowLeft)],
  enabled: true,
  handleKeyEvent: true,
);

DesktopAppBar(
  keyboard: keyboard,
  onInput: (event) => log(
    '${event.action} / ${event.keyEvent.logicalKey} / ${event.menuKey}',
  ),
  children: [
    DesktopAppBarMenu(label: 'Navigate', children: items),
  ],
)
```

[Back to Top](#top) · [Next Example →](#example-10-app-bar-hooks--events)

---

<a id="example-10-app-bar-hooks--events"></a>

### Example 10: App bar hooks & events

Observe open/close events and keyboard input, and add centre or trailing app-bar content.

[Code](#example-10-code) · [Top](#top)

<a id="example-10-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';
import 'package:flutter/services.dart';

DesktopAppBar(
  focusNode: appBarFocusNode,
  autofocus: true,
  onKeyEvent: (node, event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f9) {
      runCommand();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  },
  onInput: (event) => debugPrint('${event.action}'),
  onMenuOpened: (key) => debugPrint('opened $key'),
  onMenuClosed: (key) => debugPrint('closed $key'),
  center: const Text('WORKSPACE'),
  trailing: const [Icon(Icons.cloud_done), Text('Synced')],
  children: [
    DesktopAppBarMenu(
      label: 'Tools',
      onTriggerTap: () => debugPrint('trigger tapped'),
      toggleOnTriggerTap: true,
      children: items,
    ),
  ],
)

```

[Back to Top](#top) · [Next Example →](#example-11-menu-item-api)

---

<a id="example-11-menu-item-api"></a>

### Example 11: Menu item API

Configure item content, semantic labels, enabled state, focus, autofocus, and custom keyboard behaviour.

[Code](#example-11-code) · [Top](#top)

<a id="example-11-code"></a>

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopMenuItem(
  label: 'Accessible command',
  icon: const Icon(Icons.accessibility_new),
  trailing: const Text('F3'),
  semanticLabel: 'Run the accessible command',
  enabled: true,
  autofocus: false,
  focusNode: itemFocusNode,
  style: const DesktopMenuStyle(itemBorderRadius: 8),
  keyboard: const DesktopMenuKeyboardConfig(),
  onKeyEvent: (node, event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.f3) {
      runCommand();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  },
  onPressed: runCommand,
)

// Supply child instead of label for fully custom item content.
DesktopMenuItem(
  child: const Row(
    children: [
      Icon(Icons.star),
      Text('Custom row content'),
    ],
  ),
  onPressed: runCommand,
)
```

[Back to Top](#top) · [Next Example →](#example-12-submenu-api)

---

<a id="example-12-submenu-api"></a>

### Example 12: Submenu API

Configure submenu triggers, icons, width, interaction, delays, and callbacks.

[Code](#example-12-code) · [Top](#top)

<a id="example-12-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopSubmenu(
  label: 'Export',
  icon: const Icon(Icons.ios_share),
  trailing: const Icon(Icons.chevron_right),
  trigger: const Text('Custom export trigger'),
  width: 260,
  style: const DesktopMenuStyle(borderRadius: 12),
  keyboard: const DesktopMenuKeyboardConfig(),
  interactionMode: DesktopMenuInteractionMode.click,
  openOnHover: false,
  openDelay: const Duration(milliseconds: 150),
  closeDelay: const Duration(milliseconds: 250),
  controllerKey: 'export',
  onOpen: onExportOpen,
  onClose: onExportClose,
  onKeyEvent: customKeyHandler,
  children: [
    DesktopMenuItem(
      label: 'PDF',
      onPressed: exportPdf,
    ),
  ],
)
```

[Visual](#example-12-visual) · [Top](#top)

<a id="example-12-visual"></a>

![Example 12: Submenu API demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/submenu.png)

[Back to Top](#top) · [Next Example →](#example-13-pointer-timing--dismissal)

---

<a id="example-13-pointer-timing--dismissal"></a>

### Example 13: Pointer timing & dismissal

Tune hover delays and outside-tap dismissal behaviour.

[Code](#example-13-code) · [Top](#top)

<a id="example-13-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

DesktopAppBarMenu(
  label: 'Delayed actions',
  hoverOpenDelay: const Duration(milliseconds: 250),
  hoverCloseDelay: const Duration(milliseconds: 300),
  closeOnOutsideTap: true,
  openOnHover: true, // per-menu override
  onOpen: onMenuOpen,
  onClose: onMenuClose,
  children: [
    DesktopMenuItem(label: 'Open'),
  ],
)

DesktopSubmenu(
  label: 'Nested actions',
  openDelay: const Duration(milliseconds: 150),
  closeDelay: const Duration(milliseconds: 200),
  children: [
    DesktopMenuItem(label: 'Action'),
  ],
)

```

[Back to Top](#top) · [Next Example →](#example-14-theme--style-overrides)

---

<a id="example-14-theme--style-overrides"></a>

### Example 14: Theme & style overrides

Configure dimensions, padding, typography, borders, radius, spacing, shadows, and submenu offsets.

[Code](#example-14-code) · [Top](#top)

<a id="example-14-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

const theme = DesktopMenuTheme(
  appBar: DesktopAppBarStyle(
    height: 48,
    backgroundColor: Color(0xFF111318),
    foregroundColor: Colors.white,
    borderColor: Color(0xFF7AA2F7),
    borderWidth: 1.5,
    padding: EdgeInsets.symmetric(horizontal: 14),
    itemSpacing: 8,
  ),
  menu: DesktopMenuStyle(
    width: 260,
    backgroundColor: Color(0xFF191C22),
    foregroundColor: Colors.white,
    hoverColor: Color(0x337AA2F7),
    borderColor: Color(0xFF7AA2F7),
    borderWidth: 1,
    borderRadius: 12,
    itemBorderRadius: 7,
    itemPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    itemSpacing: 7,
    shadow: BoxShadow(color: Colors.black54, blurRadius: 14),
    submenuGap: 8,
    submenuOffset: -5,
    textStyle: TextStyle(fontSize: 13),
  ),
  triggerTextStyle: TextStyle(fontSize: 12),
  cursor: SystemMouseCursors.click,
);

DesktopAppBar(style: theme, children: menuWidgets)
```

[Back to Top](#top) · [Next Example →](#example-15-live-color-theming)

---

<a id="example-15-live-color-theming"></a>

### Example 15: Live color theming

Use the tester palette controls to change app-bar, menu, border, and hover colours.

[Code](#example-15-code) · [Top](#top)

<a id="example-15-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// In the tester, GlobalColorPalette changes these values live.
final theme = DesktopMenuTheme(
  appBar: DesktopAppBarStyle(
    backgroundColor: barColor,
    borderColor: accentColor.withOpacity(.7),
  ),
  menu: DesktopMenuStyle(
    backgroundColor: panelColor,
    borderColor: accentColor,
    hoverColor: accentColor.withOpacity(.2),
  ),
);

DesktopAppBar(style: theme, children: menuWidgets)

```

[Back to Top](#top) · [Next Example →](#example-16-focus--accessibility)

---

<a id="example-16-focus--accessibility"></a>

### Example 16: Focus & accessibility

Demonstrate focus, autofocus, keyboard access, and semantic labels.

[Code](#example-16-code) · [Top](#top)

<a id="example-16-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

final appBarFocusNode = FocusNode();
final itemFocusNode = FocusNode();

// Dispose every FocusNode owned by your State object.
DesktopAppBar(
  focusNode: appBarFocusNode,
  autofocus: true,
  children: [
    DesktopAppBarMenu(
      label: 'Accessible menu',
      focusNode: menuFocusNode,
      children: [
        DesktopMenuItem(
          label: 'Profile',
          semanticLabel: 'Open your user profile',
          focusNode: itemFocusNode,
          autofocus: true,
          onPressed: openProfile,
        ),
      ],
    ),
  ],
)

```

[Back to Top](#top) · [Next Example →](#example-17-advanced-scope--overlay-apis)

---

<a id="example-17-advanced-scope--overlay-apis"></a>

### Example 17: Advanced scope & overlay APIs

Explore inherited menu scope and lower-level overlay/controller primitives.

[Code](#example-17-code) · [Top](#top)

<a id="example-17-code"></a>

```dart

import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// Scope is inherited by widgets rendered under DesktopAppBar.
class ScopeReadout extends StatelessWidget {
  const ScopeReadout({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = DesktopMenuScope.of(context);
    final theme = scope.theme;
    final controller = scope.controller;
    final keyboard = scope.keyboard;
    final inputCallback = scope.onInput;
    final openedCallback = scope.onMenuOpened;
    final closedCallback = scope.onMenuClosed;

    return Text('Mode: ${scope.interactionMode.name}');
  }
}

// Low-level controller handle for an external action.
var externalOpen = false;
final externalHandle = DesktopMenuHandle(
  open: () => externalOpen = true,
  close: () => externalOpen = false,
  toggle: () => externalOpen = !externalOpen,
  focus: requestExternalFocus,
  isOpen: () => externalOpen,
);

controller.register('external', externalHandle);
controller.open('external');
controller.unregister('external', externalHandle);

// Low-level overlay placement: use inside a Stack with a linked target.
Stack(
  children: [
    CompositedTransformTarget(
      link: link,
      child: trigger,
    ),
    if (visible)
      DesktopMenuOverlay(
        link: link,
        width: 240,
        offset: const Offset(0, 40),
        targetAnchor: Alignment.topLeft,
        followerAnchor: Alignment.topLeft,
        onEnter: onPointerEnter,
        onExit: onPointerExit,
        child: DesktopMenuPanel(child: menuContents),
      ),
  ],
)
```

[Visual](#example-17-visual) · [Top](#top)

<a id="example-17-visual"></a>

![Example 17: Advanced scope & overlay APIs demonstration](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/scope.png)

[Back to Top](#top)

---

<a id="tester-category-map"></a>

## Tester category map

These are the same example areas available in the live tester. Select a category there to reveal its controls directly beneath the selected item.

- [App bar basics](#example-1-app-bar-basics)

- [Menu items & commands](#example-2-menu-items--commands)

- [Dividers & grouping](#example-3-dividers--grouping)

- [Cascading submenus](#example-4-cascading-submenus)

- [Custom triggers](#example-5-custom-triggers)

- [Custom menu panel](#example-6-custom-menu-panel)

- [Hover vs click](#example-7-hover-vs-click)

- [Programmatic controller](#example-8-programmatic-controller)

- [Keyboard configuration](#example-9-keyboard-configuration)

- [App bar hooks & events](#example-10-app-bar-hooks--events)

- [Menu item API](#example-11-menu-item-api)

- [Submenu API](#example-12-submenu-api)

- [Pointer timing & dismissal](#example-13-pointer-timing--dismissal)

- [Theme & style overrides](#example-14-theme--style-overrides)

- [Live color theming](#example-15-live-color-theming)

- [Focus & accessibility](#example-16-focus--accessibility)

- [Advanced scope & overlay APIs](#example-17-advanced-scope--overlay-apis)

[Back to Top](#top)

---

<a id="api-overview"></a>

## API Overview

- **App bar and menus** — `DesktopAppBar`, `DesktopAppBarMenu`, and `DesktopSubmenu`.

- **Items and content** — `DesktopMenuItem`, `DesktopMenuDivider`, and custom menu widgets.

- **Interaction** — hover/click modes, focus, keyboard configuration, and key bindings.

- **Control** — `DesktopMenuController` for application-driven menu state.

- **Styling** — shared theme plus menu and app-bar style objects.

[Back to Top](#top)

---

<a id="testing"></a>

## Testing

The package includes widget tests for rendering, hover and click interaction, nested menus, disabled items, custom content, themes, controller state, and keyboard bindings.

To test package in an interactive code pen visit:  https://drewspackages.web.app/

![Drew's Desktop Menu](https://raw.githubusercontent.com/kutlwano-drew/drews_flutter_packages/main/packages/drews%20desktop%20menu/0.1.0/screenshots/drews%20flutter%20package.gif)

[Back to Top](#top)

---
<a id="developer"></a>
## Developer

#### Kutlwano (Drew) Maruatona

- [X/twitter:  @kutlwano_drew](https://x.com/kutlwano_drew)

- [GitHub:  kutlwano-drew](https://github.com/kutlwano-drew)

- [Ko-fi ](https://ko-fi.com/kutlwanodrew)

- [Package Code Pen:  https://drewspackages.web.app/](https://drewspackages.web.app)

[Back to Top](#top)

## Complete public API

This inventory mirrors the **All APIs** directory in the tester. It includes every API entry currently catalogued for this package, including less frequently used helpers and model types.

- **`DesktopMenuHandle`** — class; `src/core/desktop_menu_controller.dart`
- **`DesktopMenuController`** — class; `src/core/desktop_menu_controller.dart`
- **`DesktopKeyBinding`** — class; `src/core/desktop_menu_keyboard.dart`
- **`DesktopMenuKeyboardConfig`** — class; `src/core/desktop_menu_keyboard.dart`
- **`DesktopMenuScope`** — class; `src/core/desktop_menu_scope.dart`
- **`DesktopAppBarStyle`** — class; `src/core/desktop_menu_theme.dart`
- **`DesktopMenuStyle`** — class; `src/core/desktop_menu_theme.dart`
- **`DesktopMenuTheme`** — class; `src/core/desktop_menu_theme.dart`
- **`DesktopMenuInteractionMode`** — enum; `src/core/desktop_menu_types.dart`
- **`DesktopMenuKeyboardAction`** — enum; `src/core/desktop_menu_types.dart`
- **`DesktopMenuInputEvent`** — class; `src/core/desktop_menu_types.dart`
- **`DesktopAppBar`** — class; `src/widgets/desktop_app_bar.dart`
- **`DesktopAppBarMenu`** — class; `src/widgets/desktop_app_bar_menu.dart`
- **`DesktopAppBarMenuState`** — class; `src/widgets/desktop_app_bar_menu.dart`
- **`DesktopMenuDivider`** — class; `src/widgets/desktop_menu_divider.dart`
- **`DesktopMenuItem`** — class; `src/widgets/desktop_menu_item.dart`
- **`DesktopMenuPanel`** — class; `src/widgets/desktop_menu_panel.dart`
- **`DesktopSubmenu`** — class; `src/widgets/desktop_submenu.dart`

### API notes and usage recipes

These catalog notes help locate each declaration and its intended use. The runnable examples above show complete compositions; the catalog includes less frequently used building blocks as well.

#### `DesktopMenuHandle`

Source: `src/core/desktop_menu_controller.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuHandle — public API from src/core/desktop_menu_controller.dart
// A public handle to one registered menu.
// API kind: class
// Declaration: class DesktopMenuHandle {
Constructor signature: const DesktopMenuHandle ({
    required this.open,
    required this.close,
    required this.toggle,
    required this.focus,
    required this.isOpen,
  })
// Public members declared on this type:
//   final VoidCallback open;
//   final VoidCallback close;
//   final VoidCallback toggle;
//   final VoidCallback focus;
//   final bool Function() isOpen;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuHandle ({
    required this.open,
    required this.close,
    required this.toggle,
    required this.focus,
    required this.isOpen,
  })
// 3. Use the instance in the package composition where DesktopMenuHandle is accepted.
```

#### `DesktopMenuController`

Source: `src/core/desktop_menu_controller.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuController — public API from src/core/desktop_menu_controller.dart
// Application-facing controller for programmatic menu state.  Register a menu by giving [DesktopAppBarMenu.controllerKey]. The controller becomes an imperative escape hatch without preventing normal widget state, pointer interaction, or keyboard navigation.
// API kind: class
// Declaration: class DesktopMenuController extends ChangeNotifier {
// Public members declared on this type:
//   void register(Object key, DesktopMenuHandle handle) {
//   void unregister(Object key, DesktopMenuHandle handle) {
//   void open(Object key) {
//   void close(Object key) {
//   void toggle(Object key) {
//   void focus(Object key) {
//   void clearFocus() {
//   void dispose() {

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 3. Use the instance in the package composition where DesktopMenuController is accepted.
```

#### `DesktopKeyBinding`

Source: `src/core/desktop_menu_keyboard.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopKeyBinding — public API from src/core/desktop_menu_keyboard.dart
// A key plus optional modifier requirements.  This intentionally uses Flutter's [LogicalKeyboardKey], allowing callers to bind normal keys, function keys, media keys, and their own combinations.
// API kind: class
// Declaration: class DesktopKeyBinding {
Constructor signature: const DesktopKeyBinding ({
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  })
// Public members declared on this type:
//   final LogicalKeyboardKey key;
//   final bool control;
//   final bool shift;
//   final bool alt;
//   final bool meta;
//   bool matches(KeyEvent event) {

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopKeyBinding ({
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  })
// 3. Use the instance in the package composition where DesktopKeyBinding is accepted.
```

#### `DesktopMenuKeyboardConfig`

Source: `src/core/desktop_menu_keyboard.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuKeyboardConfig — public API from src/core/desktop_menu_keyboard.dart
// Configurable keyboard map for the whole menu system.  Every list is public so an application can replace the defaults completely. Set [enabled] or [handleKeyEvent] to false when the application wants to own keyboard handling itself.
// API kind: class
// Declaration: class DesktopMenuKeyboardConfig {
Constructor signature: const DesktopMenuKeyboardConfig ({
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
  })
// Public members declared on this type:
//   final List<DesktopKeyBinding> select;
//   final List<DesktopKeyBinding> open;
//   final List<DesktopKeyBinding> close;
//   final List<DesktopKeyBinding> next;
//   final List<DesktopKeyBinding> previous;
//   final List<DesktopKeyBinding> nextMenu;
//   final List<DesktopKeyBinding> previousMenu;
//   final List<DesktopKeyBinding> first;
//   final List<DesktopKeyBinding> last;
//   final List<DesktopKeyBinding> openSubmenu;
//   final List<DesktopKeyBinding> closeSubmenu;
//   final bool enabled;
//   final bool handleKeyEvent;
//   bool matches(DesktopMenuKeyboardAction action, KeyEvent event) =>

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuKeyboardConfig ({
    this.select = const [
      DesktopKeyBinding(key: LogicalKeyboardKey.enter),
      DesktopKeyBinding(key: LogicalKeyboardKey.space),
    ],
    this.open = const [
      DesktopKeyBinding(key: LogicalKeyboardKey.enter),
      DesktopKeyBinding(key: LogicalKeyb
// 3. Use the instance in the package composition where DesktopMenuKeyboardConfig is accepted.
```

#### `DesktopMenuScope`

Source: `src/core/desktop_menu_scope.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuScope — public API from src/core/desktop_menu_scope.dart
// Internal inherited state shared by all menu descendants.
// API kind: class
// Declaration: class DesktopMenuScope extends InheritedWidget {
Constructor signature: const DesktopMenuScope ({
    super.key,
    required this.theme,
    required this.interactionMode,
    required this.keyboard,
    required this.controller,
    required this.onInput,
    required this.onMenuOpened,
    required this.onMenuClosed,
    required super.child,
  })
// Public members declared on this type:
//   final DesktopMenuTheme theme;
//   final DesktopMenuInteractionMode interactionMode;
//   final DesktopMenuKeyboardConfig keyboard;
//   final DesktopMenuController controller;
//   final void Function(DesktopMenuInputEvent event)? onInput;
//   final void Function(Object? menuKey)? onMenuOpened;
//   final void Function(Object? menuKey)? onMenuClosed;
//   bool updateShouldNotify(DesktopMenuScope oldWidget) =>

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuScope ({
    super.key,
    required this.theme,
    required this.interactionMode,
    required this.keyboard,
    required this.controller,
    required this.onInput,
    required this.onMenuOpened,
    required this.onMenuClosed,
    required super.child,
  })
// 3. Use the instance in the package composition where DesktopMenuScope is accepted.
```

#### `DesktopAppBarStyle`

Source: `src/core/desktop_menu_theme.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopAppBarStyle — public API from src/core/desktop_menu_theme.dart
// Styling for the app-bar chrome.
// API kind: class
// Declaration: class DesktopAppBarStyle {
Constructor signature: const DesktopAppBarStyle ({
    this.height = 40,
    this.backgroundColor = const Color(0xFF101016),
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.white10,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.itemSpacing = 4,
  })
// Public members declared on this type:
//   final double height;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final Color borderColor;
//   final double borderWidth;
//   final EdgeInsets padding;
//   final double itemSpacing;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopAppBarStyle ({
    this.height = 40,
    this.backgroundColor = const Color(0xFF101016),
    this.foregroundColor = Colors.white,
    this.borderColor = Colors.white10,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.itemSpacing = 4,
  }
// 3. Use the instance in the package composition where DesktopAppBarStyle is accepted.
```

#### `DesktopMenuStyle`

Source: `src/core/desktop_menu_theme.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuStyle — public API from src/core/desktop_menu_theme.dart
// Styling shared by menu panels and standard menu controls.
// API kind: class
// Declaration: class DesktopMenuStyle {
Constructor signature: const DesktopMenuStyle ({
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
  })
// Public members declared on this type:
//   final double width;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final Color hoverColor;
//   final Color borderColor;
//   final double borderWidth;
//   final double borderRadius;
//   final double itemBorderRadius;
//   final EdgeInsets itemPadding;
//   final double itemSpacing;
//   final BoxShadow? shadow;
//   final double submenuGap;
//   final double submenuOffset;
//   final TextStyle textStyle;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuStyle ({
    this.width = 220,
    this.backgroundColor = const Color(0xFF16161F),
    this.foregroundColor = Colors.white,
    this.hoverColor = Colors.white10,
    this.borderColor = Colors.white10,
    this.borderWidth = 1,
    this.borderRadius = 10,
    this.itemBorderRadius = 
// 3. Use the instance in the package composition where DesktopMenuStyle is accepted.
```

#### `DesktopMenuTheme`

Source: `src/core/desktop_menu_theme.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuTheme — public API from src/core/desktop_menu_theme.dart
// Complete visual configuration for [DesktopAppBar].
// API kind: class
// Declaration: class DesktopMenuTheme {
Constructor signature: const DesktopMenuTheme ({
    this.appBar = const DesktopAppBarStyle(),
    this.menu = const DesktopMenuStyle(),
    this.triggerTextStyle = const TextStyle(fontSize: 12),
    this.cursor = SystemMouseCursors.click,
  })
// Public members declared on this type:
//   final DesktopAppBarStyle appBar;
//   final DesktopMenuStyle menu;
//   final TextStyle triggerTextStyle;
//   final MouseCursor cursor;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuTheme ({
    this.appBar = const DesktopAppBarStyle(),
    this.menu = const DesktopMenuStyle(),
    this.triggerTextStyle = const TextStyle(fontSize: 12),
    this.cursor = SystemMouseCursors.click,
  })
// 3. Use the instance in the package composition where DesktopMenuTheme is accepted.
```

#### `DesktopMenuInteractionMode`

Source: `src/core/desktop_menu_types.dart` · Kind: `enum`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuInteractionMode — public API from src/core/desktop_menu_types.dart
// Determines how a menu is opened by pointer input.
// API kind: enum
// Declaration: enum DesktopMenuInteractionMode { /// Menus open while the pointer is over their trigger.
  hover,

  /// Menus open and close when their trigger is clicked.
  click, }

// Usage:
final desktopMenuInteractionMode = DesktopMenuInteractionMode.values.first;
// Iterate all supported values:
for (final value in DesktopMenuInteractionMode.values) {
  debugPrint(value.name);
}
```

#### `DesktopMenuKeyboardAction`

Source: `src/core/desktop_menu_types.dart` · Kind: `enum`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuKeyboardAction — public API from src/core/desktop_menu_types.dart
// Semantic actions understood by the keyboard navigation layer.
// API kind: enum
// Declaration: enum DesktopMenuKeyboardAction { select,
  open,
  close,
  next,
  previous,
  nextMenu,
  previousMenu,
  first,
  last,
  openSubmenu,
  closeSubmenu, }

// Usage:
final desktopMenuKeyboardAction = DesktopMenuKeyboardAction.values.first;
// Iterate all supported values:
for (final value in DesktopMenuKeyboardAction.values) {
  debugPrint(value.name);
}
```

#### `DesktopMenuInputEvent`

Source: `src/core/desktop_menu_types.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuInputEvent — public API from src/core/desktop_menu_types.dart
// A small description of an input event that can be observed by applications.
// API kind: class
// Declaration: class DesktopMenuInputEvent {
Constructor signature: const DesktopMenuInputEvent ({
    required this.action,
    required this.keyEvent,
    this.menuKey,
  })
// Public members declared on this type:
//   final DesktopMenuKeyboardAction action;
//   final KeyEvent keyEvent;
//   final Object? menuKey;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuInputEvent ({
    required this.action,
    required this.keyEvent,
    this.menuKey,
  })
// 3. Use the instance in the package composition where DesktopMenuInputEvent is accepted.
```

#### `DesktopAppBar`

Source: `src/widgets/desktop_app_bar.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopAppBar — public API from src/widgets/desktop_app_bar.dart
// A compact, extensible desktop application bar.  Put [DesktopAppBarMenu] widgets, custom triggers, spacers, branding, or any other Flutter widgets in [children]. The package does not impose an application-specific menu model.
// API kind: class
// Declaration: class DesktopAppBar extends StatefulWidget implements PreferredSizeWidget {
Constructor signature: const DesktopAppBar ({
    super.key,
    required this.children,
    this.style = const DesktopMenuTheme(),
    this.interactionMode = DesktopMenuInteractionMode.hover,
    this.keyboard = const DesktopMenuKeyboardConfig(),
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.onKeyEvent,
    this.onInput,
    this.onMenuOpened,
    this.onMenuClosed,
    this.center,
    this.trailing,
  })
// Public members declared on this type:
//   final List<Widget> children;
//   final DesktopMenuTheme style;
//   final DesktopMenuInteractionMode interactionMode;
//   final DesktopMenuKeyboardConfig keyboard;
//   final DesktopMenuController? controller;
//   final FocusNode? focusNode;
//   final bool autofocus;
//   final KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent;
//   final void Function(DesktopMenuInputEvent event)? onInput;
//   final void Function(Object? menuKey)? onMenuOpened;
//   final void Function(Object? menuKey)? onMenuClosed;
//   final Widget? center;
//   final List<Widget>? trailing;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopAppBar ({
    super.key,
    required this.children,
    this.style = const DesktopMenuTheme(),
    this.interactionMode = DesktopMenuInteractionMode.hover,
    this.keyboard = const DesktopMenuKeyboardConfig(),
    this.controller,
    this.focusNode,
    this.autofocus = false,
    th
// 3. Use the instance in the package composition where DesktopAppBar is accepted.
```

#### `DesktopAppBarMenu`

Source: `src/widgets/desktop_app_bar_menu.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopAppBarMenu — public API from src/widgets/desktop_app_bar_menu.dart
// A top-level menu trigger for [DesktopAppBar].  Use [children] for normal menu content or [menu] when the application needs complete control over the panel. [trigger] can replace the default text trigger with any Flutter widget.
// API kind: class
// Declaration: class DesktopAppBarMenu extends StatefulWidget {
Constructor signature: const DesktopAppBarMenu ({
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
  })
// Public members declared on this type:
//   final String? label;
//   final Widget? trigger;
//   final List<Widget>? children;
//   final Widget? menu;
//   final DesktopMenuStyle? style;
//   final DesktopMenuKeyboardConfig? keyboard;
//   final DesktopMenuInteractionMode? interactionMode;
//   final bool? openOnHover;
//   final bool closeOnOutsideTap;
//   final Duration hoverOpenDelay;
//   final Duration hoverCloseDelay;
//   final double? width;
//   final EdgeInsets triggerPadding;
//   final VoidCallback? onOpen;
//   final VoidCallback? onClose;
//   final Object? controllerKey;
//   final FocusNode? focusNode;
//   final VoidCallback? onTriggerTap;
//   final bool toggleOnTriggerTap;
//   final KeyEventResult Function(

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopAppBarMenu ({
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
    this.hoverCloseDelay = cons
// 3. Use the instance in the package composition where DesktopAppBarMenu is accepted.
```

#### `DesktopAppBarMenuState`

Source: `src/widgets/desktop_app_bar_menu.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopAppBarMenuState — public API from src/widgets/desktop_app_bar_menu.dart
// Public state object so an application can obtain it with a [GlobalKey].
// API kind: class
// Declaration: class DesktopAppBarMenuState extends State<DesktopAppBarMenu> {
// Public members declared on this type:
//   void didChangeDependencies() {
//   void didUpdateWidget(
//   void dispose() {
//   void open() {
//   void close() {
//   void toggle() {
//   void focus() {

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 3. Use the instance in the package composition where DesktopAppBarMenuState is accepted.
```

#### `DesktopMenuDivider`

Source: `src/widgets/desktop_menu_divider.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuDivider — public API from src/widgets/desktop_menu_divider.dart
// A divider styled from the active menu theme.
// API kind: class
// Declaration: class DesktopMenuDivider extends StatelessWidget {
Constructor signature: const DesktopMenuDivider ({
    super.key,
    this.height = 8,
    this.indent = 0,
    this.endIndent = 0,
  })
// Public members declared on this type:
//   final double height;
//   final double indent;
//   final double endIndent;
//   Widget build(BuildContext context) {

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuDivider ({
    super.key,
    this.height = 8,
    this.indent = 0,
    this.endIndent = 0,
  })
// 3. Use the instance in the package composition where DesktopMenuDivider is accepted.
```

#### `DesktopMenuItem`

Source: `src/widgets/desktop_menu_item.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuItem — public API from src/widgets/desktop_menu_item.dart
// A standard menu command.  The command itself belongs to the application: the package only invokes [onPressed]. Supply [child] when you need completely custom rendering.
// API kind: class
// Declaration: class DesktopMenuItem extends StatefulWidget {
Constructor signature: const DesktopMenuItem ({
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
  })
// Public members declared on this type:
//   final String? label;
//   final Widget? icon;
//   final Widget? trailing;
//   final Widget? child;
//   final VoidCallback? onPressed;
//   final bool enabled;
//   final DesktopMenuStyle? style;
//   final DesktopMenuKeyboardConfig? keyboard;
//   final FocusNode? focusNode;
//   final String? semanticLabel;
//   final bool autofocus;
//   final KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent;

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuItem ({
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
  })
// 3. Use the instance in the package composition where DesktopMenuItem is accepted.
```

#### `DesktopMenuPanel`

Source: `src/widgets/desktop_menu_panel.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopMenuPanel — public API from src/widgets/desktop_menu_panel.dart
// The visual shell used for dropdown and cascading menu content.
// API kind: class
// Declaration: class DesktopMenuPanel extends StatelessWidget {
Constructor signature: const DesktopMenuPanel ({
    super.key,
    required this.child,
    this.style,
    this.padding = const EdgeInsets.all(8),
  })
// Public members declared on this type:
//   final Widget child;
//   final DesktopMenuStyle? style;
//   final EdgeInsets padding;
//   Widget build(BuildContext context) {

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopMenuPanel ({
    super.key,
    required this.child,
    this.style,
    this.padding = const EdgeInsets.all(8),
  })
// 3. Use the instance in the package composition where DesktopMenuPanel is accepted.
```

#### `DesktopSubmenu`

Source: `src/widgets/desktop_submenu.dart` · Kind: `class`

```text
import 'package:flutter/material.dart';
import 'package:drews_desktop_menu/drews_desktop_menu.dart';

// DesktopSubmenu — public API from src/widgets/desktop_submenu.dart
// A cascading menu item that opens another panel to the side.
// API kind: class
// Declaration: class DesktopSubmenu extends StatefulWidget {
Constructor signature: const DesktopSubmenu ({
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
  })
// Public members declared on this type:
//   final String label;
//   final List<Widget> children;
//   final Widget? icon;
//   final Widget? trailing;
//   final Widget? trigger;
//   final DesktopMenuStyle? style;
//   final DesktopMenuKeyboardConfig? keyboard;
//   final DesktopMenuInteractionMode? interactionMode;
//   final bool? openOnHover;
//   final double? width;
//   final Duration openDelay;
//   final Duration closeDelay;
//   final FocusNode? focusNode;
//   final Object? controllerKey;
//   final VoidCallback? onOpen;
//   final VoidCallback? onClose;
//   final KeyEventResult Function(

// Usage pattern:
// 1. Import the package barrel: package:drews_desktop_menu/drews_desktop_menu.dart
// 2. Create the type using its constructor: const DesktopSubmenu ({
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
    this.closeDelay =
// 3. Use the instance in the package composition where DesktopSubmenu is accepted.
```
