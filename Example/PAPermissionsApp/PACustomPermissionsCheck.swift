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

	public override func checkStatus() {
		self.status = .disabled
		self.updateStatus()
	}
	
	public override func defaultAction() {
		self.status = .enabled
		self.updateStatus()
	}
}
