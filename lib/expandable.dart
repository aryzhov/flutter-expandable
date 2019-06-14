// A library of Flutter widgets that allow creating expandable panels
library expandable;

import 'package:flutter/material.dart';


/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class ExpandableNotifier extends StatefulWidget {

  final ExpandableController controller;
  final bool initialExpanded;
  final Duration animationDuration;
  final Widget child;

  ExpandableNotifier({
    // An optional key
    Key key,

    /// If the controller is not provided, it's created with the initial value of `initialExpanded`.
    this.controller,

    /// Initial expaned state. Must not be used together with [controller].
    this.initialExpanded,

    /// Initial animation duration. Must not be used together with [controller].
    this.animationDuration,

    @required
    /// The child can be any widget which contains [Expandable] widgets in its widget tree.
    this.child}): 
        assert(!(controller != null && animationDuration != null)),
        assert(!(controller != null && initialExpanded != null)),
        super(key: key);

  @override
  _ExpandableNotifierState createState() => _ExpandableNotifierState();
}

class _ExpandableNotifierState extends State<ExpandableNotifier> {

  ExpandableController controller;

  @override
  void initState() {
    super.initState();
    if(widget.controller == null) {
      controller = ExpandableController(initialExpanded: widget.initialExpanded ?? false,
                                           animationDuration: widget.animationDuration);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return _ExpandableInheritedNotifier(controller: controller ?? widget.controller, child: widget.child);
  }
}


/// Makes an [ExpandableController] available to the widget subtree.
/// Useful for making multiple [Expandable] widgets synchronized with a single controller.
class _ExpandableInheritedNotifier extends InheritedNotifier<ExpandableController> {
  _ExpandableInheritedNotifier(
      {
      @required
        /// If the controller is not provided, it's created with the initial state of collapsed.
      ExpandableController controller,
      @required

          /// The child can be any widget which contains [Expandable] widgets in its widget tree.
          Widget child})
      : super(notifier: controller, child: child);
}

/// Controls the state (expanded or collapsed) of one or more [Expandable].
/// The controller should be provided to [Expandable] via [ExpandableNotifier].
class ExpandableController extends ValueNotifier<bool> {
  /// Returns [true] if the state is expanded, [false] if collapsed.
  bool get expanded => value;
  final Duration animationDuration;

  ExpandableController({
    bool initialExpanded, 
    Duration animationDuration}) : 
        this.animationDuration = animationDuration ?? const Duration(milliseconds: 300),
        super(initialExpanded ?? false);

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
        ? context.inheritFromWidgetOfExactType(_ExpandableInheritedNotifier)
        : context.ancestorWidgetOfExactType(_ExpandableInheritedNotifier);
    return (notifier as _ExpandableInheritedNotifier)?.notifier;
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

  final Curve fadeCurve;
  final Curve sizeCurve;

  /// The point in the cross-fade animation timeline (from 0 to 1)
  /// where the [collapsed] and [expanded] widgets are half-visible.
  ///
  /// If set to 0, the [expanded] widget will be shown immediately in full opacity
  /// when the size transition starts. This is useful if the collapsed widget is
  /// empty or if dealing with text that is shown partially in the collapsed state.
  ///
  /// If set to 0.5, the [expanded] and the [collapsed] widget will be shown
  /// at half of their opacity in the middle of the size animation with a
  /// cross-fade effect throughout the entire size transition. This is the default value.
  ///
  /// If set to 1, the [expanded] widget will be shown at the very end of the size animation.
  ///
  /// When collapsing, the effect of this setting is reversed. For example, if the value is 0
  /// then the [expanded] widget will remain to be shown until the end of the size animation.
  final double crossFadePoint;

  /// The alignment of [expanded] and [collapsed] widgets during animation
  final AlignmentGeometry alignment;

  Expandable(
      {Key key,
      this.collapsed,
      this.expanded,
      this.controller,
      this.crossFadePoint = 0.5,
      this.fadeCurve = Curves.linear,
      this.sizeCurve = Curves.fastOutSlowIn,
      this.alignment = Alignment.topLeft})
      :
      super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? ExpandableController.of(context);
    // ignore: deprecated_member_use_from_same_package
    final double collapsedFadeStart = crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);
    // ignore: deprecated_member_use_from_same_package
    final double collapsedFadeEnd = crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;
    // ignore: deprecated_member_use_from_same_package
    final double expandedFadeStart = crossFadePoint < 0.5 ? 0 : (crossFadePoint * 2 - 1);
    // ignore: deprecated_member_use_from_same_package
    final double expandedFadeEnd = crossFadePoint < 0.5 ? 2 * crossFadePoint : 1;

