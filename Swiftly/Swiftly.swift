//
//  Swiftly.swift
//  Swiftly
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit

public protocol Swiftlyable {

    var superview: UIView? { get }

}

extension UIView: Swiftlyable {}

@available(iOS, introduced: 9.0)
extension UILayoutGuide: Swiftlyable {

    public var superview: UIView? {
        return owningView
    }

}

public extension Swiftlyable {

    /**
     Create constraints from an array of Swiftly objects.

     - parameter layoutArray: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    internal func createLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("You must assign a superview before applying a layout")
        }

        if let view = self as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let constraints = layoutArray.flatMap { l -> [NSLayoutConstraint] in
            let attributes: [NSLayoutConstraint.Attribute]
            if let attrs = l.attributes {
                attributes = attrs
            } else if let attr = l.attribute {
                attributes = [attr]
            } else {
                fatalError("You must define an attribute.")
            }

            let otherAttributes: [NSLayoutConstraint.Attribute]
            if let otherAttrs = l.otherAttributes {
                otherAttributes = otherAttrs
            } else if let otherAttr = l.otherAttribute {
                otherAttributes = [otherAttr]
            } else if let attr = l.attribute {
                otherAttributes = [attr]
            } else if let attrs = l.attributes {
                otherAttributes = attrs
            } else {
                otherAttributes = []
            }

            return zip(attributes, otherAttributes).map { attr, otherAttr in
                // toItem should be nil when setting a fixed size
                let toItem = otherAttr == .notAnAttribute ? nil : (l.toItem ?? superview)

                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: attr,
                    relatedBy: l.relatedBy ?? .equal,
                    toItem: toItem,
                    attribute: otherAttr,
                    multiplier: l.multiplier,
                    constant: l.constant)

                if let priority = l.priority {
                    constraint.priority = priority
                }

                return constraint
            }
        }
        
        return constraints
    }

    /**
     Apply a variadic list of Swiftly objects to a `Swiftlyable`. This is appended to any existing constraints.

     - parameter layout: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    @discardableResult
    func applyLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        let constraints = createLayout(layoutArray: layout)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /**
     Apply a variadic list of Swiftly objects to a `Swiftlyable`. The constraints are not immediately applied.

     - parameter layout: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    func createLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        return createLayout(layoutArray: layout)
    }

}

public extension Array where Element : Swiftlyable {

    /**
    Apply an array of Swiftly objects to an array of `Swiftlyable`s. This is appended to any existing constraints.

    - parameter layoutArray: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    internal func createLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        return flatMap { return $0.createLayout(layoutArray: layoutArray) }
    }

    /**
    Apply a variadic list of Swiftly objects to an array of views. This is appended to any existing constraints.

    - parameter layout: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    @discardableResult
    func applyLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        let constraints = createLayout(layoutArray: layout)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /**
     Apply a variadic list of Swiftly objects to an array of views. The constraints are not immediately applied.

     - parameter layout: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    func createLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        return createLayout(layoutArray: layout)
    }

}

public extension Array where Element : UIView {

    /**
     Apply an array of Swiftly objects to an array of views. The constraints are not applied to the first view in the array (since it has no previous item). This is appended to any existing constraints.

     - parameter callback: A closure used to define the constraints. A previousView argument is passed to allow for distributing views.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    @discardableResult
    func applyLayoutWithPreviousView(_ callback: (_ previousView: UIView) -> [Swiftly]) -> [NSLayoutConstraint] {
        let constraints = createLayoutWithPreviousView(callback)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /**
     Apply an array of Swiftly objects to an array of views. The constraints are not applied to the first view in the array (since it has no previous item). The constraints are not applied immediately.

     - parameter callback: A closure used to define the constraints. A previousView argument is passed to allow for distributing views.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    func createLayoutWithPreviousView(_ callback: (_ previousView: UIView) -> [Swiftly]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var previousView: UIView?
        for view in self {
            if let previousView = previousView {
                let swiftly = callback(previousView)
                constraints += (view as Swiftlyable).createLayout(layoutArray: swiftly)
            }

            previousView = view
        }

        return constraints
    }

}

/**
*  A struct representing a set of constraint attributes. Initializers are available to create all common constraint types.
*/
public struct Swiftly {
    /**
    A combined layout representing all sides of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func flush(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right], toItem: item)
    }

    /// A combined layout representing all sides of a `Swiftlyable`'s alignment rectangle.
    public static var flush: Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right])
    }

    /**
     A combined layout representing all sides of a `Swiftlyable`'s margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func flushToMargins(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right], toItem: item, otherAttributes: [.topMargin, .leftMargin, .bottomMargin, .rightMargin])
    }

    /// A combined layout representing all sides of a `Swiftlyable`'s margin alignment rectangle.
    public static var flushToMargins: Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right], otherAttributes: [.topMargin, .leftMargin, .bottomMargin, .rightMargin])
    }

    /**
    A combined layout representing the left and right sides of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func horizontal(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.left, .right], toItem: item)
    }

    /// A combined layout representing the left and right sides of a `Swiftlyable`'s alignment rectangle.
    public static var horizontal: Swiftly {
        return Swiftly(attributes: [.left, .right])
    }

    /**
     A combined layout representing the left and right sides of a `Swiftlyable`'s margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func horizontalMargins(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.left, .right], toItem: item, otherAttributes: [.leftMargin, .rightMargin])
    }

    /// A combined layout representing the left and right sides of a `Swiftlyable`'s margin alignment rectangle.
    public static var horizontalMargins: Swiftly {
        return Swiftly(attributes: [.left, .right], otherAttributes: [.leftMargin, .rightMargin])
    }

    /**
    A combined layout representing the top and bottom sides of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func vertical(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.top, .bottom], toItem: item)
    }

    /// A combined layout representing the top and bottom sides of a `Swiftlyable`'s alignment rectangle.
    public static var vertical: Swiftly {
        return Swiftly(attributes: [.top, .bottom])
    }

    /**
     A combined layout representing the top and bottom sides of a `Swiftlyable`'s margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func verticalMargins(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.top, .bottom], toItem: item, otherAttributes: [.topMargin, .bottomMargin])
    }

    /// A combined layout representing the top and bottom sides of a `Swiftlyable`'s margin alignment rectangle.
    public static var verticalMargins: Swiftly {
        return Swiftly(attributes: [.top, .bottom], otherAttributes: [.topMargin, .bottomMargin])
    }

    /**
    A combined layout representing the center along the x-axis and y-axis of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func center(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.centerX, .centerY], toItem: item)
    }

    /// A combined layout representing the center along the x-axis and y-axis of a `Swiftlyable`'s alignment rectangle.
    public static var center: Swiftly {
        return Swiftly(attributes: [.centerX, .centerY])
    }

    /**
    A combined layout representing the height and width of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func size(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(attributes: [.height, .width], toItem: item)
    }

    /// A combined layout representing the height and width of a `Swiftlyable`'s alignment rectangle.
    public static var size: Swiftly {
        return Swiftly(attributes: [.height, .width])
    }

    /**
    A layout representing the left side of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func left(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.left, toItem: item)
    }

    /// A layout representing the left side of a `Swiftlyable`'s alignment rectangle.
    public static var left: Swiftly {
        return Swiftly(.left)
    }

    /**
    A layout representing the right side of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func right(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.right, toItem: item)
    }

    /// A layout representing the right side of a `Swiftlyable`'s alignment rectangle.
    public static var right: Swiftly {
        return Swiftly(.right)
    }

    /**
    A layout representing the top side of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func top(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.top, toItem: item)
    }

    /// A layout representing the top side of a `Swiftlyable`'s alignment rectangle.
    public static var top: Swiftly {
        return Swiftly(.top)
    }

    /**
    A layout representing the bottom side of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func bottom(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.bottom, toItem: item)
    }

    /// A layout representing the bottom side of a `Swiftlyable`'s alignment rectangle.
    public static var bottom: Swiftly {
        return Swiftly(.bottom)
    }

    /**
    A layout representing the leading edge of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func leading(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.leading, toItem: item)
    }

    /// A layout representing the leading edge of a `Swiftlyable`'s alignment rectangle.
    public static var leading: Swiftly {
        return Swiftly(.leading)
    }

    /**
    A layout representing the trailing edge of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func trailing(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.trailing, toItem: item)
    }

    /// A layout representing the trailing edge of a `Swiftlyable`'s alignment rectangle.
    public static var trailing: Swiftly {
        return Swiftly(.trailing)
    }

    /**
    A layout representing the height of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func height(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.height, toItem: item)
    }

    /// A layout representing the height of a `Swiftlyable`'s alignment rectangle.
    public static var height: Swiftly {
        return Swiftly(.height)
    }

    /**
    A layout representing the width of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func width(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.width, toItem: item)
    }

    /// A layout representing the width of a `Swiftlyable`'s alignment rectangle.
    public static var width: Swiftly {
        return Swiftly(.width)
    }

    /**
    A layout representing the center along the x-axis of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func centerX(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.centerX, toItem: item)
    }

    /// A layout representing the center along the x-axis of a `Swiftlyable`'s alignment rectangle.
    public static var centerX: Swiftly {
        return Swiftly(.centerX)
    }

    /**
    A layout representing the center along the y-axis of a `Swiftlyable`'s alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func centerY(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.centerY, toItem: item)
    }

    /// A layout representing the center along the y-axis of a `Swiftlyable`'s alignment rectangle.
    public static var centerY: Swiftly {
        return Swiftly(.centerY)
    }

    /**
    A layout representing the baseline of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func baseline(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.lastBaseline, toItem: item)
    }

    /// A layout representing the baseline of a `Swiftlyable`.
    public static var baseline: Swiftly {
        return Swiftly(.lastBaseline)
    }

    /**
    A layout representing the top most baseline of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func firstBaseline(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.firstBaseline, toItem: item)
    }

    /// A layout representing the top most baseline of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var firstBaseline: Swiftly {
        return Swiftly(.firstBaseline)
    }

    /**
    A layout representing the left margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func leftMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.leftMargin, toItem: item)
    }

    /// A layout representing the left margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var leftMargin: Swiftly {
        return Swiftly(.leftMargin)
    }

    /**
    A layout representing the right margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func rightMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.rightMargin, toItem: item)
    }

    /// A layout representing the right margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var rightMargin: Swiftly {
        return Swiftly(.rightMargin)
    }

    /**
    A layout representing the top margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func topMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.topMargin, toItem: item)
    }

    /// A layout representing the top margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var topMargin: Swiftly {
        return Swiftly(.topMargin)
    }

    /**
    A layout representing the bottom margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func bottomMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.bottomMargin, toItem: item)
    }

    /// A layout representing the bottom margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var bottomMargin: Swiftly {
        return Swiftly(.bottomMargin)
    }

    /**
    A layout representing the leading margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func leadingMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.leadingMargin, toItem: item)
    }

    /// A layout representing the leading margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var leadingMargin: Swiftly {
        return Swiftly(.leadingMargin)
    }

    /**
    A layout representing the trailing margin of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func trailingMargin(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.trailingMargin, toItem: item)
    }

    /// A layout representing the trailing margin of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var trailingMargin: Swiftly {
        return Swiftly(.trailingMargin)
    }

    /**
    A layout representing the center along the x-axis between the left and right margins of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func centerXWithinMargins(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.centerXWithinMargins, toItem: item)
    }

    /// A layout representing the center along the x-axis between the left and right margins of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var centerXWithinMargins: Swiftly {
        return Swiftly(.centerXWithinMargins)
    }

    /**
    A layout representing the center along the y-axis between the top and bottom margins of a `Swiftlyable`.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func centerYWithinMargins(_ item: Swiftlyable) -> Swiftly {
        return Swiftly(.centerYWithinMargins, toItem: item)
    }

    /// A layout representing the center along the y-axis between the top and bottom margins of a `Swiftlyable`.
    @available(iOS, introduced: 8.0)
    public static var centerYWithinMargins: Swiftly {
        return Swiftly(.centerYWithinMargins)
    }

    let attribute: NSLayoutConstraint.Attribute?
    let attributes: [NSLayoutConstraint.Attribute]?
    var relatedBy: NSLayoutConstraint.Relation?
    var otherAttribute: NSLayoutConstraint.Attribute?
    var otherAttributes: [NSLayoutConstraint.Attribute]?
    var multiplier: CGFloat
    var constant: CGFloat
    var toItem: Swiftlyable?
    var priority: UILayoutPriority?

    init(_ a: NSLayoutConstraint.Attribute? = nil, attributes atts: [NSLayoutConstraint.Attribute]? = nil, relatedBy r: NSLayoutConstraint.Relation? = .equal, toItem ti: Swiftlyable? = nil, otherAttribute oa: NSLayoutConstraint.Attribute? = nil, otherAttributes otherAtts: [NSLayoutConstraint.Attribute]? = nil, multiplier m: CGFloat = 1, constant c: CGFloat = 0) {
        attribute = a
        attributes = atts
        relatedBy = r
        toItem = ti
        otherAttribute = oa
        otherAttributes = otherAtts
        multiplier = m
        constant = c
    }
}

/**
Assign a property of a `Swiftlyable` equal to that property on another `Swiftlyable`. Useful for things such as settings the top of a view equal to the top of another view.

- parameter left:  Layout property to assign
- parameter right: View to equal

- returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: Swiftlyable) -> Swiftly {
    var result = left
    result.toItem = right
    return result
}

/**
Assign a property of a `Swiftlyable` equal to a constant. Useful for things such as settings the top of a view equal to the top of another view.

- parameter left:  Layout property to assign
- parameter right: Constant to assign

- returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right

    if left.attribute != nil {
        result.otherAttribute = .notAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutConstraint.Attribute](repeating: .notAnAttribute, count: attrsCount)
    }

    return result
}

/**
Assign a layout property equal to another property. Useful for things such as setting the bottom of a view to the top of another.

- parameter left:  Layout property to assign
- parameter right: Layout property to equal

- returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.toItem

    if let attrs = right.attributes {
        result.otherAttributes = attrs
    } else {
        result.otherAttribute = right.attribute
    }

    result.relatedBy = .equal
    if right.constant != 0 {
        result.constant = right.constant
    }
    if right.multiplier != 0 {
        result.multiplier = right.multiplier
    }
    return result
}

/**
Assign a layout property greater than or equal to another property. Useful for things such as creating a view that should have a width greater than or equal to a spacer view.

- parameter left:  Layout property to assign
- parameter right: Layout property to be greater than or equal to

- returns: A Swiftly object representing the desired constraint
*/
public func >=(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.toItem

    if let attrs = right.attributes {
        result.otherAttributes = attrs
    } else {
        result.otherAttribute = right.attribute
    }

    result.relatedBy = .greaterThanOrEqual
    if right.constant != 0 {
        result.constant = right.constant
    }
    if right.multiplier != 0 {
        result.multiplier = right.multiplier
    }
    return result
}

/**
Assign a layout property greater than or equal to a constant.

- parameter left:  Layout property to assign
- parameter right: Constant to be greater than or equal to

- returns: A Swiftly object representing the desired constraint
*/
public func >=(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right

    if left.attribute != nil {
        result.otherAttribute = .notAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutConstraint.Attribute](repeating: .notAnAttribute, count: attrsCount)
    }

