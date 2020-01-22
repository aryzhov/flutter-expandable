## Migration Guide

## From version 3.x

The following parameters have been deprecated. They have been moved to `ExpandableThemeData`:
- `ExpandableController.animationDuration`
- `Expandable.crossFadePoint`,
- `Expandable.fadeCurve`,
- `Expandable.sizeCurve`,
- `Expandable.alignment`,
- `Expandable.alignment`,
- `ExpandablePanel.hasIcon`,
- `ExpandablePanel.iconPlacement`,
- `ExpandablePanel.iconColor`,
- `ExpandablePanel.headerAlignment`,
- `ExpandablePanel.tapHeaderToExpand`,
- `ExpandablePanel.tapBodyToCollapse`,
- `ExpandableIcon.color`,
- `ScrollOnExpand.scrollAnimationDuration`,


## From version 2.x

The following breaking API changes have been made in version 3.0:

- The parameter `animationDuration` has been moved from `Expandable` to `ExpandableController`.
  This was done in order to simplify combining multiple `Expandable` widgets and 
  to make `animationDuration` available to `ScrollOnExpand`. 

- The parameter `initialExpanded` has been removed from `ExpandablePanel`.
  If you need to make an`ExpandablePanel` expanded initially, wrap it with an `ExpandableNotifier`
  or pass an `ExpandableController`. 

- The constructor of `ExpandableController` accepts named parameters. Provide
  the initial value by calling `ExpandableController(initialExpanded: myValue)`.

## From version 1.x

When Expandable was initially created, it was using [Scoped Model](https://pub.dartlang.org/packages/scoped_model) plugin
for communicating state changes. In version 2.0.0 the dependency on `ScopedModel` was eliminated.

This is a breaking change, so a code change is necessary to make the code work. 
The migration is mainly a search/replace:

- `ScopedModel<ExpandableModel>` -> `ExpandableNotifier`
- `ExpandableModel` -> `ExpandableController`
- `ScopedModel.of<ExpandableModel>` -> `ExpandableController.of`

