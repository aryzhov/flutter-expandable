// A library of Flutter widgets that allow creating expandable panels
library expandable;

import 'package:flutter/material.dart';

class ExpandableThemeData {
  static final ExpandableThemeData defaults = ExpandableThemeData(
    iconColor: Colors.black54,
    useInkWell: true,
    animationDuration: const Duration(milliseconds: 300),
    scrollAnimationDuration: const Duration(milliseconds: 300),
    crossFadePoint: 0.5,
    fadeCurve: Curves.linear,
    sizeCurve: Curves.fastOutSlowIn,
    alignment: Alignment.topLeft,
    headerAlignment: ExpandablePanelHeaderAlignment.top,
    iconPlacement: ExpandablePanelIconPlacement.right,
  );

  static final ExpandableThemeData empty = ExpandableThemeData();

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

  /// Expand icon placement
  final ExpandablePanelIconPlacement iconPlacement;

  const ExpandableThemeData({
    this.iconColor,
    this.useInkWell,
    this.animationDuration,
    this.scrollAnimationDuration,
    this.crossFadePoint,
    this.fadeCurve,
    this.sizeCurve,
    this.alignment,
    this.headerAlignment,
    this.iconPlacement,
  });

  static ExpandableThemeData combine(ExpandableThemeData theme, ExpandableThemeData defaults) {
    if (defaults == null || defaults.isEmpty()) {
      return theme ?? empty;
    } else if (theme == null || theme.isEmpty()) {
      return defaults ?? empty;
    } else if (theme.isFull()) {
      return theme;
    } else {
      return ExpandableThemeData(
        iconColor: theme.iconColor ?? defaults.iconColor,
        useInkWell: theme.useInkWell ?? defaults.useInkWell,
        animationDuration: theme.animationDuration ?? defaults.animationDuration,
        scrollAnimationDuration: theme.scrollAnimationDuration ?? defaults.scrollAnimationDuration,
        crossFadePoint: theme.crossFadePoint ?? defaults.crossFadePoint,
        fadeCurve: theme.fadeCurve ?? defaults.fadeCurve,
        sizeCurve: theme.sizeCurve ?? defaults.sizeCurve,
        alignment: theme.alignment ?? defaults.alignment,
        headerAlignment: theme.headerAlignment ?? defaults.headerAlignment,
        iconPlacement: theme.iconPlacement ?? defaults.iconPlacement,
      );
    }
  }

  // ignore: deprecated_member_use_from_same_package
  double get collapsedFadeStart => crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);

  // ignore: deprecated_member_use_from_same_package
  double get collapsedFadeEnd => crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;

  // ignore: deprecated_member_use_from_same_package
  double get expandedFadeStart => crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);

  // ignore: deprecated_member_use_from_same_package
  double get expandedFadeEnd => crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;

  ExpandableThemeData nullIfEmpty() {
    return isEmpty() ? null : this;
  }

  bool isEmpty() {
    return this.iconColor == null &&
        this.useInkWell == null &&
        this.animationDuration == null &&
        this.scrollAnimationDuration == null &&
        this.crossFadePoint == null &&
        this.fadeCurve == null &&
        this.sizeCurve == null &&
        this.alignment == null &&
        this.headerAlignment == null &&
        this.iconPlacement == null;
  }

  bool isFull() {
    return this.iconColor != null &&
        this.useInkWell != null &&
        this.animationDuration != null &&
        this.scrollAnimationDuration != null &&
        this.crossFadePoint != null &&
        this.fadeCurve != null &&
        this.sizeCurve != null &&
        this.alignment != null &&
        this.headerAlignment != null &&
        this.iconPlacement != null;
  }

  static ExpandableThemeData of(BuildContext context, {bool rebuildOnChange = true}) {
    final notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_ExpandableThemeNotifier>()
        : context.findAncestorWidgetOfExactType<_ExpandableThemeNotifier>();
    return notifier?.themeData ?? defaults;
  }

  static ExpandableThemeData withDefaults(ExpandableThemeData theme, BuildContext context, {bool rebuildOnChange = true}) {
    if (theme != null && theme.isFull()) {
      return theme;
    } else {
      return combine(combine(theme, of(context, rebuildOnChange: rebuildOnChange)), defaults);
    }
  }
}

