//
//  PACustomPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PACustomPermissionsCheck: PAPermissionsCheck {

	override func checkStatus() {
		self.status = .Disabled
		self.updateStatus()
	}
	
	override func defaultAction() {
		self.status = .Enabled
		self.updateStatus()
	}
}
