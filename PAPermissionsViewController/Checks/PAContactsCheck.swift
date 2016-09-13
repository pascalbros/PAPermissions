//
//  PAContactsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 13/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import AddressBook
import Contacts


class PAContactsCheck: PAPermissionsCheck {

	private let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
	
	private var _contactStore: Any!
	
	@available(iOS 9.0, *)
	private var contactStore: CNContactStore {
		get {
			return self._contactStore as! CNContactStore
		}
		
		set(newContactStore) {
			self._contactStore = newContactStore
		}
	}
	
	override init() {
		super.init()
		if #available(iOS 9.0, *) {
			self.contactStore = CNContactStore()
		}
	}
	override func checkStatus() {
		if #available(iOS 9.0, *) {
			self._checkStatus()
		}else{
			self.iOS7CheckStatus()
		}
	}
	
	private func iOS7CheckStatus() {
		let authorizationStatus = ABAddressBookGetAuthorizationStatus()
		let currentStatus = self.status
		
		switch authorizationStatus {
		case .Denied:
			self.status = .Denied
		case .NotDetermined:
			self.status = .Disabled
		case .Authorized:
			self.status = .Enabled
		default:
			self.status = .Unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
	
	@available (iOS 9.0, *)
	private func _checkStatus() {
		let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
		
		switch authorizationStatus {
		case .Denied:
			self.status = .Denied
		case .NotDetermined:
			self.status = .Disabled
		case .Authorized:
			self.status = .Enabled
		default:
			self.status = .Unavailable
		}
	}
	
	
	override func defaultAction() {
		
		if #available(iOS 9.0, *) {
			self._defaultAction()
		}else {
			self.iOS7DefaultAction()
		}
	}
	
	@available (iOS 9, *)
	private func _defaultAction() {
		if self.status == .Denied {
			let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
			UIApplication.sharedApplication().openURL(settingsURL!)
		}else if self.status == .Disabled {
			self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
				if access {
					self.status = .Enabled
				} else {
					self._checkStatus()
				}
				self.updateStatus()
			})
		}else if self.status == .Denied {
			let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
			UIApplication.sharedApplication().openURL(settingsURL!)
		}
	}
	
	private func iOS7DefaultAction() {
		if self.status == .Denied {
			
			var URL = "prefs:root=General"
			if #available(iOS 8.0, *) {
				URL = UIApplicationOpenSettingsURLString
			}
			let settingsURL = NSURL(string: URL)
			UIApplication.sharedApplication().openURL(settingsURL!)
			
		}else if self.status == .Disabled {
			ABAddressBookRequestAccessWithCompletion(addressBookRef) {
				(granted: Bool, error: CFError!) in
				if !granted {
					self.status = .Denied
				} else {
					self.status = .Enabled
				}
				self.updateStatus()
			}
		}
	}
}
