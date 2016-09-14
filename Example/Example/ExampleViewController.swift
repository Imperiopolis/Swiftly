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
        view1.backgroundColor = .blue
        let view2 = UIView()
        view.addSubview(view2)
        view2.backgroundColor = .white
        let view3 = UIView()
        view.addSubview(view3)
        view3.backgroundColor = .purple

        // Create 3 column constraints, disabled for now
        threeColumnConstraints += view1.applyLayout(.vertical(), .left() + 5, .width() / 3 - 7.5)
        threeColumnConstraints += view2.applyLayout(.vertical(), .left() == .right(view1) + 7.5, .width() / 3 - 7.5)
        threeColumnConstraints += view3.applyLayout(.vertical(), .left() == .right(view2) + 7.5, .right() - 5)

        NSLayoutConstraint.deactivate(threeColumnConstraints)

        // Layout two views in two vertical columns. Save the constraints for future modification.
        twoColumnConstraints += view1.applyLayout(.vertical(), .left() + 5, .width() / 2 - 7.5)
        twoColumnConstraints += view2.applyLayout(.vertical(), .left() == .right(view1) + 7.5, .right() - 5)

        // Third column off the right hand side
        twoColumnConstraints += view3.applyLayout(.vertical(), .right())

        // Animate in the third column after 2 seconds
        let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [unowned self] in
            UIView.animate(withDuration: 0.5, animations: {
                NSLayoutConstraint.deactivate(self.twoColumnConstraints)
                NSLayoutConstraint.activate(self.threeColumnConstraints)
                self.view.layoutIfNeeded()
            }) 
        }
    }
}
