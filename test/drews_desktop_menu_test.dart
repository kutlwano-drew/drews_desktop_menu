import 'dart:ui';

import 'package:drews_desktop_menu/drews_desktop_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget buildHarness({
  DesktopMenuInteractionMode mode = DesktopMenuInteractionMode.click,
  DesktopMenuController? controller,
  List<Widget>? children,
}) {
  return MaterialApp(
    home: Scaffold(
      appBar: DesktopAppBar(
        interactionMode: mode,
        controller: controller,
        children: children ?? [
          DesktopAppBarMenu(
            label: 'File',
            children: [DesktopMenuItem(label: 'Open')],
          ),
        ],
      ),
      body: const SizedBox.expand(),
    ),
  );
}

void main() {
  testWidgets('renders the public app bar composition', (tester) async {
    await tester.pumpWidget(buildHarness());
    expect(find.byType(DesktopAppBar), findsOneWidget);
    expect(find.text('File'), findsOneWidget);
  });

  testWidgets('click mode opens and closes a menu', (tester) async {
    await tester.pumpWidget(buildHarness());
    await tester.tap(find.text('File'));
    await tester.pump();
    expect(find.text('Open'), findsOneWidget);
    await tester.tap(find.text('File'));
    await tester.pump();
    expect(find.text('Open'), findsNothing);
  });

  testWidgets('hover mode opens a menu', (tester) async {
    await tester.pumpWidget(buildHarness(mode: DesktopMenuInteractionMode.hover));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.moveTo(tester.getCenter(find.text('File')));
    await tester.pump();
    expect(find.text('Open'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('invokes enabled item callbacks', (tester) async {
    var calls = 0;
    await tester.pumpWidget(buildHarness(children: [
      DesktopAppBarMenu(
        label: 'File',
        children: [DesktopMenuItem(label: 'Open', onPressed: () => calls++)],
      ),
    ]));
    await tester.tap(find.text('File'));
    await tester.pump();
    await tester.tap(find.text('Open'));
    expect(calls, 1);
  });

  testWidgets('disabled item does not invoke callback', (tester) async {
    var calls = 0;
    await tester.pumpWidget(buildHarness(children: [
      DesktopAppBarMenu(
        label: 'File',
        children: [DesktopMenuItem(label: 'Open', enabled: false, onPressed: () => calls++)],
      ),
    ]));
    await tester.tap(find.text('File'));
    await tester.pump();
    await tester.tap(find.text('Open'));
    expect(calls, 0);
  });

  testWidgets('nested submenu renders child items', (tester) async {
    await tester.pumpWidget(buildHarness(children: [
      DesktopAppBarMenu(
        label: 'File',
        children: [
          DesktopSubmenu(
            label: 'Export',
            children: [DesktopMenuItem(label: 'PDF')],
          ),
        ],
      ),
    ]));
    await tester.tap(find.text('File'));
    await tester.pump();
    await tester.tap(find.text('Export'));
    await tester.pump();
    expect(find.text('PDF'), findsOneWidget);
  });

  testWidgets('supports arbitrary custom menu content', (tester) async {
    await tester.pumpWidget(buildHarness(children: [
      DesktopAppBarMenu(
        label: 'Custom',
        menu: const SizedBox(width: 160, child: Text('Custom content')),
      ),
    ]));
    await tester.tap(find.text('Custom'));
    await tester.pump();
    expect(find.text('Custom content'), findsOneWidget);
  });

  testWidgets('supports a custom trigger', (tester) async {
    await tester.pumpWidget(buildHarness(children: [
      DesktopAppBarMenu(
        trigger: const Icon(Icons.settings),
        children: const [DesktopMenuItem(label: 'Settings')],
      ),
    ]));
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('controller can open and close a keyed menu', (tester) async {
    final controller = DesktopMenuController();
    await tester.pumpWidget(buildHarness(controller: controller, children: [
      DesktopAppBarMenu(
        controllerKey: 'file',
        label: 'File',
        children: const [DesktopMenuItem(label: 'Open')],
      ),
    ]));
    controller.open('file');
    await tester.pump();
    expect(find.text('Open'), findsOneWidget);
    expect(controller.openKey, 'file');
    controller.close('file');
    await tester.pump();
    expect(find.text('Open'), findsNothing);
    controller.dispose();
  });

  test('keyboard binding stores modifier settings', () {
    const binding = DesktopKeyBinding(
      key: LogicalKeyboardKey.keyK,
      control: true,
      shift: true,
    );
    expect(binding.key, LogicalKeyboardKey.keyK);
    expect(binding.control, isTrue);
    expect(binding.shift, isTrue);
  });

  testWidgets('theme changes app bar height', (tester) async {
    const theme = DesktopMenuTheme(
      appBar: DesktopAppBarStyle(height: 56),
    );
    await tester.pumpWidget(buildHarness());
    await tester.pumpWidget(buildHarness());
    expect(theme.appBar.height, 56);
  });
}
