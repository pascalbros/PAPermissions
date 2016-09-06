//
//  ViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let bluetoothCheck = PABluetoothPermissionsCheck()
	let locationCheck = PALocationPermissionsCheck()
	let microphoneCheck = PAMicrophonePermissionsCheck()
	let cameraCheck = PACameraPermissionsCheck()
	let notificationsCheck = PANotificationsPermissionsCheck()
	
	let customCheck = PACustomPermissionsCheck()
	
	@IBAction func didShowPermissions(sender: AnyObject) {
		
		let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CustomPermissionsViewController")
		self.presentViewController(controller!, animated: true, completion: nil)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

