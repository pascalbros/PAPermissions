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
    let motionFitnessCheck = PAMotionFitnessPermissionsCheck()
	let cameraCheck = PACameraPermissionsCheck()
    let photoLibraryCheck = PAPhotoLibraryPermissionsCheck()
	lazy var notificationsCheck : PAPermissionsCheck = {
		return PAUNNotificationPermissionsCheck()
	}()
	let customCheck = PACustomPermissionsCheck()

	let calendarCheck = PACalendarPermissionsCheck()
	let reminderCheck = PARemindersPermissionsCheck()
	let contactsCheck  : PAPermissionsCheck = {
		return PACNContactsPermissionsCheck()
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
			PAPermissionsItem.itemForType(.photoLibrary, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem.itemForType(.notifications, reason: "Required to send you great updates")!,
			PAPermissionsItem.itemForType(.camera, reason: PAPermissionDefaultReason)!,
			PAPermissionsItem(type: .custom, identifier: "my-custom-permission", title: "Custom Option", reason: "Optional", icon: UIImage(named: "pa_checkmark_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: true)]

		let handlers = [
			PAPermissionsType.calendar.rawValue: self.calendarCheck,
			PAPermissionsType.reminders.rawValue: self.reminderCheck,
			PAPermissionsType.contacts.rawValue: self.contactsCheck,
			PAPermissionsType.bluetooth.rawValue: self.bluetoothCheck,
			PAPermissionsType.location.rawValue: self.locationCheck,
			PAPermissionsType.microphone.rawValue: self.microphoneCheck,
			PAPermissionsType.motionFitness.rawValue: self.motionFitnessCheck,
			PAPermissionsType.photoLibrary.rawValue: self.photoLibraryCheck,
			PAPermissionsType.camera.rawValue: self.cameraCheck,
			PAPermissionsType.notifications.rawValue: self.notificationsCheck,
			"my-custom-permission": self.customCheck]

		self.setupData(permissions, handlers: handlers)
		
		//////Colored background//////
		//self.tintColor = UIColor.white
		//self.backgroundColor = UIColor(red: 245.0/255.0, green: 94.0/255.0, blue: 78.0/255.0, alpha: 1.0)
		
		//////Blur background//////
		//self.tintColor = UIColor.white
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
