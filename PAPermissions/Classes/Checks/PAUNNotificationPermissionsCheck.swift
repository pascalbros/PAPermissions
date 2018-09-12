//
//  PAUNNotificationPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Alex Kac on 9/13/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import UserNotifications

@available(iOS 10.0, *)
public class PAUNNotificationPermissionsCheck: PAPermissionsCheck {

	public let notificationCenter = UNUserNotificationCenter.current()
	public var authorizationStatus : UNAuthorizationStatus = .notDetermined

	public override func checkStatus() {
		let currentStatus = status

		notificationCenter.getNotificationSettings { (settings) in

			switch settings.authorizationStatus {
			case .authorized:
				self.status = .enabled
			case .denied:
				self.status = .disabled
			case .notDetermined:
				self.status = .disabled
			case .provisional:
                		self.status = .disabled
			}

			self.authorizationStatus = settings.authorizationStatus

			if currentStatus != self.status {
				self.updateStatus()
			}
		}
	}

	public override func defaultAction() {

		if authorizationStatus == .denied {
			self.openSettings()
		} else {
			notificationCenter.requestAuthorization(options: [.badge, .sound, .alert, .carPlay], completionHandler: { (success, error) in
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
