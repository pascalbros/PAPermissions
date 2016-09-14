//
//  PAConstraintsUtils.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PAConstraintsUtils: NSObject {
	static func concatenateConstraintsFromString(_ constraintsArray: [String], views: [String: UIView]) -> [NSLayoutConstraint] {
		var allConstraints = [NSLayoutConstraint]()
		
		for constraintString in constraintsArray {
			let constraint = NSLayoutConstraint.constraints(
				withVisualFormat: constraintString,
				options: [],
				metrics: nil,
				views: views)
			allConstraints.append(contentsOf: constraint)
		}
		return allConstraints
	}
}
