//
//  PAMediaLibraryPermissionsCheck.swift
//  Pods
//
//  Created by Tom Major on 10/04/17.
//  template taken from PAPhotoLibraryPermissionsCheck.swift
//
//

import UIKit
import MediaPlayer

public class PAMediaLibraryPermissionsCheck: PAPermissionsCheck {
    
    public override func checkStatus() {
        let currentStatus = self.status
        
        if #available(iOS 9.3, *) {
            self.updatePermissions(status: MPMediaLibrary.authorizationStatus())
        } else {
            self.status = .unavailable
        }
        
        if self.status != currentStatus {
            self.updateStatus()
        }
    }
    
    public override func defaultAction() {
        
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization({ (result) in
                self.updatePermissions(status: result)
                self.updateStatus()
            })
        } else {
            // Media Library permission only available with iOS 9.3 and above
        }
    }
    
    @available(iOS 9.3, *)
    private func updatePermissions(status: MPMediaLibraryAuthorizationStatus) {
		
		let oldStatus = self.status
		
        switch status {
        case .authorized:
            self.status = .enabled
		case .denied:
			self.status = .denied
		case .notDetermined:
			self.status = .disabled
        case .restricted:
            self.status = .unavailable
        }
		
		if oldStatus == .denied && self.status == .denied {
			self.openSettings()
		}
    }
    
}
