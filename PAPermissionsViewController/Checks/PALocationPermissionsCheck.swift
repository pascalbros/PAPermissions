//
//  PALocationPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import CoreLocation
import UIKit

class PALocationPermissionsCheck: PAPermissionsCheck, CLLocationManagerDelegate {
	
	var requestAlwaysAuthorization = false
	private var locationManager = CLLocationManager()
	
	override func checkStatus() {
		locationManager.delegate = self
		self.updateAuthorization()
	}
	
	override func defaultAction() {
		
		if #available(iOS 8.0, *) {
			if CLLocationManager.authorizationStatus() == .Denied {
				let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
				UIApplication.sharedApplication().openURL(settingsURL!)
			}else{
				if self.requestAlwaysAuthorization {
					self.locationManager.requestAlwaysAuthorization()
				}else{
					self.locationManager.requestWhenInUseAuthorization()
				}
				self.updateStatus()
			}
		}else{
			if CLLocationManager.authorizationStatus() == .Denied {
				let settingsURL = NSURL(string: "prefs:root=LOCATION_SERVICES")
				UIApplication.sharedApplication().openURL(settingsURL!)
			}else{
				self.status = .Enabled
				self.updateStatus()
			}
		}
	}
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		self.updateAuthorization()
	}
	
	private func updateAuthorization() {
		let currentStatus = self.status

		if CLLocationManager.locationServicesEnabled() {
			switch(CLLocationManager.authorizationStatus()) {
			case .NotDetermined, .Restricted, .Denied:
				self.status = PAPermissionsStatus.Disabled
			case .AuthorizedAlways, .AuthorizedWhenInUse:
				self.status = PAPermissionsStatus.Enabled
			}
		} else {
			self.status = PAPermissionsStatus.Disabled
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
}
