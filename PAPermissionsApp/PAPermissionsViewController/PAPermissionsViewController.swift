//
//  PAPermissionsViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

protocol PAPermissionsViewControllerDelegate {
	func permissionsViewControllerDidContinue(viewController: PAPermissionsViewController)
}

class PAPermissionsViewController: UIViewController, PAPermissionsViewDelegate, PAPermissionsViewDataSource, PAPermissionsCheckDelegate {
	
	var delegate: PAPermissionsViewControllerDelegate?
	private var permissionHandlers: [String: PAPermissionsCheck] = Dictionary()
	private weak var permissionsView: PAPermissionsView!
	
	var titleText: String? {
		get {
			return self.permissionsView.titleLabel.text
		}
		
		set(text) {
			self.permissionsView.titleLabel.text = text
		}
		
	}
	
	var detailsText: String? {
		get {
			return self.permissionsView.detailsLabel.text
		}
		
		set(text) {
			self.permissionsView.detailsLabel.text = text
		}
		
	}
	
	var tintColor: UIColor! {
		get {
			return self.permissionsView.tintColor
		}
		
		set(newTintColor) {
			self.permissionsView.tintColor = newTintColor
		}
	}
	
	var backgroundColor: UIColor! {
		get {
			return self.permissionsView.backgroundColor
		}
		
		set(newBackgroundColor) {
			self.permissionsView.backgroundColor = newBackgroundColor
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if self.permissionHandlers.count != 0 {
			self.permissionsView.reloadPermissions()
		}
	}
	
	private func setupUI() {
		let mainView = PAPermissionsView(frame: CGRect(origin: CGPointZero, size: CGSizeZero));
		mainView.delegate = self
		mainView.dataSource = self
		self.view.addSubview(mainView)
		self.permissionsView = mainView
		
		mainView.translatesAutoresizingMaskIntoConstraints = false
		mainView.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": mainView]))
		mainView.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": mainView]))
		mainView.backgroundColor = UIColor.whiteColor()
		mainView.continueButton.addTarget(self, action: #selector(PAPermissionsViewController.didContinue), forControlEvents: .TouchUpInside)
	}
	
	func setupData(permissions: [PAPermissionsItem], handlers:[String: PAPermissionsCheck]) {
		
		assert(permissions.count == handlers.count, "Count mismatch")
		
		self.permissionsView.permissions = permissions
		self.permissionHandlers = handlers
		
		for permission in self.permissionHandlers.values {
			permission.delegate = self
			permission.checkStatus()
		}
	}
	
	@objc private func didContinue() {
		if let delegate = self.delegate {
			delegate.permissionsViewControllerDidContinue(self)
		}else{
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	func permissionsView(view: PAPermissionsView, checkStatus permission: PAPermissionsItem) {
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			permissionsCheck.checkStatus()
		}else{
			//Custom code, should not reach here
		}
	}
	
	func permissionsView(view: PAPermissionsView, permissionSelected permission: PAPermissionsItem) {
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			permissionsCheck.defaultAction()
		}else{
			//Custom code, should not reach here
		}
	}
	
	func permissionsView(view: PAPermissionsView, isPermissionEnabled permission: PAPermissionsItem) -> PAPermissionsStatus {
		
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			return permissionsCheck.status
		}else{
			//Custom code, should not reach here
			return .Unavailable
		}
	}
	
	func permissionCheck(permissionCheck: PAPermissionsCheck, didCheckStatus: PAPermissionsStatus) {
		self.permissionsView.reloadPermissions()
	}
	
}
