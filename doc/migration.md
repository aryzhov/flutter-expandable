## Migration Guide

## From version 2.x

The following breaking API changes have been made in version 3.0:

- The parameter `animationDuration` has been moved from `Expandable` to `ExpandableController`.
  This was done in order to simplify combining multiple `Expandable` widgets and 
  to make `animationDuration` available to `ScrollOnExpand`. 

- The parameter `initialExpanded` has been removed from `ExpandablePanel`.
  If you need to make an`ExpandablePanel` expanded initially, wrap it with an `ExpandableNotifier`
  or pass an `ExpandableController`. 


## From version 1.x

When Expandable was initially created, it was using [Scoped Model](https://pub.dartlang.org/packages/scoped_model) plugin
for communicating state changes. In version 2.0.0 the dependency on `ScopedModel` was eliminated.

This is a breaking change, so a code change is necessary to make the code work. 
The migration is mainly a search/replace:

- `ScopedModel<ExpandableModel>` -> `ExpandableNotifier`
- `ExpandableModel` -> `ExpandableController`
- `ScopedModel.of<ExpandableModel>` -> `ExpandableController.of`

