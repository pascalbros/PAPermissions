//
//  PARemindersPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Alex Kac on 9/13/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import EventKit

class PACalendarPermissionsCheck: PAEKPermissionsCheck {
	override init() {
		super.init()
		entityType = .event
	}
}

class PARemindersPermissionsCheck: PAEKPermissionsCheck {
	override init() {
		super.init()
		entityType = .reminder
	}
}

class PAEKPermissionsCheck: PAPermissionsCheck {

	var entityType : EKEntityType?

	override func checkStatus() {
		let currentStatus = status

		switch EKEventStore.authorizationStatus(for: entityType!) {
		case .authorized:
			status = .enabled
		case .denied:
			status = .disabled
		case .notDetermined:
			status = .disabled
		case .restricted:
			status = .unavailable
		}

		if currentStatus != status {
			updateStatus()
		}
	}

	override func defaultAction() {

		if EKEventStore.authorizationStatus(for: entityType!) == .denied {
			let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
			UIApplication.shared.openURL(settingsURL!)
		} else {
			EKEventStore().requestAccess(to: .reminder, completion: { (success, error) in
				if success && error == nil {
					self.status = .enabled
				} else {
					self.status = .disabled
				}
				self.updateStatus()
			})
		}
		
	}

}


