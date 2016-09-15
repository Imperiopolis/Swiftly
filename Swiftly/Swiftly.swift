//
//  Swiftly.swift
//  Swiftly
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit

public extension Array where Element : UIView {

    /**
    Apply an array of Swiftly objects to an array of views. This is appended to any existing constraints.

    - parameter layoutArray: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    internal func applyLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        for view in self {
            constraints += view.applyLayout(layoutArray: layoutArray)
        }

        return constraints
    }

    /**
    Apply an array of Swiftly objects to an array of views. The constraints are not applied to the first view in the array (since it has no previous item). This is appended to any existing constraints.

    - parameter callback: A closure used to define the constraints. A previousView argument is passed to allow for distributing views.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    func applyLayoutWithPreviousView(_ callback: (_ previousView: UIView) -> [Swiftly]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var previousView: UIView?
        for view in self {
            if let previousView = previousView {
                let swiftly = callback(previousView)
                constraints += view.applyLayout(layoutArray: swiftly)
            }

            previousView = view
        }

        return constraints
    }

    /**
    Apply a variadic list of Swiftly objects to an array of views. This is appended to any existing constraints.

    - parameter layout: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    func applyLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }

}

@available(iOS, introduced: 9.0)
public extension Array where Element : UILayoutGuide {

    /**
     Apply an array of Swiftly objects to an array of layout guides. This is appended to any existing constraints.

     - parameter layoutArray: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    internal func applyLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        for view in self {
            constraints += view.applyLayout(layoutArray: layoutArray)
        }

        return constraints
    }

    /**
     Apply a variadic list of Swiftly objects to an array of layout guides. This is appended to any existing constraints.

     - parameter layout: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    @discardableResult
    func applyLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }
    
}

public extension UIView {

    /**
    Apply an array of Swiftly objects to a view. This is appended to any existing constraints.

    - parameter layoutArray: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    internal func applyLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("You must assign a superview before applying a layout")
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        for l in layoutArray {
            let attributes: [NSLayoutAttribute]
            if let attrs = l.attributes {
                attributes = attrs
            } else if let attr = l.attribute {
                attributes = [attr]
            } else {
                fatalError("You must define an attribute.")
            }

            let otherAttributes: [NSLayoutAttribute]
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

            for (attr, otherAttr) in zip(attributes, otherAttributes) {
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

                constraints.append(constraint)
            }
        }

        superview.addConstraints(constraints)
        return constraints
    }

    /**
    Apply a variadic list of Swiftly objects to a view. This is appended to any existing constraints.

    - parameter layout: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    @discardableResult
    func applyLayout(_ layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }
}

@available(iOS, introduced: 9.0)
public extension UILayoutGuide {

    /**
     Apply an array of Swiftly objects to a layout guide. This is appended to any existing constraints.

     - parameter layoutArray: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    internal func applyLayout(layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        guard let owningView = owningView else {
            fatalError("You must add this layout guide to a view before applying a layout")
        }

        var constraints = [NSLayoutConstraint]()

        for l in layoutArray {
            let attributes: [NSLayoutAttribute]
            if let attrs = l.attributes {
                attributes = attrs
            } else if let attr = l.attribute {
                attributes = [attr]
            } else {
                fatalError("You must define an attribute.")
            }

            let otherAttributes: [NSLayoutAttribute]
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

            for (attr, otherAttr) in zip(attributes, otherAttributes) {
                // toItem should be nil when setting a fixed size
                let toItem = otherAttr == .notAnAttribute ? nil : (l.toItem ?? owningView)

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

                constraints.append(constraint)
            }
        }

        owningView.addConstraints(constraints)
        return constraints
    }

    /**
     Apply a variadic list of Swiftly objects to a view. This is appended to any existing constraints.

     - parameter layout: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    @discardableResult
    func applyLayout(_ layout: Swiftly ...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }
}

/**
*  A struct representing a set of constraint attributes. Initializers are available to create all common constraint types.
*/
public struct Swiftly {
    /**
    A combined layout representing all sides of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func flush(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right], toItem: item)
    }
    /**
     A combined layout representing all sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func flushToMargins(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.top, .left, .bottom, .right], toItem: item, otherAttributes: [.topMargin, .leftMargin, .bottomMargin, .rightMargin])
    }
    /**
    A combined layout representing the left and right sides of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func horizontal(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.left, .right], toItem: item)
    }
    /**
     A combined layout representing the left and right sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func horizontalMargins(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.left, .right], toItem: item, otherAttributes: [.leftMargin, .rightMargin])
    }
    /**
    A combined layout representing the top and bottom sides of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func vertical(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.top, .bottom], toItem: item)
    }
    /**
     A combined layout representing the top and bottom sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func verticalMargins(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.top, .bottom], toItem: item, otherAttributes: [.topMargin, .bottomMargin])
    }
    /**
    A combined layout representing the center along the x-axis and y-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func center(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.centerX, .centerY], toItem: item)
    }
    /**
    A combined layout representing the height and width of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func size(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.height, .width], toItem: item)
    }
    /**
    A layout representing the left side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func left(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.left, toItem: item)
    }
    /**
    A layout representing the right side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func right(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.right, toItem: item)
    }
    /**
    A layout representing the top side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func top(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.top, toItem: item)
    }
    /**
    A layout representing the bottom side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func bottom(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.bottom, toItem: item)
    }
    /**
    A layout representing the leading edge of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func leading(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.leading, toItem: item)
    }
    /**
    A layout representing the trailing edge of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func trailing(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.trailing, toItem: item)
    }
    /**
    A layout representing the height of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func height(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.height, toItem: item)
    }
    /**
    A layout representing the width of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func width(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.width, toItem: item)
    }
    /**
    A layout representing the center along the x-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func centerX(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.centerX, toItem: item)
    }
    /**
    A layout representing the center along the y-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func centerY(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.centerY, toItem: item)
    }
    /**
    A layout representing the baseline of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func baseline(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.lastBaseline, toItem: item)
    }

    /**
    A layout representing the top most baseline of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func firstBaseline(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.firstBaseline, toItem: item)
    }

    /**
    A layout representing the left margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func leftMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.leftMargin, toItem: item)
    }
    /**
    A layout representing the right margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func rightMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.rightMargin, toItem: item)
    }
    /**
    A layout representing the top margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func topMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.topMargin, toItem: item)
    }
    /**
    A layout representing the bottom margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func bottomMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.bottomMargin, toItem: item)
    }
    /**
    A layout representing the leading margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func leadingMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.leadingMargin, toItem: item)
    }
    /**
    A layout representing the trailing margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func trailingMargin(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.trailingMargin, toItem: item)
    }
    /**
    A layout representing the center along the x-axis between the left and right margins of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func centerXWithinMargins(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.centerXWithinMargins, toItem: item)
    }
    /**
    A layout representing the center along the y-axis between the top and bottom margins of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced: 8.0)
    public static func centerYWithinMargins(_ item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.centerYWithinMargins, toItem: item)
    }

    let attribute: NSLayoutAttribute?
    let attributes: [NSLayoutAttribute]?
    var relatedBy: NSLayoutRelation?
    var otherAttribute: NSLayoutAttribute?
    var otherAttributes: [NSLayoutAttribute]?
    var multiplier: CGFloat
    var constant: CGFloat
    var toItem: AnyObject?
    var priority: UILayoutPriority?

    init(_ a: NSLayoutAttribute? = nil, attributes atts: [NSLayoutAttribute]? = nil, relatedBy r: NSLayoutRelation? = .equal, toItem ti: AnyObject? = nil, otherAttribute oa: NSLayoutAttribute? = nil, otherAttributes otherAtts: [NSLayoutAttribute]? = nil, multiplier m: CGFloat = 1, constant c: CGFloat = 0) {
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
Assign a property of a view equal to that property on another view. Useful for things such as settings the top of a view equal to the top of another view.

- parameter left:  Layout property to assign
- parameter right: View to equal

- returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: AnyObject) -> Swiftly {
    var result = left
    result.toItem = right
    return result
}

/**
Assign a property of a view equal to a constant. Useful for things such as settings the top of a view equal to the top of another view.

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
        result.otherAttributes = [NSLayoutAttribute](repeating: .notAnAttribute, count: attrsCount)
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
        result.otherAttributes = [NSLayoutAttribute](repeating: .notAnAttribute, count: attrsCount)
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
        result.otherAttributes = [NSLayoutAttribute](repeating: .notAnAttribute, count: attrsCount)
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

precedencegroup LayoutPriority {
    associativity: left
    lowerThan: ComparisonPrecedence
}

infix operator ~== : LayoutPriority

/**
Assign the priority of a property.

 - parameter priority: Layout property to assign
 - parameter swiftly:  The priority

 - returns: A Swiftly object representing the desired constraint
 */
public func ~==(left: Swiftly, right: UILayoutPriority) -> Swiftly {
    var s = left
    s.priority = right
    return s
}
