// A library of Flutter widgets that allow creating expandable panels
library expandable;

import 'package:flutter/material.dart';
import 'dart:math' as math;

///
///
///
class ExpandableThemeData {
  // static const ExpandableThemeData defaults = ExpandableThemeData(
  //   iconColor: Colors.black54,
  //   useInkWell: true,
  //   inkWellBorderRadius: BorderRadius.zero,
  //   animationDuration:  Duration(milliseconds: 300),
  //   scrollAnimationDuration:  Duration(milliseconds: 300),
  //   crossFadePoint: 0.5,
  //   fadeCurve: Curves.linear,
  //   sizeCurve: Curves.fastOutSlowIn,
  //   alignment: Alignment.topLeft,
  //   headerAlignment: ExpandablePanelHeaderAlignment.top,
  //   bodyAlignment: ExpandablePanelBodyAlignment.left,
  //   iconPlacement: ExpandablePanelIconPlacement.right,
  //   tapHeaderToExpand: true,
  //   tapBodyToExpand: false,
  //   tapBodyToCollapse: false,
  //   hasIcon: true,
  //   iconSize: 24.0,
  //   iconPadding: EdgeInsets.all(8.0),
  //   iconRotationAngle: -math.pi,
  //   expandIcon: Icons.expand_more,
  //   collapseIcon: Icons.expand_more,
  // );
  //
  // static const ExpandableThemeData empty =  ExpandableThemeData();

  // Expand icon color.
  final Color iconColor;

  // If true then [InkWell] will be used in the header for a ripple effect.
  final bool useInkWell;

  // The duration of the transition between collapsed and expanded states.
  final Duration animationDuration;

  // The duration of the scroll animation to make the expanded widget visible.
  final Duration scrollAnimationDuration;

  /// The point in the cross-fade animation timeline (from 0 to 1)
  /// where the [collapsed] and [expanded] widgets are half-visible.
  ///
  /// If set to 0, the [expanded] widget will be shown immediately in full opacity
  /// when the size transition starts. This is useful if the collapsed widget is
  /// empty or if dealing with text that is shown partially in the collapsed state.
  /// This is the default value.
  ///
  /// If set to 0.5, the [expanded] and the [collapsed] widget will be shown
  /// at half of their opacity in the middle of the size animation with a
  /// cross-fade effect throughout the entire size transition.
  ///
  /// If set to 1, the [expanded] widget will be shown at the very end of the size animation.
  ///
  /// When collapsing, the effect of this setting is reversed. For example, if the value is 0
  /// then the [expanded] widget will remain to be shown until the end of the size animation.
  final double crossFadePoint;

  /// The alignment of widgets during animation between expanded and collapsed states.
  final AlignmentGeometry alignment;

  // Fade animation curve between expanded and collapsed states.
  final Curve fadeCurve;

  // Size animation curve between expanded and collapsed states.
  final Curve sizeCurve;

  // The alignment of the header for `ExpandablePanel`.
  final ExpandablePanelHeaderAlignment headerAlignment;

  // The alignment of the body for `ExpandablePanel`.
  final ExpandablePanelBodyAlignment bodyAlignment;

  /// Expand icon placement.
  final ExpandablePanelIconPlacement iconPlacement;

  /// If true, the header of [ExpandablePanel] can be clicked by the user to expand or collapse.
  final bool tapHeaderToExpand;

  /// If true, the body of [ExpandablePanel] can be clicked by the user to expand.
  final bool tapBodyToExpand;

  /// If true, the body of [ExpandablePanel] can be clicked by the user to collapse.
  final bool tapBodyToCollapse;

  /// If true, an icon is shown in the header of [ExpandablePanel].
  final bool hasIcon;

  /// Expand icon size.
  final double iconSize;

  /// Expand icon padding.
  final EdgeInsets iconPadding;

  /// Icon rotation angle in clockwise radians. For example, specify `math.pi` to rotate the icon by 180 degrees
  /// clockwise when clicking on the expand button.
  final double iconRotationAngle;

  /// The icon in the collapsed state.
  final IconData? expandIcon;

  /// The icon in the expanded state. If you specify the same icon as `expandIcon`, the `expandIcon` icon will
  /// be shown upside-down in the expanded state.
  final IconData collapseIcon;

  ///The [BorderRadius] for the [InkWell], if `inkWell` is set to true
  final BorderRadius inkWellBorderRadius;

