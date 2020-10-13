//
//  PALocationPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import CoreLocation
import UIKit

public class PALocationPermissionsCheck: PAPermissionsCheck, CLLocationManagerDelegate {
	
	var requestAlwaysAuthorization : Bool {
		return Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.locationAlways) == nil ? false:true
	}
	fileprivate var locationManager = CLLocationManager()
	
	public override func checkStatus() {
		locationManager.delegate = self
		self.updateAuthorization()
	}
	
	public override func defaultAction() {
		if CLLocationManager.authorizationStatus() == .denied {
			self.openSettings()
		}else{
			if self.requestAlwaysAuthorization {
				self.locationManager.requestAlwaysAuthorization()
			}else{
				self.locationManager.requestWhenInUseAuthorization()
			}
			self.updateStatus()
		}
	}
	
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		self.updateAuthorization()
	}
	
	fileprivate func updateAuthorization() {
		let currentStatus = self.status

		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .notDetermined, .restricted, .denied:
				self.status = PAPermissionsStatus.disabled
			case .authorizedAlways, .authorizedWhenInUse:
				self.status = PAPermissionsStatus.enabled
			@unknown default:
				self.status = PAPermissionsStatus.disabled
			}
		} else {
			self.status = PAPermissionsStatus.disabled
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
}
