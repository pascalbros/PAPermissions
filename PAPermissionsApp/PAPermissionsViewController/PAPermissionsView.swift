//
//  PAPermissionsListView.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//
import UIKit


protocol PAPermissionsViewDataSource {
	func permissionsView(view: PAPermissionsView, isPermissionEnabled permission: PAPermissionsItem) -> PAPermissionsStatus
	func permissionsView(view: PAPermissionsView, checkStatus permission: PAPermissionsItem)
}

protocol PAPermissionsViewDelegate {
	func permissionsView(view: PAPermissionsView, permissionSelected permission: PAPermissionsItem)
}

enum PAPermissionsStatus: Int {
	case Disabled
	case Enabled
	case Checking
	case Unavailable
}

enum PAPermissionsType: String {
	case Bluetooth = "bluetooth"
	case Location = "location"
	case Notifications = "notifications"
	case Microphone = "microphone"
	case Camera = "camera"
	case Custom = "custom"
}

class PAPermissionsItem {
	var type: PAPermissionsType
	var identifier: String
	var title: String
	var reason: String
	var icon: UIImage
	
	init(type: PAPermissionsType, identifier: String, title: String, reason: String, icon: UIImage) {
		self.type = type
		self.identifier = identifier
		self.title = title
		self.reason = reason
		self.icon = icon
	}
	
	static func itemForType(type: PAPermissionsType, reason: String?) -> PAPermissionsItem? {
		let localReason: String = reason != nil ? reason! : ""
		switch type {
		case .Bluetooth:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Bluetooth", comment: ""), reason: localReason, icon: UIImage(named: "pa_bluetooth_icon.png")!)
		case .Location:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Location", comment: ""), reason: localReason, icon: UIImage(named: "pa_location_icon.png")!)
		case .Notifications:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Notifications", comment: ""), reason: localReason, icon: UIImage(named: "pa_notification_icon.png")!)
		case .Microphone:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Microphone", comment: ""), reason: localReason, icon: UIImage(named: "pa_microphone_icon.png")!)
		case .Camera:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Camera", comment: ""), reason: localReason, icon: UIImage(named: "pa_camera_icon.png")!)
		default:
			return nil
		}
	}
}

class PAPermissionsView: UIView, UITableViewDataSource, UITableViewDelegate {

	weak var titleLabel: UILabel!
	weak var detailsLabel: UILabel!
	weak var continueButton: UIButton!
	
	var delegate: PAPermissionsViewDelegate?
	var dataSource: PAPermissionsViewDataSource?
	
	private weak var tableView: UITableView!
	private weak var refreshControl: UIRefreshControl!
	private weak var imageView: UIImageView!
	private weak var blurEffectView: UIVisualEffectView!
	
	var permissions: [PAPermissionsItem] = Array()
	
	var backgroundImage: UIImage? {
		get {
			return self.imageView.image
		}
		
		set(image) {
			self.imageView.image = image
		}
	}
	
	var useBlurBackground: Bool {
		get {
			return self.blurEffectView != nil
		}
		
		set (use) {
			if use {
				if !self.useBlurBackground {
					let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
					let blurEffectView = UIVisualEffectView(effect: blurEffect)
					blurEffectView.frame = self.bounds
					blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
					self.blurEffectView = blurEffectView
					self.insertSubview(self.blurEffectView, aboveSubview: self.imageView)
				}
			}else{
				if self.useBlurBackground && self.blurEffectView != nil {
					self.blurEffectView.removeFromSuperview()
					self.blurEffectView = nil
				}
			}
		}
		
	}
	