class ExpandableTheme extends StatelessWidget {
  final ExpandableThemeData data;
  final Widget child;

  ExpandableTheme({@required this.data, @required this.child});

  @override
  Widget build(BuildContext context) {
    _ExpandableThemeNotifier n = context.dependOnInheritedWidgetOfExactType<_ExpandableThemeNotifier>();
    return _ExpandableThemeNotifier(
      themeData: ExpandableThemeData.combine(data, n?.themeData),
      child: this.child,
    );
  }
}

/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class ExpandableNotifier extends StatefulWidget {
  final ExpandableController controller;
  final bool initialExpanded;
  final Widget child;

  ExpandableNotifier(
      {
      // An optional key
      Key key,

      /// If the controller is not provided, it's created with the initial value of `initialExpanded`.
      this.controller,

      /// Initial expanded state. Must not be used together with [controller].
      this.initialExpanded,
      @required

          /// The child can be any widget which contains [Expandable] widgets in its widget tree.
          this.child})
      : assert(!(controller != null && initialExpanded != null)),
        super(key: key);

  @override
  _ExpandableNotifierState createState() => _ExpandableNotifierState();
}

class _ExpandableNotifierState extends State<ExpandableNotifier> {
  ExpandableController controller;
  ExpandableThemeData theme;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ExpandableController(initialExpanded: widget.initialExpanded ?? false);
  }

  @override
  void didUpdateWidget(ExpandableNotifier oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller && widget.controller != null) {
      setState(() {
        controller = widget.controller;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cn = _ExpandableControllerNotifier(controller: controller, child: widget.child);
    return theme != null ? _ExpandableThemeNotifier(themeData: theme, child: cn) : cn;
  }
}

/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _ExpandableControllerNotifier extends InheritedNotifier<ExpandableController> {
  _ExpandableControllerNotifier({@required ExpandableController controller, @required Widget child}) : super(notifier: controller, child: child);
}

/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _ExpandableThemeNotifier extends InheritedWidget {
  final ExpandableThemeData themeData;

  _ExpandableThemeNotifier({@required this.themeData, @required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return !(oldWidget is _ExpandableThemeNotifier && oldWidget.themeData == themeData);
  }
}

/// Controls the state (expanded or collapsed) of one or more [Expandable].
/// The controller should be provided to [Expandable] via [ExpandableNotifier].
class ExpandableController extends ValueNotifier<bool> {
  /// Returns [true] if the state is expanded, [false] if collapsed.
  bool get expanded => value;

  final Duration _animationDuration;

  ExpandableController(
      {bool initialExpanded,
      @deprecated
          // ignore: deprecated_member_use_from_same_package
          animationDuration})
      : this._animationDuration = animationDuration,
        super(initialExpanded ?? false);

  @deprecated
  get animationDuration => this._animationDuration;

  /// Sets the expanded state.
  set expanded(bool exp) {
    value = exp;
  }

  /// Sets the expanded state to the opposite of the current state.
  void toggle() {
    expanded = !expanded;
  }

  static ExpandableController of(BuildContext context, {bool rebuildOnChange = true}) {
    final notifier = rebuildOnChange
        ? context.dependOnInheritedWidgetOfExactType<_ExpandableControllerNotifier>()
        : context.findAncestorWidgetOfExactType<_ExpandableControllerNotifier>();
    return notifier?.notifier;
  }
}

/// Shows either the expanded or the collapsed child depending on the state.
/// The state is determined by an instance of [ExpandableController] provided by [ScopedModel]
class Expandable extends StatelessWidget {
  /// Whe widget to show when collapsed
  final Widget collapsed;

  /// The widget to show when expanded
  final Widget expanded;

  /// If the controller is not specified, it will be retrieved from the context
  final ExpandableController controller;

  final ExpandableThemeData _theme;

  Expandable({
    Key key,
    this.collapsed,
    this.expanded,
    this.controller,
    ExpandableThemeData theme,
    @deprecated double crossFadePoint,
    @deprecated Curve fadeCurve,
    @deprecated Curve sizeCurve,
    @deprecated AlignmentGeometry alignment,
    // ignore: deprecated_member_use_from_same_package
  })  : _theme = ExpandableThemeData.combine(
                ExpandableThemeData(crossFadePoint: crossFadePoint, fadeCurve: fadeCurve, sizeCurve: sizeCurve, alignment: alignment), theme)
            .nullIfEmpty(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? ExpandableController.of(context);
    final theme = ExpandableThemeData.withDefaults(_theme, context);

    return AnimatedCrossFade(
      alignment: theme.alignment,
      firstChild: collapsed ?? Container(),
      secondChild: expanded ?? Container(),
      firstCurve: Interval(theme.collapsedFadeStart, theme.collapsedFadeEnd, curve: theme.fadeCurve),
      secondCurve: Interval(theme.expandedFadeStart, theme.expandedFadeEnd, curve: theme.fadeCurve),
      sizeCurve: theme.sizeCurve,
      crossFadeState: controller.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: controller._animationDuration ?? theme.animationDuration,
    );
  }
}

typedef Widget ExpandableBuilder(BuildContext context, Widget collapsed, Widget expanded);

/// Determines the placement of the expand/collapse icon in [ExpandablePanel]
enum ExpandablePanelIconPlacement {
  /// The icon is on the left of the header
  left,

  /// The icon is on the right of the header
  right,
}

/// Determines the alignment of the header relative to the expand icon
enum ExpandablePanelHeaderAlignment {
  /// The header and the icon are aligned at their top positions
  top,

  /// The header and the icon are aligned at their center positions
  center,

  /// The header and the icon are aligned at their bottom positions
  bottom,
}

/// A configurable widget for showing user-expandable content with an optional expand button.
class ExpandablePanel extends StatelessWidget {
  /// If specified, the header is always shown, and the expandable part is shown under the header
  final Widget header;

  /// The widget shown in the collapsed state
  final Widget collapsed;

  /// The widget shown in the expanded state
  final Widget expanded;

  /// If true, the header can be clicked by the user to expand
  final bool tapHeaderToExpand;

  /// If true, the body can be clicked by the user to collapse
  final bool tapBodyToCollapse;

  /// If true, Expand icon is shown on the right
  final bool hasIcon;

  /// Builds an Expandable object, optional
  final ExpandableBuilder builder;

  /// An optional controller. If not specified, a default controller will be
  /// obtained from a surrounding [ExpandableNotifier]. If that does not exist,
  /// the controller will be created with the initial state of [initialExpanded].
  final ExpandableController controller;

  final ExpandableThemeData _theme;

  ExpandablePanel({
    Key key,
    this.collapsed,
    this.header,
    this.expanded,
    this.controller,
    this.tapHeaderToExpand = true,
    this.tapBodyToCollapse = false,
    this.hasIcon = true,
    this.builder,
    // Theme overrides (optional)
    ExpandableThemeData theme,
    @deprecated ExpandablePanelIconPlacement iconPlacement,
    @deprecated Color iconColor,
    @deprecated ExpandablePanelHeaderAlignment headerAlignment,

    // ignore: deprecated_member_use_from_same_package
  })  : _theme = ExpandableThemeData.combine(
                ExpandableThemeData(iconPlacement: iconPlacement, iconColor: iconColor, headerAlignment: headerAlignment), theme)
            .nullIfEmpty(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ExpandableThemeData.withDefaults(_theme, context);

    CrossAxisAlignment calculateHeaderCrossAxisAlignment() {
      switch (theme.headerAlignment) {
        case ExpandablePanelHeaderAlignment.top:
          return CrossAxisAlignment.start;
        case ExpandablePanelHeaderAlignment.center:
          return CrossAxisAlignment.center;
        case ExpandablePanelHeaderAlignment.bottom:
          return CrossAxisAlignment.end;
      }
      assert(false);
      return null;
    }

    Widget buildHeaderRow(Widget child) {
      if (!hasIcon) {
        return child;
      } else {
        final rowChildren = <Widget>[
          Expanded(
            child: child,
          ),
          // ignore: deprecated_member_use_from_same_package
          ExpandableIcon(
            color: theme.iconColor,
          ),
        ];
        return Row(
          crossAxisAlignment: calculateHeaderCrossAxisAlignment(),
          children: theme.iconPlacement == ExpandablePanelIconPlacement.right ? rowChildren : rowChildren.reversed.toList(),
        );
      }
    }

    Widget buildHeader(Widget child) {
      return tapHeaderToExpand ? ExpandableButton(child: child) : child;
    }

    Widget buildBody(Widget child) {
      return tapBodyToCollapse ? ExpandableButton(child: child) : child;
    }

    Widget buildExpandable() {
      if (builder != null) {
        return builder(context, collapsed, buildBody(expanded));
      } else {
        return Expandable(
          collapsed: collapsed,
          expanded: buildBody(expanded),
          theme: theme,
        );
      }
    }

    Widget buildWithHeader() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeaderRow(buildHeader(header)),
          buildExpandable(),
        ],
      );
    }

    Widget buildWithoutHeader() {
      return buildHeaderRow(buildExpandable());
    }

    final panel = this.header != null ? buildWithHeader() : buildWithoutHeader();

    if (controller != null) {
      return ExpandableNotifier(
        controller: controller,
        child: panel,
      );
    } else {
      final controller = ExpandableController.of(context, rebuildOnChange: false);
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

/// An down/up arrow icon that toggles the state of [ExpandableController] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableIcon extends StatelessWidget {
  final ExpandableThemeData _theme;

  ExpandableIcon({
    @deprecated Color color,
    ExpandableThemeData theme,
    // ignore: deprecated_member_use_from_same_package
  }) : _theme = ExpandableThemeData.combine(color != null ? ExpandableThemeData(iconColor: color) : null, theme).nullIfEmpty();

  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    final theme = ExpandableThemeData.withDefaults(_theme, context);
    return ExpandIcon(
      color: theme.iconColor,
      isExpanded: controller.expanded,
      onPressed: (exp) {
        controller.toggle();
      },
    );
  }
}

