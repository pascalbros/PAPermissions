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

	override init() {
		super.init()
		self.status = .disabled
		self.canBeDisabled = true
	}
	
	open override func checkStatus() {
		self.updateStatus()
	}
	
	open override func defaultAction() {
		if self.status == .enabled {
			self.status = .disabled
		}else{
			self.status = .enabled
		}
		self.updateStatus()
	}
}
