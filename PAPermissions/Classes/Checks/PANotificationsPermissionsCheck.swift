//
//  PANotificationsPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

public class PANotificationsPermissionsCheck: PAPermissionsCheck {

	fileprivate var _categories: AnyObject?
	
	public var categories: Set<UIMutableUserNotificationCategory>? {
		get {
			return self._categories as? Set<UIMutableUserNotificationCategory>
		}
		
		set(newCategories) {
			self._categories = newCategories as AnyObject?
		}
	}
	
	fileprivate var types: UIUserNotificationType = [.badge, .sound, .alert]

	fileprivate var lastDefaultActionTapped: Date?
	
	fileprivate var timer: Timer!
	
	public override init() {
		super.init()
		self.types = [.badge, .sound, .alert]
	}
	
	@objc public override func checkStatus() {
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
	
	
	
	public override func defaultAction() {
		
		let notificationSettings: UIUserNotificationSettings = UIApplication.shared.currentUserNotificationSettings ?? UIUserNotificationSettings(types: UIUserNotificationType(), categories: nil)
		if notificationSettings.types == UIUserNotificationType() {
			if let lastDefaultActionTapped = self.lastDefaultActionTapped {
				let now = Date()
				
				if now.timeIntervalSince(lastDefaultActionTapped) < 3 {
					self.stopTimer()
					self.openSettings()
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
	}
}