  ///
  ///
  ///
  const ExpandableThemeData({
    this.iconColor = Colors.black54,
    this.useInkWell = true,
    this.inkWellBorderRadius = BorderRadius.zero,
    this.animationDuration = const Duration(milliseconds: 300),
    this.scrollAnimationDuration = const Duration(milliseconds: 300),
    this.crossFadePoint = 0.5,
    this.fadeCurve = Curves.linear,
    this.sizeCurve = Curves.fastOutSlowIn,
    this.alignment = Alignment.topLeft,
    this.headerAlignment = ExpandablePanelHeaderAlignment.top,
    this.bodyAlignment = ExpandablePanelBodyAlignment.left,
    this.iconPlacement = ExpandablePanelIconPlacement.right,
    this.tapHeaderToExpand = true,
    this.tapBodyToExpand = false,
    this.tapBodyToCollapse = false,
    this.hasIcon = true,
    this.iconSize = 24.0,
    this.iconPadding = const EdgeInsets.all(8.0),
    this.iconRotationAngle = -math.pi,
    this.expandIcon = Icons.expand_more,
    this.collapseIcon = Icons.expand_more,
  });

  // static ExpandableThemeData combine(
  //     ExpandableThemeData theme, ExpandableThemeData defaults) {
  //   if (defaults.isEmpty()) {
  //     return theme;
  //   } else if (theme.isEmpty()) {
  //     return defaults;
  // } else if (theme.isFull()) {
  //   return theme;
  // } else {
  //   return ExpandableThemeData(
  //     iconColor: theme.iconColor ?? defaults.iconColor,
  //     useInkWell: theme.useInkWell ?? defaults.useInkWell,
  //     inkWellBorderRadius: theme.inkWellBorderRadius ?? defaults.inkWellBorderRadius,
  //     animationDuration:
  //         theme.animationDuration ?? defaults.animationDuration,
  //     scrollAnimationDuration:
  //         theme.scrollAnimationDuration ?? defaults.scrollAnimationDuration,
  //     crossFadePoint: theme.crossFadePoint ?? defaults.crossFadePoint,
  //     fadeCurve: theme.fadeCurve ?? defaults.fadeCurve,
  //     sizeCurve: theme.sizeCurve ?? defaults.sizeCurve,
  //     alignment: theme.alignment ?? defaults.alignment,
  //     headerAlignment: theme.headerAlignment ?? defaults.headerAlignment,
  //     bodyAlignment: theme.bodyAlignment ?? defaults.bodyAlignment,
  //     iconPlacement: theme.iconPlacement ?? defaults.iconPlacement,
  //     tapHeaderToExpand:
  //         theme.tapHeaderToExpand ?? defaults.tapHeaderToExpand,
  //     tapBodyToExpand: theme.tapBodyToExpand ?? defaults.tapBodyToExpand,
  //     tapBodyToCollapse:
  //         theme.tapBodyToCollapse ?? defaults.tapBodyToCollapse,
  //     hasIcon: theme.hasIcon ?? defaults.hasIcon,
  //     iconSize: theme.iconSize ?? defaults.iconSize,
  //     iconPadding: theme.iconPadding ?? defaults.iconPadding,
  //     iconRotationAngle:
  //         theme.iconRotationAngle ?? defaults.iconRotationAngle,
  //     expandIcon: theme.expandIcon ?? defaults.expandIcon,
  //     collapseIcon: theme.collapseIcon ?? defaults.collapseIcon,
  //   );
  // }
  // }

