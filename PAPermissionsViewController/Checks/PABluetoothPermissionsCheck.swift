//
//  PAPermissionsChecker.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//
import UIKit
import CoreBluetooth

class PABluetoothPermissionsCheck: PAPermissionsCheck, CBCentralManagerDelegate {
	
	var managerBLE: CBCentralManager?
	override func checkStatus() {
		self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: nil)
	}
	
	override func defaultAction() {
		if #available(iOS 9, *) {
			let url = NSURL(string: "prefs:root=Bluetooth")!
			UIApplication.sharedApplication().openURL(url)
		} else {
			let url = NSURL(string: "prefs:root=General&path=Bluetooth")!
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	func centralManagerDidUpdateState(central: CBCentralManager) {
		let currentStatus = self.status

		switch managerBLE!.state
		{
		case CBCentralManagerState.PoweredOff:
			self.status = .Disabled
		case CBCentralManagerState.PoweredOn:
			self.status = .Enabled
		case CBCentralManagerState.Unsupported:
			self.status = .Unavailable
		case CBCentralManagerState.Resetting:
			self.status = .Checking
		case CBCentralManagerState.Unauthorized:
			self.status = .Disabled
		case CBCentralManagerState.Unknown:
			self.status = .Unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
}
