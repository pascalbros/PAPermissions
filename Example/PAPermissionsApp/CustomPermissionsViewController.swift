//
//  CustomPermissionsViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import PAPermissions

class CustomPermissionsViewController: PAPermissionsViewController {

	let bluetoothCheck = PABluetoothPermissionsCheck()
	let locationCheck = PALocationPermissionsCheck()
	let microphoneCheck = PAMicrophonePermissionsCheck()
    let motionFitnessCheck = PAMotionFitnessCheck()
	let cameraCheck = PACameraPermissionsCheck()
	lazy var notificationsCheck : PAPermissionsCheck = {
		if #available(iOS 10.0, *) {
			return PAUNNotificationPermissionsCheck()
		} else {
			return PANotificationsPermissionsCheck()
		}
	}()
	let customCheck = PACustomPermissionsCheck()

	let calendarCheck = PACalendarPermissionsCheck()
	let reminderCheck = PARemindersPermissionsCheck()
	let contactsCheck  : PAPermissionsCheck = {
		if #available(iOS 9.0, *) {
			return PACNContactsPermissionsCheck()
		} else {
			return PAABAddressBookCheck()
		}
	}()


	override func viewDidLoad() {
		super.viewDidLoad()

		let permissions = [
			PAPermissionsItem.itemForType(.calendar, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.reminders, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.contacts, reason: PAPermissionDefaultReason)!,

			PAPermissionsItem.itemForType(.bluetooth, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.location, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.microphone, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.motionFitness, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.notifications, reason: "Required to send you great updates")!,
			PAPermissionsItem.itemForType(.camera, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem(type: .custom, identifier: "my-custom-permission", title: "Custom Option", reason: "Optional", icon: UIImage(named: "pa_checkmark_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!)]

		let handlers = [
			PAPermissionsType.calendar.rawValue: self.calendarCheck,
			PAPermissionsType.reminders.rawValue: self.reminderCheck,
			PAPermissionsType.contacts.rawValue: self.contactsCheck,
			PAPermissionsType.bluetooth.rawValue: self.bluetoothCheck,
			PAPermissionsType.location.rawValue: self.locationCheck,
			PAPermissionsType.microphone.rawValue: self.microphoneCheck,
			PAPermissionsType.motionFitness.rawValue: self.motionFitnessCheck,
			PAPermissionsType.camera.rawValue: self.cameraCheck,
			PAPermissionsType.notifications.rawValue: self.notificationsCheck,
			"my-custom-permission": self.customCheck]

		self.setupData(permissions, handlers: handlers)
		//self.tintColor = UIColor.whiteColor()
		//self.backgroundColor = UIColor(red: 245.0/255.0, green: 94.0/255.0, blue: 78.0/255.0, alpha: 1.0)
		//self.backgroundImage = UIImage(named: "background.jpg")
		//self.useBlurBackground = true
		self.titleText = "My Awesome App"
		self.detailsText = "Please enable the following"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
