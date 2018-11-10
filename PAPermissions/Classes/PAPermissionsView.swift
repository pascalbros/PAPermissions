//
//  PAPermissionsListView.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//
import UIKit

public let PAPermissionDefaultReason = "PAPermissionDefaultReason"

protocol PAPermissionsViewDataSource {
	func permissionsView(_ view: PAPermissionsView, isPermissionEnabled permission: PAPermissionsItem) -> PAPermissionsStatus
	func permissionsView(_ view: PAPermissionsView, checkStatus permission: PAPermissionsItem)
}

protocol PAPermissionsViewDelegate {
	func permissionsView(_ view: PAPermissionsView, permissionSelected permission: PAPermissionsItem)
}

public enum PAPermissionsStatus: Int {
	case disabled
	case enabled
	case checking
	case unavailable
	case denied
}

public enum PAPermissionsType: String {
	case calendar = "calendar"
	case reminders = "reminders"
	case contacts = "contacts"
	case bluetooth = "bluetooth"
	case location = "location"
	case notifications = "notifications"
	case microphone = "microphone"
	case motionFitness = "motion fitness"
	case camera = "camera"
	case custom = "custom"
	case photoLibrary = "photo library"
	case mediaLibrary = "media library"
}

public class PAPermissionsItem {
	var type: PAPermissionsType
	var identifier: String
	var title: String
	var reason: String
	var icon: UIImage
	var canBeDisabled: Bool
	
	public init(type: PAPermissionsType, identifier: String, title: String, reason: String, icon: UIImage, canBeDisabled: Bool) {
		self.type = type
		self.identifier = identifier
		self.title = title
		self.reason = reason
		self.icon = icon
		self.canBeDisabled = canBeDisabled
	}

	public class func reasonText(_ type: PAPermissionsType) -> String {

		var key = ""

		switch type {
		case .bluetooth: key = Constants.InfoPlistKeys.bluetooth
		case .microphone: key = Constants.InfoPlistKeys.microphone
		case .camera: key = Constants.InfoPlistKeys.camera
		case .calendar: key = Constants.InfoPlistKeys.calendar
		case .reminders: key = Constants.InfoPlistKeys.reminders
		case .contacts: key = Constants.InfoPlistKeys.contacts
		case .motionFitness: key = Constants.InfoPlistKeys.motionFitness
		case .photoLibrary: key = Constants.InfoPlistKeys.photoLibrary
		case .mediaLibrary: key = Constants.InfoPlistKeys.mediaLibrary
		case .location:
			if let _ = Bundle.main.object(forInfoDictionaryKey: Constants.InfoPlistKeys.locationAlways) {
				key = Constants.InfoPlistKeys.locationAlways
			} else {
				key = Constants.InfoPlistKeys.locationWhenInUse
			}
		default:
			break
		}

		if key.isEmpty { return "" }
		return NSLocalizedString(key, tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
	}
	

	public class func itemForType(_ type: PAPermissionsType, reason: String?) -> PAPermissionsItem? {

		var localReason = ""
		if let reason = reason {
			if reason == PAPermissionDefaultReason {
				localReason = reasonText(type)
			}
			else {
				localReason = reason
			}
		}