/// Toggles the state of [ExpandableController] when the user clicks on it.
class ExpandableButton extends StatelessWidget {
  final Widget child;

  ExpandableButton({this.child});

  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    final theme = ExpandableThemeData.withDefaults(null, context);

    if (theme.useInkWell) {
      return InkWell(onTap: controller.toggle, child: child);
    } else {
      return GestureDetector(
        onTap: controller.toggle,
        child: child,
      );
    }
  }
}

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

  final ExpandableThemeData _theme;

  ScrollOnExpand({
    Key key,
    @required this.child,
    this.scrollOnExpand = true,
    this.scrollOnCollapse = true,
    ExpandableThemeData theme,
    @deprecated Duration scrollAnimationDuration,
    // ignore: deprecated_member_use_from_same_package
  })  : _theme = scrollAnimationDuration != null ? ExpandableThemeData(scrollAnimationDuration: scrollAnimationDuration) : null,
        super(key: key);

  @override
  _ScrollOnExpandState createState() => _ScrollOnExpandState();
}

class _ScrollOnExpandState extends State<ScrollOnExpand> {
  ExpandableController _controller;
  int _isAnimating = 0;
  BuildContext _lastContext;
  ExpandableThemeData _theme;

  @override
  void initState() {
    super.initState();
    _controller = ExpandableController.of(context, rebuildOnChange: false);
    _controller.addListener(_expandedStateChanged);
  }

  @override
  void didUpdateWidget(ScrollOnExpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = ExpandableController.of(context, rebuildOnChange: false);
    if (newController != _controller) {
      _controller.removeListener(_expandedStateChanged);
      _controller = newController;
      _controller.addListener(_expandedStateChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_expandedStateChanged);
  }

  _animationComplete() {
    _isAnimating--;
    if (_isAnimating == 0 && _lastContext != null && mounted) {
      if ((_controller.expanded && widget.scrollOnExpand) || (!_controller.expanded && widget.scrollOnCollapse)) {
        _lastContext?.findRenderObject()?.showOnScreen(duration: _theme.scrollAnimationDuration);
      }
    }
  }

  _expandedStateChanged() {
    if (_theme != null) {
      _isAnimating++;
      Future.delayed(_theme.scrollAnimationDuration + Duration(milliseconds: 10), _animationComplete);
    }
  }

  @override
  Widget build(BuildContext context) {
    _lastContext = context;
    _theme = ExpandableThemeData.withDefaults(widget._theme, context);
    return widget.child;
  }
}