    result.relatedBy = .greaterThanOrEqual
    result.multiplier = 1
    return result
}

/**
Assign a layout property less than or equal to another property. Useful for things such as creating a spacer view that should have a width less than or equal to a view.

- parameter left:  Layout property to assign
- parameter right: Layout property to be less than or equal to

- returns: A Swiftly object representing the desired constraint
*/
public func <=(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.toItem

    if let attrs = right.attributes {
        result.otherAttributes = attrs
    } else {
        result.otherAttribute = right.attribute
    }

    result.relatedBy = .lessThanOrEqual
    if right.constant != 0 {
        result.constant = right.constant
    }
    if right.multiplier != 0 {
        result.multiplier = right.multiplier
    }
    return result
}

/**
Assign a layout property less than or equal to a constant.

- parameter left:  Layout property to assign
- parameter right: The constant to be less than or equal to

- returns: A Swiftly object representing the desired constraint
*/
public func <=(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right

    if left.attribute != nil {
        result.otherAttribute = .notAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutConstraint.Attribute](repeating: .notAnAttribute, count: attrsCount)
    }

    result.relatedBy = .lessThanOrEqual
    result.multiplier = 1
    return result
}

/**
Assign the constant of a property. Useful for things such as pinning a view to it's superview with a margin.

- parameter left:  Layout property to assign
- parameter right: Constant to apply

- returns: A Swiftly object representing the desired constraint
*/
public func +(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right
    return result
}

/**
Assign a negative constant to a property.

- parameter left:  Layout property to assign
- parameter right: Constant value to apply

- returns: A Swiftly object representing the desired constraint
*/
public func -(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = -(right)
    return result
}

/**
Assign the multiplier of a property.

- parameter left:  Layout property to assign
- parameter right: Multiplier value

- returns: A Swiftly object representing the desired constraint
*/
public func *(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.multiplier = right
    return result
}

/**
Assign the multiplier of a property.

- parameter left:  Layout property to assign
- parameter right: Inverse multiplier value

- returns: A Swiftly object representing the desired constraint
*/
public func /(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.multiplier = 1 / right
    return result
}

/**
Assign the priority of a property.

 - parameter priority: Layout property to assign
 - parameter swiftly:  The priority

 - returns: A Swiftly object representing the desired constraint
 */
public func ~=(left: Swiftly, right: UILayoutPriority) -> Swiftly {
    var s = left
    s.priority = right
    return s
}