  double get collapsedFadeStart =>
      crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);

  double get collapsedFadeEnd => crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;

  double get expandedFadeStart =>
      crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);

  double get expandedFadeEnd => crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;

  // ExpandableThemeData nullIfEmpty() {
  //   return isEmpty() ? null : this;
  // }

  // bool isEmpty() {
  //   return this == empty;
  // }

  // bool isFull() {
  //   return this.iconColor != null &&
  //       this.useInkWell != null &&
  //       this.inkWellBorderRadius != null &&
  //       this.animationDuration != null &&
  //       this.scrollAnimationDuration != null &&
  //       this.crossFadePoint != null &&
  //       this.fadeCurve != null &&
  //       this.sizeCurve != null &&
  //       this.alignment != null &&
  //       this.headerAlignment != null &&
  //       this.bodyAlignment != null &&
  //       this.iconPlacement != null &&
  //       this.tapHeaderToExpand != null &&
  //       this.tapBodyToExpand != null &&
  //       this.tapBodyToCollapse != null &&
  //       this.hasIcon != null &&
  //       this.iconRotationAngle != null &&
  //       this.expandIcon != null &&
  //       this.collapseIcon != null;
  // }

  ///
  ///
  ///
  @override
  bool operator ==(dynamic o) {
    if (identical(this, o)) {
      return true;
    } else if (o is ExpandableThemeData) {
      return iconColor == o.iconColor &&
          useInkWell == o.useInkWell &&
          inkWellBorderRadius == o.inkWellBorderRadius &&
          animationDuration == o.animationDuration &&
          scrollAnimationDuration == o.scrollAnimationDuration &&
          crossFadePoint == o.crossFadePoint &&
          fadeCurve == o.fadeCurve &&
          sizeCurve == o.sizeCurve &&
          alignment == o.alignment &&
          headerAlignment == o.headerAlignment &&
          bodyAlignment == o.bodyAlignment &&
          iconPlacement == o.iconPlacement &&
          tapHeaderToExpand == o.tapHeaderToExpand &&
          tapBodyToExpand == o.tapBodyToExpand &&
          tapBodyToCollapse == o.tapBodyToCollapse &&
          hasIcon == o.hasIcon &&
          iconRotationAngle == o.iconRotationAngle &&
          expandIcon == o.expandIcon &&
          collapseIcon == o.collapseIcon;
    } else {
      return false;
    }
  }

  ///
  ///
  ///
  @override
  int get hashCode {
    return 0; // we don't care
  }

  ///
  ///
  ///
  static ExpandableThemeData of(BuildContext context,
      {bool rebuildOnChange = true}) {
    final _ExpandableThemeNotifier? notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_ExpandableThemeNotifier>()
        : context.findAncestorWidgetOfExactType<_ExpandableThemeNotifier>();
    return notifier?.themeData ?? ExpandableThemeData();
  }

// static ExpandableThemeData withDefaults(
//     ExpandableThemeData theme, BuildContext context,
//     {bool rebuildOnChange = true}) {
//   if (theme != null && theme.isFull()) {
//     return theme;
//   } else {
//     return combine(
//         combine(theme, of(context, rebuildOnChange: rebuildOnChange)),
//         defaults);
//   }
// }
}

///
///
///
class ExpandableTheme extends StatelessWidget {
  final ExpandableThemeData data;
  final Widget child;

  ///
  ///
  ///
  ExpandableTheme({
    required this.data,
    required this.child,
  });

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    _ExpandableThemeNotifier? etn =
        context.dependOnInheritedWidgetOfExactType<_ExpandableThemeNotifier>();
    return _ExpandableThemeNotifier(
      themeData: etn == null ? data : etn.themeData,
      child: child,
    );
  }
}

///
///
///
/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class ExpandableNotifier extends StatefulWidget {
  final ExpandableController? controller;
  final bool? initialExpanded;
  final Widget child;

  ///
  ///
  ///
  ExpandableNotifier(
      {

      /// An optional key
      Key? key,

      /// If the controller is not provided, it's created with the initial value of `initialExpanded`.
      this.controller,

      /// Initial expanded state. Must not be used together with [controller].
      this.initialExpanded,

      /// The child can be any widget which contains [Expandable] widgets in its widget tree.
      required this.child})
      : assert(!(controller != null && initialExpanded != null)),
        super(key: key);

  ///
  ///
  ///
  @override
  _ExpandableNotifierState createState() => _ExpandableNotifierState();
}

///
///
///
class _ExpandableNotifierState extends State<ExpandableNotifier> {
  ExpandableController? controller;
  ExpandableThemeData? theme;

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    controller = widget.controller ??
        ExpandableController(initialExpanded: widget.initialExpanded ?? false);
  }

  ///
  ///
  ///
  @override
  void didUpdateWidget(ExpandableNotifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      setState(() {
        controller = widget.controller;
      });
    }
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final _ExpandableControllerNotifier cn = _ExpandableControllerNotifier(
        controller: controller!, child: widget.child);

    return theme != null
        ? _ExpandableThemeNotifier(themeData: theme!, child: cn)
        : cn;
  }
}

///
///
///
/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _ExpandableControllerNotifier
    extends InheritedNotifier<ExpandableController> {
  ///
  ///
  ///
  _ExpandableControllerNotifier({
    required ExpandableController controller,
    required Widget child,
  }) : super(notifier: controller, child: child);
}

