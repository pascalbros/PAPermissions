//
//  ViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit
import PAPermissions

class ViewController: UIViewController {
	
	@IBAction func didShowPermissions(_ sender: AnyObject) {
		
		let controller = self.storyboard?.instantiateViewController(withIdentifier: "CustomPermissionsViewController")
		self.present(controller!, animated: true, completion: nil)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

