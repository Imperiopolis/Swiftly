# Swiftly

[![Version](https://img.shields.io/cocoapods/v/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)
[![License](https://img.shields.io/cocoapods/l/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)
[![Platform](https://img.shields.io/cocoapods/p/Swiftly.svg?style=flat)](http://cocoadocs.org/docsets/Swiftly)

Swiftly generate Auto Layout constraints.

## Usage

To run the example project, simply run `pod try swiftly`. Alternatively, you can clone the repo and run the project in the example directory.

All `UIView`s and `UILayoutGuide`s respond to the `applyLayout` method which takes a variadic list of `Swiftly` objects. Convenience initializers are available which pair with all of Apple's `NSLayoutAttribute` types. Common combinatorial layout types `flush`, `flushToMargins`, `vertical`, `horizontal`, `center`, and `size` are also available.

```swift
view.applyLayout(.centerX, .vertical, .width * 0.5)
```

## Installation

### Cocoapods

Swiftly is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Swiftly"
```

### Carthage

Swiftly is available through [Carthage](Swiftly/Swiftly.swift). To install
it, simply add the following line to your Cartfile:

```ogdl
github "Imperiopolis/Swiftly" ~> 2.0
```

### Swift Version

Swiftly 2.0 and later require Swift 4.2. For older versions of Swift, please use the Swiftly 1.0 build.

## Custom Operators

Operators can be used on `Swiftly` objects to produce modified layouts. The `==`, `<=`, `>=`, `+`, `-`, `*`, `~=`, and `/` operators are available.

```swift
view.applyLayout(.centerX, .top + 20, .width * 0.5, .height == 200)
```

## Setting Priority

The priority of `Swiftly` objects may be configured.

```swift
view.applyLayout(.centerY ~= UILayoutPriorityRequired)
```

## View Relationships

By default, layout types reference the views `superview`. To create a constraint relative to a sibling view pass that view as a paramter.

```swift
view1.applyLayout(.left == .right(view2) + 5, .size(view2))
```

## Constraint Manipulation

The `applyLayout` method returns an array of the generated `LayoutConstraint` objects, which can be used to later to easily disable or modify the generated constraints.

```swift
let constraints = view.applyLayout(.size == 5, .center)
NSLayoutConstraint.deactivate(constraints)

...

NSLayoutConstraint.activate(constraints)

```

__Note:__ Any view which has `applyLayout` called on it will automatically set `translatesAutoresizingMaskIntoConstraints` to `false` and have the generated constraints added to its superview.

## Documentation

Read the documentation [here](http://cocoadocs.org/docsets/Swiftly).

## About Swiftly

Swiftly was created by [@Imperiopolis](https://twitter.com/Imperiopolis) and was intended as a lightweight version of [Cartography](https://github.com/robb/cartography) by [Robb Böhnke](https://github.com/robb).

Swiftly is released under the MIT license. See LICENSE for details.
