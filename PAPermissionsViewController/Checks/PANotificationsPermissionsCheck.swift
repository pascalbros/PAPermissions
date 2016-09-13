//
//  PANotificationsPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PANotificationsPermissionsCheck: PAPermissionsCheck {

	fileprivate var _categories: AnyObject?
	
	@available(iOS 8.0, *)
	var categories: Set<UIMutableUserNotificationCategory>? {
		get {
			return self._categories as? Set<UIMutableUserNotificationCategory>
		}
		
		set(newCategories) {
			self._categories = newCategories as AnyObject?
		}
	}
	
	fileprivate var _types: Any?
	
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
	
	var lastDefaultActionTapped: Date?
	
	fileprivate var timer: Timer!
	
	override init() {
		super.init()
		if #available(iOS 8.0, *) {
			self.types = [.badge, .sound, .alert]
		}else{
			self.legacyTypes = [.badge, .sound, .alert]
		}
	}
	
	override func checkStatus() {
		let currentStatus = self.status

		if #available(iOS 8.0, *) {
			if let settings = UIApplication.shared.currentUserNotificationSettings {
				if settings.types != UIUserNotificationType() {
					self.status = .enabled
				}else{
					self.status = .disabled
				}
			}else{
				self.status = .disabled
			}
		} else {
			if UIApplication.shared.enabledRemoteNotificationTypes() != UIRemoteNotificationType() {
				self.status = .enabled
			}else{
				self.status = .disabled
			}
		}
		
		if self.status != currentStatus {
			if self.status == .enabled {
				self.stopTimer()
			}
			self.updateStatus()
		}
	}
	
	fileprivate func startTimer() {
		self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(PANotificationsPermissionsCheck.checkStatus), userInfo: nil, repeats: true)
	}
	
	fileprivate func stopTimer() {
		if self.timer != nil {
			self.timer.invalidate()
			self.timer = nil
		}
	}
	
	
	
	override func defaultAction() {
		
		if #available(iOS 8.0, *) {
			let notificationSettings: UIUserNotificationSettings = UIApplication.shared.currentUserNotificationSettings ?? UIUserNotificationSettings(types: UIUserNotificationType(), categories: nil)
			if notificationSettings.types == UIUserNotificationType() {
				if let lastDefaultActionTapped = self.lastDefaultActionTapped {
					let now = Date()
					
					if now.timeIntervalSince(lastDefaultActionTapped) < 3 {
						let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
						UIApplication.shared.openURL(settingsURL!)
						self.stopTimer()
						return
					}
				}
				self.lastDefaultActionTapped = Date()
				UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:self.types, categories: categories))
				self.startTimer()
			}else{
				self.stopTimer()
				self.status = .enabled
				self.updateStatus()
			}
		}else{
			if UIApplication.shared.enabledRemoteNotificationTypes() == UIRemoteNotificationType() {
				if let lastDefaultActionTapped = self.lastDefaultActionTapped {
					let now = Date()
					
					if now.timeIntervalSince(lastDefaultActionTapped) < 3 {
						let settingsURL = URL(string: "prefs:root=NOTIFICATIONS_ID")!
						UIApplication.shared.openURL(settingsURL)
						self.stopTimer()
						return
					}
				}
				self.lastDefaultActionTapped = Date()
				UIApplication.shared.registerForRemoteNotifications(matching: legacyTypes)
				self.startTimer()
			}else{
				self.stopTimer()
				self.status = .enabled
				self.updateStatus()
			}
		}
	}
}