///
///
///
/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _ExpandableThemeNotifier extends InheritedWidget {
  final ExpandableThemeData themeData;

  ///
  ///
  ///
  _ExpandableThemeNotifier({
    required this.themeData,
    required Widget child,
  }) : super(child: child);

  ///
  ///
  ///
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return !(oldWidget is _ExpandableThemeNotifier &&
        oldWidget.themeData == themeData);
  }
}

///
///
///
/// Controls the state (expanded or collapsed) of one or more [Expandable].
/// The controller should be provided to [Expandable] via [ExpandableNotifier].
class ExpandableController extends ValueNotifier<bool> {
  /// Returns [true] if the state is expanded, [false] if collapsed.
  bool get expanded => value;

  ///
  ///
  ///
  ExpandableController({bool initialExpanded = false}) : super(initialExpanded);

  ///
  ///
  ///
  /// Sets the expanded state.
  set expanded(bool exp) {
    value = exp;
  }

  ///
  ///
  ///
  /// Sets the expanded state to the opposite of the current state.
  void toggle() {
    expanded = !expanded;
  }

  ///
  ///
  ///
  static ExpandableController? of(BuildContext context,
      {bool rebuildOnChange = true}) {
    final _ExpandableControllerNotifier? notifier = rebuildOnChange
        ? context
            .dependOnInheritedWidgetOfExactType<_ExpandableControllerNotifier>()
        : context
            .findAncestorWidgetOfExactType<_ExpandableControllerNotifier>();
    return notifier?.notifier;
  }
}

///
///
///
/// Shows either the expanded or the collapsed child depending on the state.
/// The state is determined by an instance of [ExpandableController] provided by [ScopedModel]
class Expandable extends StatelessWidget {
  /// Whe widget to show when collapsed
  final Widget collapsed;

  /// The widget to show when expanded
  final Widget expanded;

  /// If the controller is not specified, it will be retrieved from the context
  final ExpandableController? controller;

  final ExpandableThemeData theme;

  Expandable({
    Key? key,
    required this.collapsed,
    required this.expanded,
    this.controller,
    this.theme = const ExpandableThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ExpandableController? controller =
        this.controller ?? ExpandableController.of(context);

    return AnimatedCrossFade(
      alignment: theme.alignment,
      firstChild: collapsed,
      secondChild: expanded,
      firstCurve: Interval(theme.collapsedFadeStart, theme.collapsedFadeEnd,
          curve: theme.fadeCurve),
      secondCurve: Interval(theme.expandedFadeStart, theme.expandedFadeEnd,
          curve: theme.fadeCurve),
      sizeCurve: theme.sizeCurve,
      crossFadeState: controller!.expanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: theme.animationDuration,
    );
  }
}

///
///
///
/// Determines the placement of the expand/collapse icon in [ExpandablePanel]
enum ExpandablePanelIconPlacement {
  /// The icon is on the left of the header
  left,

  /// The icon is on the right of the header
  right,
}

///
///
///
/// Determines the alignment of the header relative to the expand icon
enum ExpandablePanelHeaderAlignment {
  /// The header and the icon are aligned at their top positions
  top,

  /// The header and the icon are aligned at their center positions
  center,

  /// The header and the icon are aligned at their bottom positions
  bottom,
}

///
///
///
/// Determines vertical alignment of the body
enum ExpandablePanelBodyAlignment {
  /// The body is positioned at the left
  left,

  /// The body is positioned in the center
  center,

  /// The body is positioned at the right
  right,
}

///
///
///
/// A configurable widget for showing user-expandable content with an optional expand button.
class ExpandablePanel extends StatelessWidget {
  /// If specified, the header is always shown, and the expandable part is shown under the header
  final Widget? header;

  /// The widget shown in the collapsed state
  final Widget collapsed;

  /// The widget shown in the expanded state
  final Widget expanded;

  /// Builds an Expandable object, optional
  final Widget Function(
    BuildContext context,
    Widget collapsed,
    Widget expanded,
  )? builder;

  /// An optional controller. If not specified, a default controller will be
  /// obtained from a surrounding [ExpandableNotifier]. If that does not exist,
  /// the controller will be created with the initial state of [initialExpanded].
  final ExpandableController? controller;

  final ExpandableThemeData theme;

