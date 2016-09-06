//
//  PAConstraintsUtils.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PAConstraintsUtils: NSObject {
	static func concatenateConstraintsFromString(constraintsArray: [String], views: [String: UIView!]) -> [NSLayoutConstraint] {
		var allConstraints = [NSLayoutConstraint]()
		
		for constraintString in constraintsArray {
			let constraint = NSLayoutConstraint.constraintsWithVisualFormat(
				constraintString,
				options: [],
				metrics: nil,
				views: views)
			allConstraints.appendContentsOf(constraint)
		}
		return allConstraints
	}
}
