# Swiftly

[![Version](https://img.shields.io/cocoapods/v/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)
[![License](https://img.shields.io/cocoapods/l/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)
[![Platform](https://img.shields.io/cocoapods/p/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)

Swiftly generate autolayout constraints.

## Usage

All views respond to the `applyLayout` method which takes a variadic list of `Swiftly` objects. Convenience initializers are available which pair with all of Apple's `NSLayoutAttribute` types. Common combinatorial layout types `Flush`, `Vertical`, `Horizontal`, `Center`, and `Size` are also available.

```swift
view.applyLayout(.CenterX(), .Vertical(), .Width() * 0.5)
```

## Custom Operators

Operators can be used on `Swiftly` objects to produce modified layouts. The `==`, `<=`, `>=`, `+`, `-`, `*`, and `/` operators are available.

```swift
view.applyLayout(.CenterX(), .Top() + 20, .Width() * 0.5, .Height() == 200)
```

## View Relationships

By default, layout types reference the views `superview`. To create a constraint relative to a sibling view pass that view as a paramter.

```swift
view1.applyLayout(.Left() == .Right(view2) + 5, .Size() == .Size(view2))
```

## Constraint Maniuplation

The `applyLayout` method returns an array of the generated `NSLayoutConstraint` objects, which can be used to later to easily disable or modify the generated constraints.

```swift
let constraints = view.applyLayout(.Size() == 5, .Center())
NSLayoutConstraint.deactivateConstraints(constraints)

...

NSLayoutConstraint.activateConstraints(constraints)

```

__Note:__ Any view which has `applyLayout` called on it will automatically set `translatesAutoresizingMaskIntoConstraints` to `false` and have the generated constraints added to its superview.

## Documentation

Read the documentation [here](http://cocoadocs.org/docsets/Grapher).

## About Swiftly

Swiftly was created by [@Imperiopolis](https://twitter.com/Imperiopolis) and was intended as a lightweight version of [Cartography](https://github.com/robb/cartography) by [Robb Böhnke](https://github.com/robb).

Swiftly is released under the MIT license. See LICENSE for details.