  ///
  ///
  ///
  ExpandablePanel({
    Key? key,
    this.header,
    required this.collapsed,
    required this.expanded,
    this.controller,
    this.builder,
    this.theme = const ExpandableThemeData(),
  }) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    Widget buildHeaderRow() {
      CrossAxisAlignment calculateHeaderCrossAxisAlignment() {
        switch (theme.headerAlignment) {
          case ExpandablePanelHeaderAlignment.top:
            return CrossAxisAlignment.start;
          case ExpandablePanelHeaderAlignment.center:
            return CrossAxisAlignment.center;
          case ExpandablePanelHeaderAlignment.bottom:
            return CrossAxisAlignment.end;
        }
      }

      Widget wrapWithExpandableButton(Widget widget, bool wrap) {
        return wrap ? ExpandableButton(child: widget) : widget;
      }

      if (!theme.hasIcon) {
        return wrapWithExpandableButton(header!, theme.tapHeaderToExpand);
      } else {
        final List<Widget> rowChildren = <Widget>[
          Expanded(
            child: header!,
          ),
          wrapWithExpandableButton(
              ExpandableIcon(theme: theme), !theme.tapHeaderToExpand)
        ];

        return wrapWithExpandableButton(
            Row(
              crossAxisAlignment: calculateHeaderCrossAxisAlignment(),
              children:
                  theme.iconPlacement == ExpandablePanelIconPlacement.right
                      ? rowChildren
                      : rowChildren.reversed.toList(),
            ),
            theme.tapHeaderToExpand);
      }
    }

    Widget buildBody() {
      Widget wrapBody(Widget child, bool tap) {
        Alignment calcAlignment() {
          switch (theme.bodyAlignment) {
            case ExpandablePanelBodyAlignment.left:
              return Alignment.topLeft;
            case ExpandablePanelBodyAlignment.center:
              return Alignment.topCenter;
            case ExpandablePanelBodyAlignment.right:
              return Alignment.topRight;
          }
        }

        final Align widget = Align(
          alignment: calcAlignment(),
          child: child,
        );

        if (!tap) {
          return widget;
        }
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ExpandableController.of(context)?.toggle();
          },
          child: widget,
        );
      }

      final Widget Function(
        BuildContext context,
        Widget collapsed,
        Widget expanded,
      ) builder = this.builder ??
          (
            BuildContext context,
            Widget collapsed,
            Widget expanded,
          ) {
            return Expandable(
              collapsed: collapsed,
              expanded: expanded,
              theme: theme,
            );
          };

      return builder(context, wrapBody(collapsed, theme.tapBodyToExpand),
          wrapBody(expanded, theme.tapBodyToCollapse));
    }

    Widget buildWithHeader() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeaderRow(),
          buildBody(),
        ],
      );
    }

    final Widget panel = header != null ? buildWithHeader() : buildBody();

    if (controller != null) {
      return ExpandableNotifier(
        controller: controller,
        child: panel,
      );
    } else {
      final ExpandableController? controller =
          ExpandableController.of(context, rebuildOnChange: false);

      if (controller == null) {
        return ExpandableNotifier(
          child: panel,
        );
      } else {
        return panel;
      }
    }
  }
}

///
///
///
/// An down/up arrow icon that toggles the state of [ExpandableController] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableIcon extends StatefulWidget {
  final ExpandableThemeData theme;

  ExpandableIcon({
    this.theme = const ExpandableThemeData(),
  });

  @override
  _ExpandableIconState createState() => _ExpandableIconState();
}

