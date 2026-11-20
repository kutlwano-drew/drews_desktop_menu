import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Positions arbitrary menu content relative to a [LayerLink].
///
/// Higher-level menu widgets use this small primitive so overlay positioning
/// remains isolated from menu state and interaction logic.
///
/// The pointer callbacks intentionally retain Flutter's native
/// [PointerEnterEventListener] and [PointerExitEventListener] types so that
/// callers can pass the same callbacks directly to [MouseRegion] and other
/// Flutter pointer-aware widgets.
class DesktopMenuOverlay extends StatelessWidget {
  /// Creates a menu overlay positioned relative to [link].
  const DesktopMenuOverlay({
    super.key,
    required this.link,
    required this.child,
    required this.width,
    required this.offset,
    this.targetAnchor = Alignment.topLeft,
    this.followerAnchor = Alignment.topLeft,
    this.onEnter,
    this.onExit,
  });

  /// The [LayerLink] connecting this overlay to its trigger.
  final LayerLink link;

  /// The widget displayed inside the overlay.
  final Widget child;

  /// The width of the overlay.
  final double width;

  /// The positional offset applied to the follower.
  final Offset offset;

  /// The anchor point on the target widget.
  final Alignment targetAnchor;

  /// The anchor point on this overlay.
  final Alignment followerAnchor;

  /// Called when the pointer enters the overlay.
  final PointerEnterEventListener? onEnter;

  /// Called when the pointer exits the overlay.
  final PointerExitEventListener? onExit;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: width,
      child: CompositedTransformFollower(
        link: link,
        showWhenUnlinked: false,
        targetAnchor: targetAnchor,
        followerAnchor: followerAnchor,
        offset: offset,
        child: MouseRegion(
          opaque: false,
          hitTestBehavior: HitTestBehavior.translucent,
          onEnter: onEnter,
          onExit: onExit,
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}
