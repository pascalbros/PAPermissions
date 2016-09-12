//
//  PANotificationsPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PANotificationsPermissionsCheck: PAPermissionsCheck {

	private var _categories: AnyObject?
	
	@available(iOS 8.0, *)
	var categories: Set<UIMutableUserNotificationCategory>? {
		get {
			return self._categories as? Set<UIMutableUserNotificationCategory>
		}
		
		set(newCategories) {
			self._categories = newCategories
		}
	}
	
	private var _types: Any?
	
	@available(iOS 8.0, *)
	var types: UIUserNotificationType {
		get {
			return self._types as! UIUserNotificationType
		}
		
		set (newTypes) {
			self._types = newTypes
		}
	}
	
	@available(iOS 7.0, *)
	var legacyTypes: UIRemoteNotificationType {
		get {
			return self._types as! UIRemoteNotificationType
		}
		
		set (newTypes) {
			self._types = newTypes
		}
	}
	
	var lastDefaultActionTapped: NSDate?
	
	private var timer: NSTimer!
	
	override init() {
		super.init()
		if #available(iOS 8.0, *) {
			self.types = [.Badge, .Sound, .Alert]
		}else{
			self.legacyTypes = [.Badge, .Sound, .Alert]
		}
	}
	
	override func checkStatus() {
		let currentStatus = self.status

		if #available(iOS 8.0, *) {
			if let settings = UIApplication.sharedApplication().currentUserNotificationSettings() {
				if settings.types != .None {
					self.status = .Enabled
				}else{
					self.status = .Disabled
				}
			}else{
				self.status = .Disabled
			}
		} else {
			if UIApplication.sharedApplication().enabledRemoteNotificationTypes() != .None {
				self.status = .Enabled
			}else{
				self.status = .Disabled
			}
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
		
		if #available(iOS 8.0, *) {
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
		}else{
			if UIApplication.sharedApplication().enabledRemoteNotificationTypes() == .None {
				if let lastDefaultActionTapped = self.lastDefaultActionTapped {
					let now = NSDate()
					
					if now.timeIntervalSinceDate(lastDefaultActionTapped) < 3 {
						let settingsURL = NSURL(string: "prefs:root=NOTIFICATIONS_ID")!
						UIApplication.sharedApplication().openURL(settingsURL)
						self.stopTimer()
						return
					}
				}
				self.lastDefaultActionTapped = NSDate()
				UIApplication.sharedApplication().registerForRemoteNotificationTypes(legacyTypes)
				self.startTimer()
			}else{
				self.stopTimer()
				self.status = .Enabled
				self.updateStatus()
			}
		}
	}
}
