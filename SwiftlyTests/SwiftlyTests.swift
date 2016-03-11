//
//  SwiftlyTests.swift
//  SwiftlyTests
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit
import XCTest
import Swiftly

class SwiftlyTests: XCTestCase {

    var containerView: UIView!
    let view = UIView()
    let offset: CGFloat = 5
    let negativeOffset: CGFloat = -5
    let span: CGFloat = 100
    let percentage: CGFloat = 0.5
    
    override func setUp() {
        super.setUp()
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: span, height: span))
        containerView.addSubview(view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOriginYPositiveOffset() {
        view.applyLayout(.Top() + offset)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame.origin.y == offset)
    }

    func testOriginYNegativeOffset() {
        view.applyLayout(.Top() - offset)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame.origin.y == negativeOffset)
    }

    func testOriginXPositiveOffset() {
        view.applyLayout(.Left() + offset)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame.origin.x == offset)
    }

    func testOriginXNegativeOffset() {
        view.applyLayout(.Left() - offset)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame.origin.x == negativeOffset)
    }

    func testOriginMultiplication() {
        view.applyLayout(.Width() * 2)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame.size.width == span * 2)
    }

    func testFlush() {
        view.applyLayout(.Flush())
        view.setNeedsLayout()
        view.layoutIfNeeded()
        XCTAssert(view.frame == containerView.frame)
    }

    func testFlushToMargins() {
        containerView.layoutMargins = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        view.applyLayout(.FlushToMargins())
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let expectedSpan = span - (offset * 2)
        XCTAssert(view.frame == CGRect(x: offset, y: offset, width: expectedSpan, height: expectedSpan))
    }
    
}
