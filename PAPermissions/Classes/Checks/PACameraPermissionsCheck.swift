//
//  PACameraPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import AVFoundation
import UIKit

public class PACameraPermissionsCheck: PAPermissionsCheck {

	var mediaType = AVMediaType.video
	
	public override func checkStatus() {
		let currentStatus = self.status

		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
			let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
			switch authStatus {
			
			case .authorized:
				self.status = .enabled
			case .denied:
				self.status = .disabled
			case .notDetermined:
				self.status = .disabled
			default:
				self.status = .unavailable
			}
		}else{
			self.status = .unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
	
	public override func defaultAction() {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
			let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
			if authStatus == .denied {
				self.openSettings()
			}else{
				AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (result) in
					if result {
						self.status = .enabled
					}else{
						self.status = .disabled
					}
				})
				self.updateStatus();
			}
		}
	}
}
