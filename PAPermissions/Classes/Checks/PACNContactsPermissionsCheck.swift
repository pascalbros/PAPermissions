//
//  PACNContactsPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 9/13/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import Contacts

@available(iOS 9.0, *)
public class PACNContactsPermissionsCheck: PAPermissionsCheck {

	public override func checkStatus() {
		let currentStatus = status

		switch CNContactStore.authorizationStatus(for: .contacts) {
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

	public override func defaultAction() {

		if CNContactStore.authorizationStatus(for: .contacts) == .denied {
			self.openSettings()
		} else {
			CNContactStore().requestAccess(for: .contacts) { (success, error) in
				if success && error == nil {
					self.status = .enabled
				} else {
					self.status = .disabled
				}
				self.updateStatus()
			}
		}

	}
}
