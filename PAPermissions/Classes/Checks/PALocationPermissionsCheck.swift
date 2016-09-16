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
		
		if #available(iOS 8.0, *) {
			if CLLocationManager.authorizationStatus() == .denied {
				let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
				UIApplication.shared.openURL(settingsURL!)
			}else{
				if self.requestAlwaysAuthorization {
					self.locationManager.requestAlwaysAuthorization()
				}else{
					self.locationManager.requestWhenInUseAuthorization()
				}
				self.updateStatus()
			}
		}else{
			if CLLocationManager.authorizationStatus() == .denied {
				let settingsURL = URL(string: "prefs:root=LOCATION_SERVICES")
				UIApplication.shared.openURL(settingsURL!)
			}else{
				self.status = .enabled
				self.updateStatus()
			}
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
			}
		} else {
			self.status = PAPermissionsStatus.disabled
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
}