		switch type {
		case .bluetooth:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Bluetooth", comment: ""), reason: localReason, icon: UIImage(named: "pa_bluetooth_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .location:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Location", comment: ""), reason: localReason, icon: UIImage(named: "pa_location_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .notifications:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Notifications", comment: ""), reason: localReason, icon: UIImage(named: "pa_notification_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .microphone:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Microphone", comment: ""), reason: localReason, icon: UIImage(named: "pa_microphone_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .motionFitness:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Motion Fitness", comment: ""), reason: localReason, icon: UIImage(named: "pa_motion_activity_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .camera:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Camera", comment: ""), reason: localReason, icon: UIImage(named: "pa_camera_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .calendar:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Calendar", comment: ""), reason: localReason, icon: UIImage(named: "pa_calendar_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .reminders:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Reminders", comment: ""), reason: localReason, icon: UIImage(named: "pa_reminders_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .contacts:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Contacts", comment: ""), reason: localReason, icon: UIImage(named: "pa_contacts_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .photoLibrary:
			return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Photo Library", comment: ""), reason: localReason, icon: UIImage(named: "pa_photo_library_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
		case .mediaLibrary:
            return PAPermissionsItem(type: type, identifier: type.rawValue, title: NSLocalizedString("Media Library", comment: ""), reason: localReason, icon: UIImage(named: "pa_media_library_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil)!, canBeDisabled: false)
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
	
	fileprivate weak var tableView: UITableView!
	fileprivate weak var refreshControl: UIRefreshControl!
	fileprivate weak var imageView: UIImageView!
	
	fileprivate weak var _blurEffectView: AnyObject!
	@available(iOS 8.0, *)
	fileprivate weak var blurEffectView: UIVisualEffectView? {
		get {
			return self._blurEffectView as? UIVisualEffectView
		}
		
		set(newView) {
			self._blurEffectView = newView
		}
	}
	
	var permissions: [PAPermissionsItem] = Array()
	
	var backgroundImage: UIImage? {
		get {
			return self.imageView.image
		}
		
		set(image) {
			self.imageView.image = image
		}
	}
	
	@available (iOS 8, *)
	var useBlurBackground: Bool {
		get {
			return self.blurEffectView != nil
		}
		
		set (use) {
			if use {
				if !self.useBlurBackground {
					let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
					let blurEffectView = UIVisualEffectView(effect: blurEffect)
					blurEffectView.frame = self.bounds
					blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
					self.blurEffectView = blurEffectView
					self.insertSubview(blurEffectView, aboveSubview: self.imageView)
				}
			}else{
				if self.useBlurBackground {
					if let blurEffectView = self.blurEffectView {
						blurEffectView.removeFromSuperview()
						self.blurEffectView = nil
					}
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
	
	fileprivate func updateTintColor() {
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupTableView()
		self.setupContinueButton()
		self.tableView.reloadData()
	}
	
	fileprivate func setupUI() {
		self.backgroundColor = UIColor.black
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupTableView()
		self.setupContinueButton()
		
		let horizontalSpace = 10
		let views = ["titleLabel": self.titleLabel,
					 "detailsLabel": self.detailsLabel,
					 "tableView": self.tableView,
					 "continueButton": self.continueButton] as [String : UIView]
		
		func horizontalConstraints(_ name: String) -> [NSLayoutConstraint]{
			return NSLayoutConstraint.constraints(
				withVisualFormat: "H:|-\(horizontalSpace)-[\(name)]-\(horizontalSpace)-|",
				options: [],
				metrics: nil,
				views: views)
		}
		
		var allConstraints = [NSLayoutConstraint]()
		//"V:|-68-[titleLabel(43)]-40-[detailsLabel(22)]-15-[tableView]-10-|"
		let verticalConstraints = NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-58-[titleLabel(43)]-30-[detailsLabel]-15-[tableView]-10-[continueButton(30)]-20-|",
			options: [],
			metrics: nil,
			views: views)
		allConstraints.append(contentsOf: verticalConstraints)
		allConstraints.append(contentsOf: horizontalConstraints("titleLabel"))
		allConstraints.append(contentsOf: horizontalConstraints("detailsLabel"))
		allConstraints.append(contentsOf: horizontalConstraints("tableView"))
		allConstraints.append(contentsOf: horizontalConstraints("continueButton"))
		NSLayoutConstraint.activate(allConstraints)
	}
	
	fileprivate func setupTitleLabel() {
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
	
	fileprivate func setupDetailsLabel() {
		if self.detailsLabel == nil {
			let detailsLabel = UILabel()
			detailsLabel.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(detailsLabel)
			self.detailsLabel = detailsLabel
			self.detailsLabel.text = "Details"
            // handle multi line details text
            self.detailsLabel.numberOfLines = 0
            self.detailsLabel.lineBreakMode = .byWordWrapping
		}
		
		self.detailsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
		self.detailsLabel.minimumScaleFactor = 0.1
		self.detailsLabel.textColor = self.tintColor
	}
	
	fileprivate func setupTableView() {
		if self.tableView == nil {
			let tableView = UITableView(frame: CGRect.zero, style: .plain)
			tableView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(tableView)
			self.tableView = tableView
			self.tableView.backgroundColor = UIColor.clear
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.tableView.register(PAPermissionsTableViewCell.self, forCellReuseIdentifier: "permission-item")
			self.tableView.tableFooterView = UIView()
			
			let refreshControl = UIRefreshControl()
			refreshControl.addTarget(self, action: #selector(PAPermissionsView.refresh(_:)), for: UIControl.Event.valueChanged)
			tableView.addSubview(refreshControl)
			self.refreshControl = refreshControl
		}
		refreshControl.tintColor = self.tintColor

	}
	
	@objc fileprivate func refresh(_ sender:UIRefreshControl) {
		sender.endRefreshing()
		for permission in self.permissions {
			self.dataSource?.permissionsView(self, checkStatus: permission)
		}
	}
	
	fileprivate func setupContinueButton() {
		if self.continueButton == nil {
			let continueButton = UIButton(type: .system)
			continueButton.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(continueButton)
			self.continueButton = continueButton
			self.continueButton.backgroundColor = UIColor.red
		}
		self.continueButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 14)
		self.continueButton.titleLabel?.minimumScaleFactor = 0.1
		self.continueButton.setTitle(NSLocalizedString("Continue", comment: ""), for: UIControl.State())
		self.continueButton.setTitleColor(self.tintColor, for: UIControl.State())
		self.continueButton.backgroundColor = UIColor.clear
	}
	
	fileprivate func setupImageView() {
		if self.imageView == nil {
			let imageView = UIImageView()
			imageView.contentMode = .scaleAspectFill
			self.addSubview(imageView)
			self.imageView = imageView
			self.imageView.backgroundColor = UIColor.clear
			imageView.translatesAutoresizingMaskIntoConstraints = false
			imageView.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: [], metrics: nil, views: ["subview": imageView]))
			imageView.superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: [], metrics: nil, views: ["subview": imageView]))
		}
	}
	
	
	//MARK: Table View Methods
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.permissions.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "permission-item", for: indexPath) as! PAPermissionsTableViewCell
		let item = self.permissions[(indexPath as NSIndexPath).row]
		cell.didSelectItem = {selectedPermission in
			if let delegate = self.delegate {
				delegate.permissionsView(self, permissionSelected: selectedPermission)
			}
		}
		cell.permission = item
		cell.permissionStatus = self.dataSource!.permissionsView(self, isPermissionEnabled: item)
		cell.tintColor = self.tintColor
		cell.selectionStyle = .none
		cell.titleLabel.text = item.title
		cell.detailsLabel.text = item.reason
		cell.iconImageView.image = item.icon.withRenderingMode(.alwaysTemplate)
		cell.permission = item
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
}
