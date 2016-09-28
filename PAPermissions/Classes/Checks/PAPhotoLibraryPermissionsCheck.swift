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
        
        if #available(iOS 8.0, *) {
            self.updatePermissions(status: PHPhotoLibrary.authorizationStatus())
        } else {
            self.status = .unavailable
        }
        
        if self.status != currentStatus {
            self.updateStatus()
        }
    }
    
    public override func defaultAction() {
        
        if #available(iOS 8.0, *) {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                self.updatePermissions(status: status)
                self.updateStatus()
            })
        } else {
            // Photo Library Only available above iOS 8
        }
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