///
///
///
class _ExpandableIconState extends State<ExpandableIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  ExpandableController? controller;

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        duration: widget.theme.animationDuration, vsync: this);

    animation = animationController?.drive(Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: widget.theme.sizeCurve)));

    controller = ExpandableController.of(context, rebuildOnChange: false);

    controller?.addListener(_expandedStateChanged);

    if (controller!.expanded) {
      animationController?.value = 1.0;
    }
  }

  ///
  ///
  ///
  @override
  void dispose() {
    controller?.removeListener(_expandedStateChanged);
    animationController?.dispose();
    super.dispose();
  }

  ///
  ///
  ///
  @override
  void didUpdateWidget(ExpandableIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.theme != oldWidget.theme) {
    //   theme = null;
    // }
  }

  ///
  ///
  ///
  void _expandedStateChanged() {
    if (controller!.expanded &&
        const <AnimationStatus>[
          AnimationStatus.dismissed,
          AnimationStatus.reverse,
        ].contains(animationController!.status)) {
      animationController!.forward();
    } else if (!controller!.expanded &&
        const <AnimationStatus>[
          AnimationStatus.completed,
          AnimationStatus.forward,
        ].contains(animationController!.status)) {
      animationController!.reverse();
    }
  }

  ///
  ///
  ///
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ExpandableController? controller2 =
        ExpandableController.of(context, rebuildOnChange: false);
    if (controller2 != controller) {
      controller?.removeListener(_expandedStateChanged);
      controller = controller2;
      controller?.addListener(_expandedStateChanged);
      if (controller!.expanded) {
        animationController?.value = 1.0;
      }
    }
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    // if (theme == null) {
    //   theme = ExpandableThemeData.withDefaults(widget._theme, context);
    // }

    return Padding(
      padding: widget.theme.iconPadding,
      child: AnimatedBuilder(
        animation: animation!,
        builder: (BuildContext? context, Widget? child) {
          final bool showSecondIcon =
              widget.theme.collapseIcon != widget.theme.expandIcon &&
                  animationController!.value >= 0.5;

          return Transform.rotate(
            angle: widget.theme.iconRotationAngle *
                (showSecondIcon
                    ? -(1.0 - animationController!.value)
                    : animationController!.value),
            child: Icon(
              showSecondIcon
                  ? widget.theme.collapseIcon
                  : widget.theme.expandIcon,
              color: widget.theme.iconColor,
              size: widget.theme.iconSize,
            ),
          );
        },
      ),
    );
  }
}

///
///
///
/// Toggles the state of [ExpandableController] when the user clicks on it.
class ExpandableButton extends StatelessWidget {
  final Widget child;

  ExpandableButton({required this.child});

  @override
  Widget build(BuildContext context) {
    final ExpandableController? controller = ExpandableController.of(context);
    final ExpandableThemeData theme = ExpandableThemeData.of(context);

    if (theme.useInkWell) {
      return InkWell(
        onTap: controller?.toggle,
        borderRadius: theme.inkWellBorderRadius,
        child: child,
      );
    } else {
      return GestureDetector(
        onTap: controller?.toggle,
        child: child,
      );
    }
  }
}

///
///
///
/// Ensures that the child is visible on the screen by scrolling the outer viewport
/// when the outer [ExpandableNotifier] delivers a change event.
///
/// See also:
///
/// * [RenderObject.showOnScreen]
class ScrollOnExpand extends StatefulWidget {
  final Widget child;

  /// If true then the widget will be scrolled to become visible when expanded
  final bool scrollOnExpand;

  /// If true then the widget will be scrolled to become visible when collapsed
  final bool scrollOnCollapse;

  final ExpandableThemeData theme;

  ///
  ///
  ///
  ScrollOnExpand({
    Key? key,
    required this.child,
    this.scrollOnExpand = true,
    this.scrollOnCollapse = true,
    this.theme = const ExpandableThemeData(),
  }) : super(key: key);

  ///
  ///
  ///
  @override
  _ScrollOnExpandState createState() => _ScrollOnExpandState();
}

///
///
///
class _ScrollOnExpandState extends State<ScrollOnExpand> {
  ExpandableController? _controller;
  int _isAnimating = 0;
  BuildContext? _lastContext;

  // ExpandableThemeData _theme;

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    _controller = ExpandableController.of(context, rebuildOnChange: false);
    _controller?.addListener(_expandedStateChanged);
  }

  ///
  ///
  ///
  @override
  void didUpdateWidget(ScrollOnExpand oldWidget) {
    super.didUpdateWidget(oldWidget);

    final ExpandableController? newController =
        ExpandableController.of(context, rebuildOnChange: false);

    if (newController != _controller) {
      _controller?.removeListener(_expandedStateChanged);
      _controller = newController;
      _controller?.addListener(_expandedStateChanged);
    }
  }

  ///
  ///
  ///
  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_expandedStateChanged);
  }

  ///
  ///
  ///
  void _animationComplete() {
    _isAnimating--;
    if (_isAnimating == 0 && _lastContext != null && mounted) {
      if ((_controller!.expanded && widget.scrollOnExpand) ||
          (!_controller!.expanded && widget.scrollOnCollapse)) {
        _lastContext
            ?.findRenderObject()
            ?.showOnScreen(duration: widget.theme.scrollAnimationDuration);
      }
    }
  }

  ///
  ///
  ///
  void _expandedStateChanged() {
    _isAnimating++;
    Future<void>.delayed(
      widget.theme.scrollAnimationDuration + Duration(milliseconds: 10),
      _animationComplete,
    );
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    _lastContext = context;
    return widget.child;
  }
}
