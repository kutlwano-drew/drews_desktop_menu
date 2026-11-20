import 'package:drews_desktop_menu/drews_desktop_menu.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DesktopMenuExampleApp());

class DesktopMenuExampleApp extends StatefulWidget {
  const DesktopMenuExampleApp({super.key});

  @override
  State<DesktopMenuExampleApp> createState() => _DesktopMenuExampleAppState();
}

class _DesktopMenuExampleAppState extends State<DesktopMenuExampleApp> {
  final controller = DesktopMenuController();
  String status = 'Ready';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: Scaffold(
        appBar: DesktopAppBar(
          controller: controller,
          interactionMode: DesktopMenuInteractionMode.hover,
          children: [
            DesktopAppBarMenu(
              controllerKey: 'file',
              label: 'File',
              children: [
                DesktopMenuItem(label: 'New', onPressed: () => setState(() => status = 'New')),
                DesktopMenuItem(label: 'Open', onPressed: () => setState(() => status = 'Open')),
                const DesktopMenuDivider(),
                DesktopMenuItem(label: 'Close', enabled: false),
              ],
            ),
            DesktopAppBarMenu(
              label: 'View',
              children: [
                DesktopSubmenu(
                  label: 'Panels',
                  children: [
                    DesktopMenuItem(label: 'Explorer', onPressed: () => setState(() => status = 'Explorer')),
                    DesktopMenuItem(label: 'Inspector', onPressed: () => setState(() => status = 'Inspector')),
                  ],
                ),
              ],
            ),
            DesktopAppBarMenu(
              trigger: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.settings_outlined),
              ),
              menu: const SizedBox(
                width: 220,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Custom menu content'),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(status),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => controller.open('file'),
                child: const Text('Open File menu programmatically'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
