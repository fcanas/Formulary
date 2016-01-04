# Changelog

## About <v1.0

I'm using this in production. YMMV.

Before a 1.0.0 release, this project follows a modified SemVer:

Reasonable effort is put forth to use Patch version Z (x.y.Z | x > 0) when new, backwards compatible functionality is introduced to the public API. And for Minor version Y (x.Y.z | x > 0) when any backwards incompatible changes are introduced to the public API.

----

## Pending Release

* Add picker form row type
* Form row heights are dynamically determined by autolayout. This makes arbitrary-sized and resizing custom rows easier to implement.
* `tag` parameter is now optional for FormRow
* Fixed a bug so text entry respects autocomplete

----

## 0.3.1
[fcanas](https://github.com/fcanas) released this on Dec 31, 2015

* Added documentation
* Fixed a retain cycle

## 0.3.0
[fcanas](https://github.com/fcanas) released this on Nov 14, 2015

* Updated for Swift 2.0
* Forms can push new view controllers, which can themselves contain forms
* Component registration system
* More public points of control

Between more public APIs and the component registration system, it's much easier to build custom row types. All text entry cells are now written using only public APIs.

## 0.2.0
[fcanas](https://github.com/fcanas) released this on Aug 10, 2015

Portions suitable for use in production apps.