# [5.0.1]

* Added `theme` property to `ExpandableButton`.

# [5.0.0]

* Migrated to null safety. Dart SDK >= `2.12.0` is now required.
* Removed previously deprecated attributes.

# [4.1.4]

* Added `inkWellRadius` theme property.

# [4.1.3]

* Fixed a bug: Expandables should be unregistered in controller upon their disposal.

## [4.1.2]

* Optimized comparison operator in `ExpandableThemeData`.
* Improved example app.

## [4.1.1]

* Added `iconRotationAngle` theme property.

## [4.1.0]

* Added ability to customize the expand icon in the theme.
* Converted widget properties `tapHeaderToExpand`, `tapBodyToExpand`, `hasIcon` to theme properties.
* Added `tabBodyToExpand` theme property.
* Added theme property `bodyAlignment` to specify body alignment.
* Added a third card to the example app that demonstrates a custom icon.

## [4.0.2]

* Changed the horizontal alignment of the header and the body of `ExpandablePanel` to stretch.
* Fixed an exception when no controller is specified in `ExpandableNotifier`.

## [4.0.1]

* Updated `pubspec.yaml` to require the minimum version of Flutter  1.12.0.

## [4.0.0]

* Introduced `ExpandableTheme` and `ExpandableThemeData`. 
* Deprecated widget-level properties that have been moved to the theme.

## [3.0.1]

* Added `iconColor` property to `ExpandablePanel`

## [3.0.0+1] - 06/14/2019

* Updated README and example app.

## [3.0.0] - 06/13/2019

* Added `ShowOnExpand` widget.
* Moved `initialExpanded` from `ExpandablePanel` to `ExpandableNotifier`.
* Moved `animationDuration` from `Expandable` to `ExpandableController`.
* Made `ExpandableNotifier` to be a stateful widget.
* Made `ExpandablePanel` a stateless widget.

## [2.2.3] - 06/13/2019

* Added the optional `crossFadePoint` parameter.

## [2.2.2] - 06/09/2019

* Disabled the `iconColor` parameter until version 1.7.3 is published to stable.

## [2.2.1] - 06/09/2019

* Added the optional `iconColor` parameter to `ExpandablePanel`.

## [2.2.0] - 06/06/2019

* Added the optional `headerAlignment` parameter to `ExpandablePanel`.

## [2.1.1] - 04/17/2019

* Added the optional `key` parameter to `Expandable` and `ExpandablePanel`.

## [2.1.0] - 04/5/2019

* ExpandablePanel does not lose its state if its parent is rebuilt.
* Example file is moved to `example` folder for ease of running it.

## [2.0.0] - 02/14/2019

* Eliminated the dependency on ScopedModel.
* Introduced ExpandableNotifier and ExpandableController.
* This is a breaking change. See README.md for details on migration from 1.x to 2.0.

## [1.1.0] - 02/01/2019

* Added `ExpandablePanel`, a configurable expandable widget with optional header and icon. 

## [1.0.0] - 01/29/2019

* Initial release.
