//
//  PAPhotoLibraryPermissionsCheck.swift
//  Pods
//
//  Created by Joseph Blau on 9/24/16.
//
//

import UIKit
import Photos

public class PAPhotoLibraryPermissionsCheck: PAPermissionsCheck {
    
    public override func checkStatus() {
        let currentStatus = self.status
		self.updatePermissions(status: PHPhotoLibrary.authorizationStatus())
        
        if self.status != currentStatus {
            self.updateStatus()
        }
    }
    
    public override func defaultAction() {
		PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
			self.updatePermissions(status: status)
			self.updateStatus()
		})
    }
    
    private func updatePermissions(status: PHAuthorizationStatus) {
		
		let oldStatus = self.status
		
        switch status {
        case .authorized: self.status =
			.enabled
		case .denied:
			self.status = .denied
		case .notDetermined:
			self.status = .disabled
        case .restricted: self.status = .unavailable
        }
		
		if oldStatus == .denied && self.status == .denied {
			self.openSettings()
		}
    }
}
