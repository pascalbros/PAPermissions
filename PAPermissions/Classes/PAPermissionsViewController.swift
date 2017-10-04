//
//  PAPermissionsViewController.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

public enum Constants {
	struct InfoPlistKeys {
		static let locationWhenInUse        = "NSLocationWhenInUseUsageDescription"
		static let locationAlways           = "NSLocationAlwaysUsageDescription"
		static let calendar                 = "NSCalendarsUsageDescription"
		static let reminders                = "NSRemindersUsageDescription"
		static let contacts                 = "NSContactsUsageDescription"
		static let camera 					= "NSCameraUsageDescription"
		static let microphone				= "NSMicrophoneUsageDescription"
		static let motionFitness            = "NSMotionUsageDescription"
		static let photoLibrary             = "NSPhotoLibraryUsageDescription"
		static let mediaLibrary             = "NSAppleMusicUsageDescription"
		static let bluetooth				= "NSBluetoothPeripheralUsageDescription"
	}
}


public protocol PAPermissionsViewControllerDelegate {
	func permissionsViewControllerDidContinue(_ viewController: PAPermissionsViewController)
}

open class PAPermissionsViewController: UIViewController, PAPermissionsViewDelegate, PAPermissionsViewDataSource, PAPermissionsCheckDelegate {
	
	public var delegate: PAPermissionsViewControllerDelegate?
	fileprivate var permissionHandlers: [String: PAPermissionsCheck] = Dictionary()
	fileprivate weak var permissionsView: PAPermissionsView!

	public var titleText: String? {
		get {
			return self.permissionsView.titleLabel.text
		}
		
		set(text) {
			self.permissionsView.titleLabel.text = text
		}
		
	}
	
	public var detailsText: String? {
		get {
			return self.permissionsView.detailsLabel.text
		}
		
		set(text) {
			self.permissionsView.detailsLabel.text = text
		}
		
	}
	
	public var tintColor: UIColor! {
		get {
			return self.permissionsView.tintColor
		}
		
		set(newTintColor) {
			self.permissionsView.tintColor = newTintColor
		}
	}
	
	public var backgroundColor: UIColor! {
		get {
			return self.permissionsView.backgroundColor
		}
		
		set(newBackgroundColor) {
			self.permissionsView.backgroundColor = newBackgroundColor
		}
	}
	
	public var backgroundImage: UIImage? {
		get {
			return self.permissionsView.backgroundImage
		}
		
		set (newImage) {
			self.permissionsView.backgroundImage = newImage
		}
	}
	
	@available (iOS 8, *)
	public var useBlurBackground: Bool {
		get {
			return self.permissionsView.useBlurBackground
		}
		
		set (newBlurBackground) {
			self.permissionsView.useBlurBackground = newBlurBackground
		}
	}

	open override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
	}
	
	open override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if self.permissionHandlers.count != 0 {
			self.permissionsView.reloadPermissions()
		}
	}
	
	fileprivate func setupUI() {
		let mainView = PAPermissionsView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero));
		mainView.delegate = self
		mainView.dataSource = self
		self.view.addSubview(mainView)
		self.permissionsView = mainView
		
		mainView.translatesAutoresizingMaskIntoConstraints = false
		mainView.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: [], metrics: nil, views: ["subview": mainView]))
		mainView.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: [], metrics: nil, views: ["subview": mainView]))
		mainView.backgroundColor = UIColor.white
		mainView.continueButton.addTarget(self, action: #selector(PAPermissionsViewController.didContinue), for: .touchUpInside)
	}
	
	public func setupData(_ permissions: [PAPermissionsItem], handlers:[String: PAPermissionsCheck]) {
		
		assert(permissions.count == handlers.count, "Count mismatch")
		
		self.permissionsView.permissions = permissions
		self.permissionHandlers = handlers
		
		for permission in self.permissionHandlers.values {
			permission.delegate = self
			permission.checkStatus()
		}
	}
	
	@objc fileprivate func didContinue() {
		if let delegate = self.delegate {
			delegate.permissionsViewControllerDidContinue(self)
		}else{
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func permissionsView(_ view: PAPermissionsView, checkStatus permission: PAPermissionsItem) {
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			permissionsCheck.checkStatus()
		}else{
			//Custom code, should not reach here
		}
	}
	
	func permissionsView(_ view: PAPermissionsView, permissionSelected permission: PAPermissionsItem) {
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			permissionsCheck.defaultAction()
		}else{
			//Custom code, should not reach here
		}
	}
	
	func permissionsView(_ view: PAPermissionsView, isPermissionEnabled permission: PAPermissionsItem) -> PAPermissionsStatus {
		
		if let permissionsCheck = self.permissionHandlers[permission.identifier] {
			return permissionsCheck.status
		}else{
			//Custom code, should not reach here
			return .unavailable
		}
	}
	
	public func permissionCheck(_ permissionCheck: PAPermissionsCheck, didCheckStatus: PAPermissionsStatus) {
		self.permissionsView.reloadPermissions()
	}
	
}
