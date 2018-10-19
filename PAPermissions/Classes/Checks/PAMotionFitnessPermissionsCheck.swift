//
//  PAMotionFitnessPermissionsCheck.swift
//  Pods
//
//  Created by Joseph Blau on 9/24/16.
//
//

import UIKit
import CoreMotion

public class PAMotionFitnessPermissionsCheck: PAPermissionsCheck {
    
    let motionActivityManager = CMMotionActivityManager()
    
    public override func checkStatus() {
        let currentStatus = self.status
        
        if CMMotionActivityManager.isActivityAvailable() {
            self.status = .disabled
        } else {
            self.status = .unavailable
        }
        
        if self.status != currentStatus {
            self.updateStatus()
        }
    }
    
    public override func defaultAction() {
		self.motionActivityManager.queryActivityStarting(from: Date(), to: Date(), to: OperationQueue.main, withHandler: { (motionActivity, error) in
			
			self.status = motionActivity == nil ? .disabled : .enabled
			
			if let e = error as NSError? {
				if e.code == Int(CMErrorNotAuthorized.rawValue) {
					self.status = .denied
					self.openSettings()
				}
			}
			
			self.motionActivityManager.stopActivityUpdates()
			self.updateStatus()
		})
    }
}
