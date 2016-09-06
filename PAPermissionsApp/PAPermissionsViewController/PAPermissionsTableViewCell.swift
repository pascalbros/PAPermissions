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
	
	weak var iconImageView: UIImageView!
	weak var titleLabel: UILabel!
	weak var detailsLabel: UILabel!
	
	weak var permission: PAPermissionsItem!
	
	private weak var rightDetailsContainer: UIView!
	private weak var enableButton: UIButton!
	private weak var checkingIndicator: UIActivityIndicatorView!
	
	private var _permissionStatus = PAPermissionsStatus.Disabled
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
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .Default, reuseIdentifier: reuseIdentifier)
		self.setupUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func updateTintColor() {
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupEnableButton(self.permissionStatus)
	}
	
	private func setupUI() {
		self.backgroundColor = UIColor.clearColor()
		self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDetailsLabel()
		self.setupRightDetailsContainer()
		
		let views = ["iconImageView": self.iconImageView,
					 "titleLabel": self.titleLabel,
					 "detailsLabel": self.detailsLabel,
					 "rightDetailsContainer": self.rightDetailsContainer]
		
		let allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
			"V:|-2-[iconImageView]-2-|",
			"H:|-0-[iconImageView(15)]",
			"V:|-2-[rightDetailsContainer]-2-|",
			"H:[rightDetailsContainer(46)]-0-|",
			"V:|-8-[titleLabel(18)]-2-[detailsLabel(13)]",
			"H:[iconImageView]-8-[titleLabel]-4-[rightDetailsContainer]",
			"H:[iconImageView]-8-[detailsLabel]-4-[rightDetailsContainer]"
			], views: views)
		
		NSLayoutConstraint.activateConstraints(allConstraints)
		
		self.setupEnableButton(.Disabled)
	}
	
	private func setupImageView() {
		if self.iconImageView == nil {
			let imageView = UIImageView()
			imageView.contentMode = .ScaleAspectFit
			self.addSubview(imageView)
			self.iconImageView = imageView
			self.iconImageView.backgroundColor = UIColor.clearColor()
			self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
		}
		self.iconImageView.tintColor = self.tintColor
	}
	
	private func setupTitleLabel() {
		if self.titleLabel == nil {
			let titleLabel = UILabel()
			titleLabel.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(titleLabel)
			self.titleLabel = titleLabel
			self.titleLabel.text = "Title"
			self.titleLabel.adjustsFontSizeToFitWidth = true
		}
		
		self.titleLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
		self.titleLabel.minimumScaleFactor = 0.1
		self.titleLabel.textColor = self.tintColor
	}
	
	private func setupDetailsLabel() {
		if self.detailsLabel == nil {
			let detailsLabel = UILabel()
			detailsLabel.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(detailsLabel)
			self.detailsLabel = detailsLabel
			self.detailsLabel.text = "details"
			self.detailsLabel.adjustsFontSizeToFitWidth = true
		}
		
		self.detailsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 11)
		self.detailsLabel.minimumScaleFactor = 0.1
		self.detailsLabel.textColor = self.tintColor
	}
	
	private func setupRightDetailsContainer() {
		if self.rightDetailsContainer == nil {
			let rightDetailsContainer = UIView()
			rightDetailsContainer.backgroundColor = UIColor.clearColor()
			rightDetailsContainer.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(rightDetailsContainer)
			self.rightDetailsContainer = rightDetailsContainer
			self.rightDetailsContainer.backgroundColor = UIColor.clearColor()
		}
	}
	
	private func setupEnableButton(status: PAPermissionsStatus) {
		if self.enableButton == nil {
			let enableButton = UIButton(type: .System)
			enableButton.translatesAutoresizingMaskIntoConstraints = false
			self.rightDetailsContainer.addSubview(enableButton)
			self.enableButton = enableButton
			self.enableButton.backgroundColor = UIColor.redColor()
			self.enableButton.addTarget(self, action: #selector(PAPermissionsTableViewCell._didSelectItem), forControlEvents: .TouchUpInside)
			
			let checkingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
			checkingIndicator.translatesAutoresizingMaskIntoConstraints = false
			self.rightDetailsContainer.addSubview(checkingIndicator)
			self.checkingIndicator = checkingIndicator

			let views = ["enableButton": self.enableButton,
						 "checkingIndicator": self.checkingIndicator]
			
			var allConstraints = PAConstraintsUtils.concatenateConstraintsFromString([
				"V:[enableButton(24)]",
				"H:|-2-[enableButton]-2-|",
				"V:|-0-[checkingIndicator]-0-|",
				"H:|-0-[checkingIndicator]-0-|"
				], views: views)
			allConstraints.append(NSLayoutConstraint.init(item: self.enableButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.enableButton.superview, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
			
			NSLayoutConstraint.activateConstraints(allConstraints)
		}
		
		self.enableButton.tintColor = self.tintColor
		
		if status == .Enabled {
			self.enableButton.hidden = false
			self.checkingIndicator.hidden = true
			self.checkingIndicator.stopAnimating()
			self.enableButton.setTitle("", forState: .Normal)
			self.enableButton.layer.cornerRadius = 0.0
			self.enableButton.layer.borderColor = UIColor.clearColor().CGColor
			self.enableButton.layer.borderWidth = 0.0
			self.enableButton.setImage(UIImage(named: "pa_checkmark_icon.png"), forState: .Normal)
			self.enableButton.imageView?.contentMode = .ScaleAspectFit
			self.enableButton.userInteractionEnabled = false
		}else if status == .Disabled {
			self.enableButton.hidden = false
			self.checkingIndicator.hidden = true
			self.checkingIndicator.stopAnimating()
			self.enableButton.setTitle(NSLocalizedString("Enable", comment: ""), forState: .Normal)
			self.enableButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 10)
			self.enableButton.setImage(nil, forState: .Normal)
			self.enableButton.titleLabel?.minimumScaleFactor = 0.1
			self.enableButton.setTitleColor(self.tintColor, forState: .Normal)
			self.enableButton.backgroundColor = UIColor.clearColor()
			self.enableButton.layer.cornerRadius = 2.0
			self.enableButton.layer.borderColor = self.tintColor.CGColor
			self.enableButton.layer.borderWidth = 1.0
			self.enableButton.clipsToBounds = true
			self.enableButton.userInteractionEnabled = true
		}else if status == .Checking {
			self.enableButton.hidden = true
			self.checkingIndicator.hidden = false
			self.checkingIndicator.startAnimating()
		}else if status == .Unavailable {
			self.enableButton.hidden = false
			self.checkingIndicator.hidden = true
			self.checkingIndicator.stopAnimating()
			self.enableButton.setTitle("", forState: .Normal)
			self.enableButton.layer.cornerRadius = 0.0
			self.enableButton.layer.borderColor = UIColor.clearColor().CGColor
			self.enableButton.layer.borderWidth = 0.0
			self.enableButton.setImage(UIImage(named: "pa_cancel_icon.png"), forState: .Normal)
			self.enableButton.imageView?.contentMode = .ScaleAspectFit
			self.enableButton.userInteractionEnabled = false
		}
	}
	
	@objc private func _didSelectItem() {
		if self.didSelectItem != nil {
			self.didSelectItem!(self.permission)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

		// Configure the view for the selected state
	}

}
