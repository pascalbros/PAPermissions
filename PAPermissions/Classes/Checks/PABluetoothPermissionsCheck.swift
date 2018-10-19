//
//  PAPermissionsChecker.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//
import UIKit
import CoreBluetooth

public class PABluetoothPermissionsCheck: PAPermissionsCheck, CBCentralManagerDelegate {
	
	var managerBLE: CBCentralManager?
	public override func checkStatus() {
		self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: nil)
	}
	
	public override func defaultAction() {
		self.managerBLE = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
	}
	
	public func centralManagerDidUpdateState(_ central: CBCentralManager) {
		let currentStatus = self.status

		switch managerBLE!.state
		{
		case .poweredOff:
			self.status = .disabled
		case .poweredOn:
			self.status = .enabled
		case .unsupported:
			self.status = .unavailable
		case .resetting:
			self.status = .checking
		case .unauthorized:
			self.status = .disabled
		case .unknown:
			self.status = .unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
}
