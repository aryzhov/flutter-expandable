// A library of Flutter widgets that allow creating expandable panels
library expandable;

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

/// Contains the state (expanded or collapsed) of ExpandableBody.
/// This model should be exposed via [ScopedModel] to
/// [Expandable] and [ExpandedHeader].
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

/// Toggles the state of [ExpandableModel] when the user clicks on it.
/// The model is accessed via [ScopedModelDescendant].
class ExpandableHeader extends StatelessWidget {
  final Widget child;

  ExpandableHeader({this.child});

  @override
  Widget build(BuildContext context) {
    var model = ScopedModel.of<ExpandableModel>(context, rebuildOnChange: true);
    return InkWell(
      onTap: () {
        model.expanded = !model.expanded;
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: child,
          ),
          ExpandIcon(
            isExpanded: model.expanded,
            onPressed: (exp) {
              model.expanded = !model.expanded;
            },
          ),
        ],
      ),
    );
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
      firstChild: collapsed,
      secondChild: expanded,
      firstCurve: Interval(collapsedFadeStart, collapsedFadeEnd, curve: fadeCurve),
      secondCurve: Interval(expandedFadeStart, expandedFadeEnd, curve: fadeCurve),
      sizeCurve: sizeCurve,
      crossFadeState: model.expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: animationDuration,
    );
  }
}