    return AnimatedCrossFade(
      alignment: this.alignment,
      firstChild: collapsed ?? Container(),
      secondChild: expanded ?? Container(),
      firstCurve: Interval(collapsedFadeStart, collapsedFadeEnd, curve: fadeCurve),
      secondCurve: Interval(expandedFadeStart, expandedFadeEnd, curve: fadeCurve),
      sizeCurve: sizeCurve,
      crossFadeState: controller.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: controller.animationDuration,
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

  /// Builds an Expandable object
  final ExpandableBuilder builder;

  /// Expand icon placement
  final ExpandablePanelIconPlacement iconPlacement;

  // Expand icon color
//  final Color iconColor;

  /// Alignment of the header widget relative to the icon
  final ExpandablePanelHeaderAlignment headerAlignment;

  /// An optional controller. If not specified, a default controller will be
  /// obtained from a surrounding [ExpandableNotifier]. If that does not exist,
  /// the controller will be created with the initial state of [initialExpanded].
  final ExpandableController controller;

  static Widget defaultExpandableBuilder(BuildContext context, Widget collapsed, Widget expanded) {
    return Expandable(
      collapsed: collapsed,
      expanded: expanded,
      crossFadePoint: 0,
    );
  }

  ExpandablePanel({
    Key key,
    this.collapsed,
    this.header,
    this.expanded,
    this.tapHeaderToExpand = true,
    this.tapBodyToCollapse = false,
    this.hasIcon = true,
    this.iconPlacement = ExpandablePanelIconPlacement.right,
//    this.iconColor, // The default color is based on the theme
    this.builder = defaultExpandableBuilder,
    this.headerAlignment = ExpandablePanelHeaderAlignment.top,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildHeaderRow(Widget child) {
      if (!hasIcon) {
        return child;
      } else {
        final rowChildren = <Widget>[
          Expanded(
            child: child,
          ),
//          ExpandableIcon(color: iconColor,),
          ExpandableIcon(),
        ];
        return Row(
          crossAxisAlignment: calculateHeaderCrossAxisAlignment(),
          children:
              iconPlacement == ExpandablePanelIconPlacement.right ? rowChildren : rowChildren.reversed.toList(),
        );
      }
    }

    Widget buildHeader(Widget child) {
      return tapHeaderToExpand ? ExpandableButton(child: child) : child;
    }

    Widget buildBody(Widget child) {
      return tapBodyToCollapse ? ExpandableButton(child: child) : child;
    }

    Widget buildWithHeader() {
      return Column(
        children: <Widget>[
          buildHeaderRow(buildHeader(header)),
          builder(context, collapsed, buildBody(expanded))
        ],
      );
    }

    Widget buildWithoutHeader() {
      return buildHeaderRow(builder(context, buildHeader(collapsed), buildBody(expanded)));
    }

    final panel = this.header != null ? buildWithHeader() : buildWithoutHeader();

    if(controller != null) {
      return ExpandableNotifier(
        controller: controller,
        child: panel,
      );
    } else {
      final controller = ExpandableController.of(context, rebuildOnChange: false);
      if(controller == null) {
        return ExpandableNotifier(
          child: panel,
        );
      } else {
        return panel;
      }
    }
  }

  CrossAxisAlignment calculateHeaderCrossAxisAlignment() {
    switch (headerAlignment) {
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
}

/// An down/up arrow icon that toggles the state of [ExpandableController] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableIcon extends StatelessWidget {

  final Color color;

  ExpandableIcon({this.color});

  @override
  Widget build(BuildContext context) {
    final controller = ExpandableController.of(context);
    return ExpandIcon(
//      color: color,
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
    return InkWell(
        onTap: () {
          controller.toggle();
        },
        child: child);
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
  final Duration scrollAnimationDuration;
  /// If true then the widget will be scrolled to become visible when expanded
  final bool scrollOnExpand;
  /// If true then the widget will be scrolled to become visible when collapsed
  final bool scrollOnCollapse;

  ScrollOnExpand({
    Key key,
    @required
    this.child,
    this.scrollAnimationDuration = const Duration(milliseconds: 300),
    this.scrollOnExpand = true,
    this.scrollOnCollapse = true,
  }): super(key: key);

  @override
  _ScrollOnExpandState createState() => _ScrollOnExpandState();

}

class _ScrollOnExpandState extends State<ScrollOnExpand> {

  ExpandableController _controller;
  int _isAnimating = 0;
  BuildContext _lastContext;

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
    if(newController != _controller) {
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
    if(_isAnimating == 0 && _lastContext != null && mounted) {
      if( (_controller.expanded && widget.scrollOnExpand) ||
          (!_controller.expanded && widget.scrollOnCollapse)) {
        _lastContext?.findRenderObject()?.showOnScreen(duration: widget.scrollAnimationDuration);
      }
    }
  }

  _expandedStateChanged() {
    _isAnimating++;
      Future.delayed(_controller.animationDuration + Duration(milliseconds: 10), _animationComplete);
  }

  @override
  Widget build(BuildContext context) {
    _lastContext = context;
    return widget.child;
  }


}
