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

public class PAPermissionsCheck: NSObject {
	
	var delegate: PAPermissionsCheckDelegate?
	var status: PAPermissionsStatus = PAPermissionsStatus.checking
	func checkStatus() {
		fatalError("checkStatus has not been implemented")
	}
	
	func defaultAction() {
		fatalError("defaultAction has not been implemented")
	}
	
	func updateStatus() {
		if let d = self.delegate {
			DispatchQueue.main.async{
				d.permissionCheck(self, didCheckStatus: self.status)
			}
		}
	}
}
