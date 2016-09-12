//
//  PANotificationsPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PANotificationsPermissionsCheck: PAPermissionsCheck {

	var categories: Set<UIMutableUserNotificationCategory>?
	var types: UIUserNotificationType = [.Sound, .Alert, .Badge]
	var lastDefaultActionTapped: NSDate?
	
	private var timer: NSTimer!
	
	override func checkStatus() {
		let currentStatus = self.status

		if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
			if settings.types != .None {
				self.status = .Enabled
			}else{
				self.status = .Disabled
			}
		}else{
			self.status = .Disabled
		}
		
		if self.status != currentStatus {
			if self.status == .Enabled {
				self.stopTimer()
			}
			self.updateStatus()
		}
	}
	
	private func startTimer() {
		self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(PANotificationsPermissionsCheck.checkStatus), userInfo: nil, repeats: true)
	}
	
	private func stopTimer() {
		if self.timer != nil {
			self.timer.invalidate()
			self.timer = nil
		}
	}
	
	
	
	override func defaultAction() {
		let notificationSettings: UIUserNotificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings() ?? UIUserNotificationSettings(forTypes: [.None], categories: nil)
		if notificationSettings.types == .None {
			if let lastDefaultActionTapped = self.lastDefaultActionTapped {
				let now = NSDate()
				
				if now.timeIntervalSinceDate(lastDefaultActionTapped) < 3 {
					let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
					UIApplication.sharedApplication().openURL(settingsURL!)
					self.stopTimer()
					return
				}
			}
			self.lastDefaultActionTapped = NSDate()
			UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes:self.types, categories: categories))
			self.startTimer()
		}else{
			self.stopTimer()
			self.status = .Enabled
			self.updateStatus()
		}
	}
}
