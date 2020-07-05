//
//  PAPermissionsCheck.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 06/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

public protocol PAPermissionsCheckDelegate {
	func permissionCheck(_ permissionCheck: PAPermissionsCheck, didCheckStatus: PAPermissionsStatus);
}

open class PAPermissionsCheck: NSObject {
	
	public var delegate: PAPermissionsCheckDelegate?
	public var status: PAPermissionsStatus = PAPermissionsStatus.checking
	public var canBeDisabled = false
	open func checkStatus() {
		fatalError("checkStatus has not been implemented")
	}
	
	open func defaultAction() {
		fatalError("defaultAction has not been implemented")
	}
	
	public func updateStatus() {
		if let d = self.delegate {
			DispatchQueue.main.async{
				d.permissionCheck(self, didCheckStatus: self.status)
			}
		}
	}
	
	public func openSettings() {
		if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
			UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
		}
	}
}
