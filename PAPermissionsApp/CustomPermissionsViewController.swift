//
//  CustomPermissionsViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class CustomPermissionsViewController: PAPermissionsViewController {

	let bluetoothCheck = PABluetoothPermissionsCheck()
	let locationCheck = PALocationPermissionsCheck()
	let microphoneCheck = PAMicrophonePermissionsCheck()
	let cameraCheck = PACameraPermissionsCheck()
	let notificationsCheck = PANotificationsPermissionsCheck()
	let customCheck = PACustomPermissionsCheck()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Custom settings
		self.locationCheck.requestAlwaysAuthorization = true
		
		
		let permissions = [PAPermissionsItem.itemForType(.Bluetooth, reason: "Required to connect with your cool device")!,
						   PAPermissionsItem.itemForType(.Location, reason: "Required to locate yourself")!,
						   PAPermissionsItem.itemForType(.Microphone, reason: "Required to hear your beautiful voice")!,
						   PAPermissionsItem.itemForType(.Notifications, reason: "Required to send you great updates")!,
						   PAPermissionsItem.itemForType(.Camera, reason: "Required to shoot awesome photos")!,
						   PAPermissionsItem(type: .Custom, identifier: "my-custom-permission", title: "Custom Option", reason: "Optional", icon: UIImage(named: "pa_checkmark_icon.png")!)]
		
		let handlers = [PAPermissionsType.Bluetooth.rawValue: self.bluetoothCheck,
						PAPermissionsType.Location.rawValue: self.locationCheck,
						PAPermissionsType.Microphone.rawValue: self.microphoneCheck,
						PAPermissionsType.Camera.rawValue: self.cameraCheck,
						PAPermissionsType.Notifications.rawValue: self.notificationsCheck,
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