	override var tintColor: UIColor! {
		get {
			return super.tintColor
		}
		set(newTintColor) {
			super.tintColor = newTintColor
			self.updateTintColor()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func reloadPermissions() {
		self.tableView.reloadData()
	}
	
	
	//MARK: UI Methods
	
	private func updateTintColor() {
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupTableView()
		self.setupContinueButton()
		self.tableView.reloadData()
	}
	
	private func setupUI() {
		self.backgroundColor = UIColor.blackColor()
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupTableView()
		self.setupContinueButton()
		
		let horizontalSpace = 10
		let views = ["titleLabel": self.titleLabel,
					 "detailsLabel": self.detailsLabel,
					 "tableView": self.tableView,
					 "continueButton": self.continueButton]
		
		func horizontalConstraints(name: String) -> [NSLayoutConstraint]{
			return NSLayoutConstraint.constraintsWithVisualFormat(
				"H:|-\(horizontalSpace)-[\(name)]-\(horizontalSpace)-|",
				options: .DirectionLeadingToTrailing,
				metrics: nil,
				views: views)
		}
		
		var allConstraints = [NSLayoutConstraint]()
		//"V:|-68-[titleLabel(43)]-40-[detailsLabel(22)]-15-[tableView]-10-|"
		let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"V:|-58-[titleLabel(43)]-30-[detailsLabel(22)]-15-[tableView]-10-[continueButton(30)]-20-|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints.appendContentsOf(verticalConstraints)
		allConstraints.appendContentsOf(horizontalConstraints("titleLabel"))
		allConstraints.appendContentsOf(horizontalConstraints("detailsLabel"))
		allConstraints.appendContentsOf(horizontalConstraints("tableView"))
		allConstraints.appendContentsOf(horizontalConstraints("continueButton"))
		NSLayoutConstraint.activateConstraints(allConstraints)
	}
	
	private func setupTitleLabel() {
		if self.titleLabel == nil {
			let titleLabel = UILabel()
			titleLabel.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(titleLabel)
			self.titleLabel = titleLabel
			self.titleLabel.text = "Title"
		}
		
		self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 30)
		self.titleLabel.minimumScaleFactor = 0.1
		self.titleLabel.textColor = self.tintColor
	}
	
	private func setupDetailsLabel() {
		if self.detailsLabel == nil {
			let detailsLabel = UILabel()
			detailsLabel.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(detailsLabel)
			self.detailsLabel = detailsLabel
			self.detailsLabel.text = "Details"
		}
		
		self.detailsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
		self.detailsLabel.minimumScaleFactor = 0.1
		self.detailsLabel.textColor = self.tintColor
	}
	
	private func setupTableView() {
		if self.tableView == nil {
			let tableView = UITableView(frame: CGRectZero, style: .Plain)
			tableView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(tableView)
			self.tableView = tableView
			self.tableView.backgroundColor = UIColor.clearColor()
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.tableView.registerClass(PAPermissionsTableViewCell.self, forCellReuseIdentifier: "permission-item")
			self.tableView.tableFooterView = UIView()
			
			let refreshControl = UIRefreshControl()
			refreshControl.addTarget(self, action: #selector(PAPermissionsView.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
			tableView.addSubview(refreshControl)
			self.refreshControl = refreshControl
		}
		refreshControl.tintColor = self.tintColor

	}
	
	@objc private func refresh(sender:UIRefreshControl) {
		sender.endRefreshing()
		for permission in self.permissions {
			self.dataSource?.permissionsView(self, checkStatus: permission)
		}
	}
	
	private func setupContinueButton() {
		if self.continueButton == nil {
			let continueButton = UIButton(type: .System)
			continueButton.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(continueButton)
			self.continueButton = continueButton
			self.continueButton.backgroundColor = UIColor.redColor()
		}
		self.continueButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
		self.continueButton.titleLabel?.minimumScaleFactor = 0.1
		self.continueButton.setTitle(NSLocalizedString("Continue", comment: ""), forState: .Normal)
		self.continueButton.setTitleColor(self.tintColor, forState: .Normal)
		self.continueButton.backgroundColor = UIColor.clearColor()
	}
	
	private func setupImageView() {
		if self.imageView == nil {
			let imageView = UIImageView()
			imageView.contentMode = .ScaleAspectFill
			self.addSubview(imageView)
			self.imageView = imageView
			self.imageView.backgroundColor = UIColor.clearColor()
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": imageView]))
			imageView.superview!.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": imageView]))
		}
	}
	
	
	//MARK: Table View Methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.permissions.count
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("permission-item", forIndexPath: indexPath) as! PAPermissionsTableViewCell
		let item = self.permissions[indexPath.row]
		cell.didSelectItem = {selectedPermission in
			if let delegate = self.delegate {
				delegate.permissionsView(self, permissionSelected: selectedPermission)
			}
		}
		cell.permissionStatus = self.dataSource!.permissionsView(self, isPermissionEnabled: item)
		cell.tintColor = self.tintColor
		cell.selectionStyle = .None
		cell.titleLabel.text = item.title
		cell.detailsLabel.text = item.reason
		cell.iconImageView.image = item.icon.imageWithRenderingMode(.AlwaysTemplate)
		cell.permission = item
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 50
	}
}
