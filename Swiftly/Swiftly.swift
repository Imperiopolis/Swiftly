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
    internal func applyLayout(layoutArray layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
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
    func applyLayoutWithPreviousView(@noescape callback: (previousView: UIView) -> [Swiftly]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        var previousView: UIView?
        for view in self {
            if let previousView = previousView {
                let swiftly = callback(previousView: previousView)
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
    func applyLayout(layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }

}

@available(iOS, introduced=9.0)
public extension Array where Element : UILayoutGuide {

    /**
     Apply an array of Swiftly objects to an array of layout guides. This is appended to any existing constraints.

     - parameter layoutArray: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    internal func applyLayout(layoutArray layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
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
    func applyLayout(layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }
    
}

public extension UIView {

    /**
    Apply an array of Swiftly objects to a view. This is appended to any existing constraints.

    - parameter layoutArray: The layout(s) to apply.

    - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    internal func applyLayout(layoutArray layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
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
                let toItem = otherAttr == .NotAnAttribute ? nil : (l.toItem ?? superview)

                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: attr,
                    relatedBy: l.relatedBy ?? .Equal,
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
    func applyLayout(layout: Swiftly...) -> [NSLayoutConstraint] {
        return applyLayout(layoutArray: layout)
    }
}

@available(iOS, introduced=9.0)
public extension UILayoutGuide {

    /**
     Apply an array of Swiftly objects to a layout guide. This is appended to any existing constraints.

     - parameter layoutArray: The layout(s) to apply.

     - returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
     */
    internal func applyLayout(layoutArray layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
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
                let toItem = otherAttr == .NotAnAttribute ? nil : (l.toItem ?? owningView)

                let constraint = NSLayoutConstraint(
                    item: self,
                    attribute: attr,
                    relatedBy: l.relatedBy ?? .Equal,
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
    func applyLayout(layout: Swiftly ...) -> [NSLayoutConstraint] {
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
    public static func Flush(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Top, .Left, .Bottom, .Right], toItem: item)
    }
    /**
     A combined layout representing all sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func FlushToMargins(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Top, .Left, .Bottom, .Right], otherAttributes: [.TopMargin, .LeftMargin, .BottomMargin, .RightMargin], toItem: item)
    }
    /**
    A combined layout representing the left and right sides of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Horizontal(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Left, .Right], toItem: item)
    }
    /**
     A combined layout representing the left and right sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func HorizontalMargins(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Left, .Right], otherAttributes: [.LeftMargin, .RightMargin], toItem: item)
    }
    /**
    A combined layout representing the top and bottom sides of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Vertical(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Top, .Bottom], toItem: item)
    }
    /**
     A combined layout representing the top and bottom sides of a view's margin alignment rectangle.

     - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

     - returns: A Swiftly object representing the desired layout.
     */
    public static func VerticalMargins(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Top, .Bottom], otherAttributes: [.TopMargin, .BottomMargin], toItem: item)
    }
    /**
    A combined layout representing the center along the x-axis and y-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Center(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.CenterX, .CenterY], toItem: item)
    }
    /**
    A combined layout representing the height and width of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Size(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(attributes: [.Height, .Width], toItem: item)
    }
    /**
    A layout representing the left side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Left(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Left, toItem: item)
    }
    /**
    A layout representing the right side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Right(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Right, toItem: item)
    }
    /**
    A layout representing the top side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Top(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Top, toItem: item)
    }
    /**
    A layout representing the bottom side of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Bottom(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Bottom, toItem: item)
    }
    /**
    A layout representing the leading edge of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Leading(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Leading, toItem: item)
    }
    /**
    A layout representing the trailing edge of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Trailing(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Trailing, toItem: item)
    }
    /**
    A layout representing the height of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Height(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Height, toItem: item)
    }
    /**
    A layout representing the width of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Width(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Width, toItem: item)
    }
    /**
    A layout representing the center along the x-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func CenterX(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.CenterX, toItem: item)
    }
    /**
    A layout representing the center along the y-axis of a view's alignment rectangle.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func CenterY(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.CenterY, toItem: item)
    }
    /**
    A layout representing the baseline of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    public static func Baseline(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.Baseline, toItem: item)
    }

    /**
    A layout representing the top most baseline of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func FirstBaseline(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.FirstBaseline, toItem: item)
    }

    /**
    A layout representing the left margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func LeftMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.LeftMargin, toItem: item)
    }
    /**
    A layout representing the right margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func RightMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.RightMargin, toItem: item)
    }
    /**
    A layout representing the top margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func TopMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.TopMargin, toItem: item)
    }
    /**
    A layout representing the bottom margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func BottomMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.BottomMargin, toItem: item)
    }
    /**
    A layout representing the leading margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func LeadingMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.LeadingMargin, toItem: item)
    }
    /**
    A layout representing the trailing margin of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func TrailingMargin(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.TrailingMargin, toItem: item)
    }
    /**
    A layout representing the center along the x-axis between the left and right margins of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func CenterXWithinMargins(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.CenterXWithinMargins, toItem: item)
    }
    /**
    A layout representing the center along the y-axis between the top and bottom margins of a view.

    - parameter item: The item that the property is representing. When nil, the layout is relative to the superview.

    - returns: A Swiftly object representing the desired layout.
    */
    @available(iOS, introduced=8.0)
    public static func CenterYWithinMargins(item: AnyObject? = nil) -> Swiftly {
        return Swiftly(.CenterYWithinMargins, toItem: item)
    }

    private let attribute: NSLayoutAttribute?
    private let attributes: [NSLayoutAttribute]?
    private var relatedBy: NSLayoutRelation?
    private var otherAttribute: NSLayoutAttribute?
    private var otherAttributes: [NSLayoutAttribute]?
    private var multiplier: CGFloat
    private var constant: CGFloat
    private var toItem: AnyObject?
    private var priority: UILayoutPriority?

    private init(_ a: NSLayoutAttribute? = nil, attributes atts: [NSLayoutAttribute]? = nil, relatedBy r: NSLayoutRelation? = .Equal, toItem ti: AnyObject? = nil, otherAttribute oa: NSLayoutAttribute? = nil, otherAttributes otherAtts: [NSLayoutAttribute]? = nil, multiplier m: CGFloat = 1, constant c: CGFloat = 0) {
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
        result.otherAttribute = .NotAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutAttribute](count: attrsCount, repeatedValue: .NotAnAttribute)
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

    result.relatedBy = .Equal
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

    result.relatedBy = .GreaterThanOrEqual
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
        result.otherAttribute = .NotAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutAttribute](count: attrsCount, repeatedValue: .NotAnAttribute)
    }

    result.relatedBy = .GreaterThanOrEqual
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

    result.relatedBy = .LessThanOrEqual
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
        result.otherAttribute = .NotAnAttribute
    } else if let attrsCount = left.attributes?.count {
        result.otherAttributes = [NSLayoutAttribute](count: attrsCount, repeatedValue: .NotAnAttribute)
    }

    result.relatedBy = .LessThanOrEqual
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

infix operator ~= {
    precedence 0
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
