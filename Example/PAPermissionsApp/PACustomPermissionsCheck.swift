//
//  PACustomPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import PAPermissions

class PACustomPermissionsCheck: PAPermissionsCheck {

	open override func checkStatus() {
		self.status = .disabled
		self.updateStatus()
	}
	
	open override func defaultAction() {
		self.status = .enabled
		self.updateStatus()
	}
}
