//
//  ExampleViewController.swift
//  Example
//
//  Created by Nora Trapp on 6/23/15.
//
//

import UIKit
import Swiftly

class ExampleViewController: UIViewController {

    var twoColumnConstraints = [NSLayoutConstraint]()
    var threeColumnConstraints = [NSLayoutConstraint]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create three views
        let view1 = UIView()
        view.addSubview(view1)
        view1.backgroundColor = .blueColor()
        let view2 = UIView()
        view.addSubview(view2)
        view2.backgroundColor = .whiteColor()
        let view3 = UIView()
        view.addSubview(view3)
        view3.backgroundColor = .purpleColor()

        // Create 3 column constraints, disabled for now
        threeColumnConstraints += view1.applyLayout(.Vertical(), .Left() + 5, .Width() / 3 - 7.5)
        threeColumnConstraints += view2.applyLayout(.Vertical(), .Left() == .Right(view1) + 7.5, .Width() / 3 - 7.5)
        threeColumnConstraints += view3.applyLayout(.Vertical(), .Left() == .Right(view2) + 7.5, .Right() - 5)

        NSLayoutConstraint.deactivateConstraints(threeColumnConstraints)

        // Layout two views in two vertical columns. Save the constraints for future modification.
        twoColumnConstraints += view1.applyLayout(.Vertical(), .Left() + 5, .Width() / 2 - 7.5)
        twoColumnConstraints += view2.applyLayout(.Vertical(), .Left() == .Right(view1) + 7.5, .Right() - 5)

        // Third column off the right hand side
        twoColumnConstraints += view3.applyLayout(.Vertical(), .Right())

        // Animate in the third column after 2 seconds
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [unowned self] in
            UIView.animateWithDuration(0.5) {
                NSLayoutConstraint.deactivateConstraints(self.twoColumnConstraints)
                NSLayoutConstraint.activateConstraints(self.threeColumnConstraints)
                self.view.layoutIfNeeded()
            }
        }
    }
}
