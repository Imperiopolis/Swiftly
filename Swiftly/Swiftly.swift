//
//  Swiftly.swift
//  Swiftly
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit

public extension UIView {

    /**
    Apply an array of Swiftly objects to a view. This is appended to any existing constraints.

    :param: layoutArray The layout(s) to apply.

    :returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    internal func applyLayout(#layoutArray: [Swiftly]) -> [NSLayoutConstraint] {
        if self.superview == nil {
            fatalError("You must assign a superview before applying a layout")
        }

        self.setTranslatesAutoresizingMaskIntoConstraints(false)

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
                let toItem = otherAttr == .NotAnAttribute ? nil : (l.toItem ?? self.superview!)

                constraints.append(NSLayoutConstraint(
                    item: l.fromItem ?? self,
                    attribute: attr,
                    relatedBy: l.relatedBy ?? .Equal,
                    toItem: toItem,
                    attribute: otherAttr,
                    multiplier: l.multiplier,
                    constant: l.constant))
            }
        }

        self.superview!.addConstraints(constraints)
        return constraints
    }

    /**
    Apply a variadic list of Swiftly objects to a view. This is appended to any existing constraints.

    :param: layout The layout(s) to apply.

    :returns: An array of constraints that represent the applied layout. This can be used to dynamically enable / disable a given layout.
    */
    func applyLayout(layout: Swiftly...) -> [NSLayoutConstraint] {
        return self.applyLayout(layoutArray: layout)
    }
}

/**
*  A struct representing a set of constraint attributes. Initializers are available to create all common constraint types.
*/
public struct Swiftly {
    /**
    A combined layout representing all sides of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Flush(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(attributes: [.Left, .Right, .Top, .Bottom], fromItem: view)
    }
    /**
    A combined layout representing the left and right sides of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Horizontal(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(attributes: [.Left, .Right], fromItem: view)
    }
    /**
    A combined layout representing the top and bottom sides of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Vertical(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(attributes: [.Top, .Bottom], fromItem: view)
    }
    /**
    A combined layout representing the center along the x-axis and y-axis of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Center(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(attributes: [.CenterX, .CenterY], fromItem: view)
    }
    /**
    A combined layout representing the height and width of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Size(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(attributes: [.Height, .Width], fromItem: view)
    }
    /**
    A layout representing the left side of a view's alignment rectangle.

    :param: view The view that the property representing. If nil the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Left(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Left, fromItem: view)
    }
    /**
    A layout representing the right side of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Right(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Right, fromItem: view)
    }
    /**
    A layout representing the top side of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Top(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Top, fromItem: view)
    }
    /**
    A layout representing the bottom side of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Bottom(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Bottom, fromItem: view)
    }
    /**
    A layout representing the leading edge of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Leading(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Leading, fromItem: view)
    }
    /**
    A layout representing the trailing edge of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Trailing(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Trailing, fromItem: view)
    }
    /**
    A layout representing the height of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Height(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Height, fromItem: view)
    }
    /**
    A layout representing the width of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Width(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Width, fromItem: view)
    }
    /**
    A layout representing the center along the x-axis of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func CenterX(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.CenterX, fromItem: view)
    }
    /**
    A layout representing the center along the y-axis of a view's alignment rectangle.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func CenterY(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.CenterY, fromItem: view)
    }
    /**
    A layout representing the baseline of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    public static func Baseline(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.Baseline, fromItem: view)
    }

    /**
    A layout representing the top most baseline of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func FirstBaseline(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.FirstBaseline, fromItem: view)
    }

    /**
    A layout representing the left margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func LeftMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.LeftMargin, fromItem: view)
    }
    /**
    A layout representing the right margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func RightMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.RightMargin, fromItem: view)
    }
    /**
    A layout representing the top margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func TopMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.TopMargin, fromItem: view)
    }
    /**
    A layout representing the bottom margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func BottomMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.BottomMargin, fromItem: view)
    }
    /**
    A layout representing the leading margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func LeadingMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.LeadingMargin, fromItem: view)
    }
    /**
    A layout representing the trailing margin of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func TrailingMargin(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.TrailingMargin, fromItem: view)
    }
    /**
    A layout representing the center along the x-axis between the left and right margins of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func CenterXWithinMargins(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.CenterXWithinMargins, fromItem: view)
    }
    /**
    A layout representing the center along the y-axis between the top and bottom margins of a view.

    :param: view The view that the property representing. If nil, the layout is relative to the superview.

    :returns: A Swiftly object representing the desired layout.
    */
    @availability(iOS, introduced=8.0)
    public static func CenterYWithinMargins(_ view: UIView? = nil) -> Swiftly {
        return Swiftly(.CenterYWithinMargins, fromItem: view)
    }

