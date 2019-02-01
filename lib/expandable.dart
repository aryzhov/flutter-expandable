// A library of Flutter widgets that allow creating expandable panels
library expandable;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// Contains the state (expanded or collapsed) of ExpandableBody.
/// This model should be exposed via [ScopedModel] to
/// [Expandable] and [ExpandedPanel].
class ExpandableModel extends Model {
  bool _expanded;

  /// Returns [true] if the state is expanded, [false] if collapsed.
  bool get expanded => _expanded;

  ExpandableModel([this._expanded = false]);

  /// Sets the expanded state. Notifies the listeners if the state has changed.
  set expanded(bool exp) {
    if (this._expanded != exp) {
      this._expanded = exp;
      notifyListeners();
    }
  }
}

/// Shows either the expanded or the collapsed child depending on the state.
/// The state is determined by an instance of [ExpandableModel] provided by [ScopedModel]
class Expandable extends StatelessWidget {
  // Whe widget to show when collapsed
  final Widget collapsed;
  // The widget to show when expanded
  final Widget expanded;
  final Duration animationDuration;
  final double collapsedFadeStart;
  final double collapsedFadeEnd;
  final double expandedFadeStart;
  final double expandedFadeEnd;
  final Curve fadeCurve;
  final Curve sizeCurve;

  Expandable(
      {@required this.collapsed,
      @required this.expanded,
      this.collapsedFadeStart = 0,
      this.collapsedFadeEnd = 1,
      this.expandedFadeStart = 0,
      this.expandedFadeEnd = 1,
      this.fadeCurve = Curves.linear,
      this.sizeCurve = Curves.fastOutSlowIn,
      this.animationDuration = const Duration(milliseconds: 300)});

  @override
  Widget build(BuildContext context) {
    var model = ScopedModel.of<ExpandableModel>(context, rebuildOnChange: true);

    return AnimatedCrossFade(
      firstChild: collapsed ?? Container(),
      secondChild: expanded ?? Container(),
      firstCurve: Interval(collapsedFadeStart, collapsedFadeEnd, curve: fadeCurve),
      secondCurve: Interval(expandedFadeStart, expandedFadeEnd, curve: fadeCurve),
      sizeCurve: sizeCurve,
      crossFadeState: model.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: animationDuration,
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

/// A configurable widget for showing user-expandable content with an optional expand button.
class ExpandablePanel extends StatelessWidget {

  /// If specified, the header is always shown, and the expandable part is shown under the header
  final Widget header;
  /// The widget shown in the collspaed state
  final Widget collapsed;
  /// The widget shown in the expanded state
  final Widget expanded;
  /// If true then the panel is expanded initially
  final bool initialExpanded;
  /// If true, the header can be clicked by the user to expand
  final bool tapHeaderToExpand;
  /// If true, an expand icon is shown on the right
  final bool hasIcon;
  /// Builds an Expandable object
  final ExpandableBuilder builder;
  /// Expand/collspse icon placement
  final ExpandablePanelIconPlacement iconPlacement;

  static Widget defaultExpandableBuilder(BuildContext context, Widget collapsed, Widget expanded) {
    return Expandable(
      collapsed: collapsed,
      expanded: expanded,
    );
  }

  ExpandablePanel({
    this.collapsed,
    this.header,
    this.expanded,
    this.initialExpanded = false,
    this.tapHeaderToExpand = true,
    this.hasIcon = true,
    this.iconPlacement = ExpandablePanelIconPlacement.right,
    this.builder = defaultExpandableBuilder});

  @override
  Widget build(BuildContext context) {


    Widget buildHeaderRow(Widget child) {
      if(!hasIcon) {
        return child;
      } else {
        final rowChildren = <Widget>[
          Expanded(
            child: child,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ExpandableIcon(),
          ),
        ];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: iconPlacement == ExpandablePanelIconPlacement.right ?
                    rowChildren: rowChildren.reversed.toList(),
        );
      }
    }

    Widget buildHeader(Widget child) {
      return tapHeaderToExpand ?
        ExpandableButton(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 45.0),
            child: child
          )
        ): child;
    }

    Widget buildWithHeader() {
      return Column(
        children: <Widget>[
          buildHeaderRow(buildHeader(header)),
          builder(context, collapsed, expanded)
        ],
      );
    }

    Widget buildWithoutHeader() {
      return buildHeaderRow(builder(context, buildHeader(collapsed), expanded));
    }

    return ScopedModel<ExpandableModel>(
      model: ExpandableModel(initialExpanded),
      child: this.header != null ? buildWithHeader(): buildWithoutHeader(),
    );
  }

}

/// An down/up arrow icon that toggles the state of [ExpandableModel] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableIcon extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ExpandableModel>(context, rebuildOnChange: true);
    return ExpandIcon(
      isExpanded: model.expanded,
      onPressed: (exp) {
        model.expanded = !model.expanded;
      },
    );
  }
}

/// Toggles the state of [ExpandableModel] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableButton extends StatelessWidget {
  final Widget child;

  ExpandableButton({this.child});

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ExpandableModel>(context, rebuildOnChange: true);
    return InkWell(
      onTap: () {
        model.expanded = !model.expanded;
      },
      child: child
    );
  }
}

