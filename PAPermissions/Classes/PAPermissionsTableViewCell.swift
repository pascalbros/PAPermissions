//
//  PAPermissionsTableViewCell.swift
//  PAPermissionsApp
//
//  Created by Pasquale Ambrosini on 05/09/16.
//  Copyright © 2016 Pasquale Ambrosini. All rights reserved.
//

import UIKit

class PAPermissionsTableViewCell: UITableViewCell {

	var didSelectItem: ((PAPermissionsItem) -> ())?
	
	let iconImageView: UIImageView = UIImageView()
	let titleLabel: UILabel = UILabel()
	let detailsLabel: UILabel = UILabel()
	
	var permission: PAPermissionsItem?
	
	fileprivate let rightDetailsContainer: UIView = UIView()
	fileprivate let enableButton: UIButton = UIButton(type: .system)
	fileprivate let checkingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
	
	fileprivate var _permissionStatus = PAPermissionsStatus.disabled
	var permissionStatus: PAPermissionsStatus {
		get {
			return self._permissionStatus
		}
		
		set(newStatus) {
			self._permissionStatus = newStatus
			self.setupEnableButton(newStatus)
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
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func updateTintColor() {
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupEnableButton(self.permissionStatus)
	}
	
	fileprivate func setupUI() {
		self.backgroundColor = UIColor.clear
		self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupRightDetailsContainer()
		
		let views = ["iconImageView": self.iconImageView,
		             "titleLabel": self.titleLabel,
		             "detailsLabel": self.detailsLabel,
		             "rightDetailsContainer": self.rightDetailsContainer] as [String:UIView]

		let allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
			"V:|-2-[iconImageView]-2-|",
			"H:|-0-[iconImageView(15)]",
			"V:|-2-[rightDetailsContainer]-2-|",
			"H:[rightDetailsContainer(58)]-0-|",
			"V:|-8-[titleLabel(18)]-2-[detailsLabel(13)]",
			"H:[iconImageView]-8-[titleLabel]-4-[rightDetailsContainer]",
			"H:[iconImageView]-8-[detailsLabel]-4-[rightDetailsContainer]"
			], views: views)
		
		NSLayoutConstraint.activate(allConstraints)
		self.setupEnableButton(.disabled)
	}
	
	fileprivate func setupImageView() {
		iconImageView.contentMode = .scaleAspectFit
		self.addSubview(iconImageView)
		self.iconImageView.backgroundColor = UIColor.clear
		self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
		self.iconImageView.tintColor = self.tintColor
	}
	
	fileprivate func setupTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(titleLabel)
		self.titleLabel.text = "Title"
		self.titleLabel.adjustsFontSizeToFitWidth = true
		
		self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
		self.titleLabel.minimumScaleFactor = 0.1
		self.titleLabel.textColor = self.tintColor
	}
	
	fileprivate func setupDetailsLabel() {
		detailsLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(detailsLabel)
		self.detailsLabel.text = "details"
		self.detailsLabel.adjustsFontSizeToFitWidth = true
		
		self.detailsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 11)
		self.detailsLabel.minimumScaleFactor = 0.1
		self.detailsLabel.textColor = self.tintColor
	}
	
	fileprivate func setupRightDetailsContainer() {
		rightDetailsContainer.backgroundColor = UIColor.clear
		rightDetailsContainer.translatesAutoresizingMaskIntoConstraints = false
		rightDetailsContainer.backgroundColor = UIColor.clear
		self.addSubview(rightDetailsContainer)
	}
	
	fileprivate func setupEnableButton(_ status: PAPermissionsStatus) {
		enableButton.translatesAutoresizingMaskIntoConstraints = false
		self.rightDetailsContainer.addSubview(enableButton)
		self.enableButton.addTarget(self, action: #selector(PAPermissionsTableViewCell._didSelectItem), for: .touchUpInside)
		
		checkingIndicator.translatesAutoresizingMaskIntoConstraints = false
		self.rightDetailsContainer.addSubview(checkingIndicator)

		let views = ["enableButton": self.enableButton,
					 "checkingIndicator": self.checkingIndicator] as [String : UIView]
		
		var allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
			"V:[enableButton(30)]",
			"H:|-2-[enableButton]-2-|",
			"V:|-0-[checkingIndicator]-0-|",
			"H:|-0-[checkingIndicator]-0-|"
			], views: views)
		allConstraints.append(NSLayoutConstraint.init(item: self.enableButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.enableButton.superview, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0.0))
		NSLayoutConstraint.activate(allConstraints)
		
		self.enableButton.tintColor = self.tintColor
		
		if status == .enabled {
			if self.permission?.canBeDisabled == false {
				self.enableButton.isHidden = false
				self.checkingIndicator.isHidden = true
				self.checkingIndicator.stopAnimating()
				self.enableButton.setTitle("", for: UIControl.State())
				self.enableButton.layer.cornerRadius = 0.0
				self.enableButton.layer.borderColor = UIColor.clear.cgColor
				self.enableButton.layer.borderWidth = 0.0
				self.enableButton.setImage(UIImage(named: "pa_checkmark_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil), for: UIControl.State())
				self.enableButton.imageView?.contentMode = .scaleAspectFit
				self.enableButton.isUserInteractionEnabled = false
			}else{
				self.setupEnableDisableButton(title: "Disable")
			}
		}else if status == .disabled || status == .denied {
			self.setupEnableDisableButton(title: "Enable")
		}else if status == .checking {
			self.enableButton.isHidden = true
			self.checkingIndicator.isHidden = false
			self.checkingIndicator.startAnimating()
		}else if status == .unavailable {
			self.enableButton.isHidden = false
			self.checkingIndicator.isHidden = true
			self.checkingIndicator.stopAnimating()
			self.enableButton.setTitle("", for: UIControl.State())
			self.enableButton.layer.cornerRadius = 0.0
			self.enableButton.layer.borderColor = UIColor.clear.cgColor
			self.enableButton.layer.borderWidth = 0.0
			self.enableButton.setImage(UIImage(named: "pa_cancel_icon", in: Bundle(for: PAPermissionsViewController.self), compatibleWith: nil), for: UIControl.State())
			self.enableButton.imageView?.contentMode = .scaleAspectFit
			self.enableButton.isUserInteractionEnabled = false
		}
		rightDetailsContainer.superview?.bringSubviewToFront(rightDetailsContainer)
	}
	
	private func setupEnableDisableButton(title: String) {
		self.enableButton.isHidden = false
		self.checkingIndicator.isHidden = true
		self.checkingIndicator.stopAnimating()
		self.enableButton.setTitle(NSLocalizedString(title, comment: ""), for: UIControl.State())
		self.enableButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
		self.enableButton.setImage(nil, for: UIControl.State())
		self.enableButton.titleLabel?.minimumScaleFactor = 0.1
		self.enableButton.titleLabel?.adjustsFontSizeToFitWidth  = true
		self.enableButton.setTitleColor(self.tintColor, for: UIControl.State())
		self.enableButton.backgroundColor = UIColor.clear
		self.enableButton.layer.cornerRadius = 2.0
		self.enableButton.layer.borderColor = self.tintColor.cgColor
		self.enableButton.layer.borderWidth = 1.0
		self.enableButton.clipsToBounds = true
		self.enableButton.isUserInteractionEnabled = true
	}
	
	@objc fileprivate func _didSelectItem() {
		if let didSelectItem = didSelectItem, let permission = permission {
			didSelectItem(permission)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
