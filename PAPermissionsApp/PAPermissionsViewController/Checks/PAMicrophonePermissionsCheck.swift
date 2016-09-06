//
//  PAMicrophonePermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import AVFoundation

class PAMicrophonePermissionsCheck: PAPermissionsCheck {

	let audioSession = AVAudioSession.sharedInstance()
	
	override func checkStatus() {
		let currentStatus = self.status

		if AVAudioSession.sharedInstance().inputAvailable {
			if AVAudioSession.sharedInstance().recordPermission() == .Granted {
				self.status = .Enabled
			}else{
				self.status = .Disabled
			}
		}else{
			self.status = .Unavailable
		}
		
		if self.status != currentStatus {
			self.updateStatus()
		}
	}
	
	override func defaultAction() {
		if AVAudioSession.sharedInstance().recordPermission() == .Denied {
			let settingsURL = NSURL(string: UIApplicationOpenSettingsURLString)
			UIApplication.sharedApplication().openURL(settingsURL!)
		}else{
			AVAudioSession.sharedInstance().requestRecordPermission { (result) in
				if result {
					self.status = .Enabled
				}else{
					self.status = .Disabled
				}
				
				self.updateStatus()
			}
		}
	}
}