    private let attribute: NSLayoutAttribute?
    private let attributes: [NSLayoutAttribute]?
    private var fromItem: UIView?
    private var relatedBy: NSLayoutRelation?
    private var otherAttribute: NSLayoutAttribute?
    private var otherAttributes: [NSLayoutAttribute]?
    private var multiplier: CGFloat
    private var constant: CGFloat
    private var toItem: UIView?

    private init(_ a: NSLayoutAttribute? = nil, attributes atts: [NSLayoutAttribute]? = nil, relatedBy r: NSLayoutRelation? = .Equal, fromItem fi: UIView? = nil, toItem ti: UIView? = nil, otherAttribute oa: NSLayoutAttribute? = nil, multiplier m: CGFloat = 1, constant c: CGFloat = 0) {
        attribute = a
        attributes = atts
        relatedBy = r
        fromItem = fi
        toItem = ti
        otherAttribute = oa
        multiplier = m
        constant = c
    }
}

/**
Assign a property of a view equal to that property on another view. Useful for things such as settings the top of a view equal to the top of another view.

:param: left  Layout property to assign
:param: right View to equal

:returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: UIView) -> Swiftly {
    var result = left
    result.toItem = right
    return result
}

/**
Assign a property of a view equal to a constant. Useful for things such as settings the top of a view equal to the top of another view.

:param: left  Layout property to assign
:param: right Constant to assign

:returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right
    result.otherAttribute = .NotAnAttribute
    return result
}

/**
Assign a layout property equal to another property. Useful for things such as setting the bottom of a view to the top of another.

:param: left  Layout property to assign
:param: right Layout property to equal

:returns: A Swiftly object representing the desired constraint
*/
public func ==(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.fromItem

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

:param: left  Layout property to assign
:param: right Layout property to be greater than or equal to

:returns: A Swiftly object representing the desired constraint
*/
public func >=(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.fromItem

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
Assign a layout property less than or equal to another property. Useful for things such as creating a spacer view that should have a width less than or equal to a view.

:param: left  Layout property to assign
:param: right Layout property to be less than or equal to

:returns: A Swiftly object representing the desired constraint
*/
public func <=(left: Swiftly, right: Swiftly) -> Swiftly {
    var result = left
    result.toItem = right.fromItem

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
Assign the constant of a property. Useful for things such as pinning a view to it's superview with a margin.

:param: left  Layout property to assign
:param: right Constant to apply

:returns: A Swiftly object representing the desired constraint
*/
public func +(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = right
    return result
}

/**
Assign a negative constant to a property.

:param: left  Layout property to assign
:param: right Constant value to apply

:returns: A Swiftly object representing the desired constraint
*/
public func -(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.constant = -(right)
    return result
}

/**
Assign the multiplier of a property.

:param: left  Layout property to assign
:param: right Multiplier value

:returns: A Swiftly object representing the desired constraint
*/
public func *(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.multiplier = right
    return result
}

/**
Assign the multiplier of a property.

:param: left  Layout property to assign
:param: right Inverse multiplier value

:returns: A Swiftly object representing the desired constraint
*/
public func /(left: Swiftly, right: CGFloat) -> Swiftly {
    var result = left
    result.multiplier = 1 / right
    return result
}
