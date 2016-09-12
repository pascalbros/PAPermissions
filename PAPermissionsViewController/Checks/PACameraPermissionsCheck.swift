//
//  PACameraPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import AVFoundation
import UIKit

class PACameraPermissionsCheck: PAPermissionsCheck {

	var mediaType = AVMediaTypeVideo
	
	override func checkStatus() {
		let currentStatus = self.status

		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
			let authStatus = AVCaptureDevice.authorizationStatusForMediaType(mediaType)
			switch authStatus {
			
			case .Authorized:
				self.status = .Enabled
			case .Denied:
				self.status = .Disabled
			case .NotDetermined:
				self.status = .Disabled
			default:
				self.status = .Unavailable
			}
		}else{
			self.status = .Unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
	
	override func defaultAction() {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
			
			if #available(iOS 8.0, *) {
				let authStatus = AVCaptureDevice.authorizationStatusForMediaType(mediaType)
				if authStatus == .Denied {
					let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
					UIApplication.sharedApplication().openURL(settingsURL!)
				}else{
					AVCaptureDevice.requestAccessForMediaType(mediaType, completionHandler: { (result) in
						if result {
							self.status = .Enabled
						}else{
							self.status = .Disabled
						}
					})
					self.updateStatus();
				}
			}else{
				//Camera access should be always active on iOS 7
			}
		}
		
		
	}
}
