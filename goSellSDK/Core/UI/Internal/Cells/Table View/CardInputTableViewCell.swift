//
//  CardInputTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    EditableTextInsetsTextFieldV2.EditableTextInsetsTextField
import struct   TapAdditionsKitV2.TypeAlias
import class    TapEditableViewV2.TapEditableView
import class    UIKit.NSLayoutConstraint.NSLayoutConstraint
import class    UIKit.UIButton.UIButton
import class    UIKit.UICollectionView.UICollectionView
import class    UIKit.UIEvent.UIEvent
import struct   UIKit.UIGeometry.UIEdgeInsets
import class    UIKit.UIImageView.UIImageView
import class    UIKit.UILabel.UILabel
import class    UIKit.UIScreen.UIScreen
import class    UIKit.UISwitch.UISwitch
import class    UIKit.UITableView.UITableView
import var      UIKit.UITableView.UITableViewAutomaticDimension
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UIView.UIView

internal class CardInputTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: (CardInputTableViewCellModel & CardInputTableViewCellLoading)?

	internal private(set) var isContentBinded: Bool = false

    // MARK: Methods
    internal func unSpportedCardType()
    {
        self.cardNumberTextField?.text = ""
    }
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isSelected {
            
            return super.hitTest(point, with: event)
        }
        
        if self.bounds.contains(point) {
            
            self.enableUserInteractionAndUpdateToolbarInAllControls()
            self.model?.manuallySelectCellAndCallTableViewDelegate()
        }
        
        return super.hitTest(point, with: event)
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
        if !selected {
            
            self.tap_firstResponder?.resignFirstResponder()
            self.controls?.forEach { $0.isUserInteractionEnabled = true }
        }
        
        
        super.setSelected(selected, animated: animated)
    }
    
    internal override func updateConstraints() {
        
        self.updateSectionsVisibility(animated: false, updateConstraintsOnly: true, forceLayout: false)
        super.updateConstraints()
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let cvvFieldInsets = UIEdgeInsets(top: 0.0, left: 26.0, bottom: 0.0, right: 0.0)
        fileprivate static let layoutAnimationDuration: TimeInterval = 0.25
        fileprivate static let extraAddressHeight: CGFloat = 2.0
        fileprivate static let saveCardContainerViewHeight: CGFloat = 55.0
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconsTableView: UITableView?
    
    @IBOutlet private weak var cardNumberTextField: EditableTextInsetsTextField?
    
    @IBOutlet private weak var cardScannerButton: UIButton?
    
    @IBOutlet private var constraintsToDisableWhenCardScanningAvailable: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenCardScanningAvailable: [NSLayoutConstraint]?
    
    @IBOutlet private weak var expirationDateTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var expirationDateEditableView: TapEditableView?
    
    @IBOutlet private weak var cvvTextField: EditableTextInsetsTextField?
    
    @IBOutlet private weak var nameOnCardTextField: EditableTextInsetsTextField?
	
	@IBOutlet private weak var saveCardDescriptionLabel: UILabel?
    @IBOutlet public weak var saveCardSwitch: UISwitch?
    
    @IBOutlet private var controls: [UIView]?
    
    @IBOutlet private weak var addressOnCardLabel: UILabel?
    @IBOutlet private weak var addressOnCardLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var addressOnCardArrowImageView: UIImageView?
    
    @IBOutlet private var constraintsToDisableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    
    @IBOutlet private weak var saveCardContainerView: UIView?
    @IBOutlet private weak var saveCardContainerViewHeightConstraint: NSLayoutConstraint?
	
	@IBOutlet private var constraintsToDeactivateWhenSaveCardSwitchVisible: [NSLayoutConstraint]?
	@IBOutlet private var constraintsToActivateWhenSaveCardSwitchVisible: [NSLayoutConstraint]?
    
    // MARK: Methods
    
    private func enableUserInteractionAndUpdateToolbarInAllControls() {
        
        self.controls?.forEach { $0.isUserInteractionEnabled = true }
        self.controls?.forEach { $0.tap_updateToolbarButtonsState() }
    }
    
    @discardableResult private func updateCardScannerButtonVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
            
            let nonnullConstraintsToDeactivateIfScanningEnabled = self.constraintsToDisableWhenCardScanningAvailable,
            let nonnullConstraintsToActivateIfScanningEnabled = self.constraintsToEnableWhenCardScanningAvailable
        
        else { return false }
        
        let scanButtonAlphaAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.cardScannerButton?.alpha = (self.model?.isScanButtonVisible ?? false) ? 1.0 : 0.0
        }
        
		return NSLayoutConstraint.tap_reactivate(inCaseIf: self.model?.isScanButtonVisible ?? false,
												 constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfScanningEnabled,
												 constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfScanningEnabled,
												 viewToLayout: layout ? self.contentView : nil,
												 animationDuration: animated ? self.contentView.layer.tap_longestAnimationDuration : 0.0,
												 additionalAnimations: scanButtonAlphaAnimation)
	}
	
    @discardableResult private func updateAddressOnCardFieldVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
        
            let nonnullConstraintsToDeactivateIfAddressRequired = self.constraintsToDisableWhenAddressOnCardRequired,
            let nonnullConstraintsToActivateIfAddressRequired = self.constraintsToEnableWhenAddressOnCardRequired
        
        else { return false }
        
		return NSLayoutConstraint.tap_reactivate(inCaseIf: self.model?.displaysAddressFields ?? false,
												 constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfAddressRequired,
												 constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfAddressRequired,
												 viewToLayout: layout ? self.contentView : nil,
												 animationDuration: animated ? self.contentView.layer.tap_longestAnimationDuration : 0.0)
	}
    
    @discardableResult private func updateSaveCardSectionVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
            
            let saveCardContainerHeightConstraint			= self.saveCardContainerViewHeightConstraint,
            let saveCardView								= self.saveCardContainerView,
			let saveCardSwitch								= self.saveCardSwitch,
			let model										= self.model,
			let constraintsToDeactivateForSaveCardSwitch	= self.constraintsToDeactivateWhenSaveCardSwitchVisible,
			let constraintsToActivateForSaveCardSwitch		= self.constraintsToActivateWhenSaveCardSwitchVisible
		
		else { return false }
		
		let animationDuration = animated ? self.contentView.layer.tap_longestAnimationDuration : 0.0
		
        let containerHeight					= model.showsSaveCardSection ? Constants.saveCardContainerViewHeight : 0.0
        let saveCardViewAlpha: CGFloat		= model.showsSaveCardSection ? 1.0 : 0.0
		let saveCardSwitchAlpha: CGFloat	= model.showsSaveCardSwitch ? 1.0 : 0.0
		
		let animations: TypeAlias.ArgumentlessClosure = {
			
			saveCardView.alpha		= saveCardViewAlpha
			saveCardSwitch.alpha	= saveCardSwitchAlpha
			
			saveCardContainerHeightConstraint.constant = containerHeight
			if layout {
				
				self.tap_layout()
			}
		}
		
		var didPerformAnimation = false
		
		if model.showsSaveCardSection {
			
			didPerformAnimation = NSLayoutConstraint.tap_reactivate(inCaseIf:						model.showsSaveCardSwitch,
																	constraintsToDisableOnSuccess:	constraintsToDeactivateForSaveCardSwitch,
																	constraintsToEnableOnSuccess:	constraintsToActivateForSaveCardSwitch,
																	viewToLayout:					layout ? self : nil,
																	animationDuration:				animationDuration,
																	additionalAnimations:			animations)
		}
		
		if !didPerformAnimation {
			
			UIView.animate(withDuration: animationDuration, animations: animations)
		}
        
        return true
    }
}

// MARK: - LoadingWithModelCell
extension CardInputTableViewCell: LoadingWithModelCell {

    internal func updateContent(animated: Bool) {

		self.updateLocalization()
        
        var shouldForceLayout = false
        
        if let nonnullModel = self.model, nonnullModel.displaysAddressFields {
            
            self.addressOnCardLabel?.font = nonnullModel.addressOnCardTextFont
            
            if self.addressOnCardLabel?.text != nonnullModel.addressOnCardText {
                
                self.addressOnCardLabel?.text = nonnullModel.addressOnCardText
                
                shouldForceLayout = true
            }
            
            self.addressOnCardLabel?.textColor = nonnullModel.addressOnCardTextColor
        }
        
        self.updateAddressOnCardLabelHeightConstraint()
        self.updateSectionsVisibility(animated: animated, updateConstraintsOnly: false, forceLayout: shouldForceLayout)
		
		self.updateTableViewContent(animated)
		
        self.setGlowing(self.model?.isSelected ?? false)
        
        self.addressOnCardArrowImageView?.image = self.model?.addressOnCardArrowImage
        self.cardScannerButton?.setImage(self.model?.scanButtonImage, for: .normal)
        
        
    }

	private func updateLocalization() {
		
		self.cardNumberTextField?.tap_localizedTextAlignment 		= .leading
		self.expirationDateTextField?.tap_localizedTextAlignment 	= .leading
		self.cvvTextField?.tap_localizedTextAlignment 				= .leading
		self.addressOnCardLabel?.tap_localizedTextAlignment 		= .leading
		self.nameOnCardTextField?.tap_localizedTextAlignment 		= .leading
		self.saveCardDescriptionLabel?.tap_localizedTextAlignment	= .leading
		
		self.cardNumberTextField?.localizedClearButtonPosition 		= .right
		self.expirationDateTextField?.localizedClearButtonPosition 	= .right
		self.cvvTextField?.localizedClearButtonPosition 			= .right
		self.nameOnCardTextField?.localizedClearButtonPosition 		= .right
		
		self.cardNumberTextField?.setLocalizedText		(for: .placeholder, key: .card_input_card_number_placeholder)
		self.expirationDateTextField?.setLocalizedText	(for: .placeholder, key: .card_input_expiration_date_placeholder)
		self.cvvTextField?.setLocalizedText				(for: .placeholder, key: .card_input_cvv_placeholder)
		self.nameOnCardTextField?.setLocalizedText		(for: .placeholder, key: .card_input_cardholder_name_placeholder)
		
		self.cvvTextField?.textInsets	= Constants.cvvFieldInsets.tap_localized
		
		self.addressOnCardLabel?.setLocalizedText		(.card_input_address_on_card_placeholder)
		
		if let model = self.model {
		
			self.saveCardDescriptionLabel?.setLocalizedText(model.saveCardDescriptionKey)
		}
	}
	
    private func updateTableViewContent(_ animated: Bool) {

        if animated {

            self.iconsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {

            self.iconsTableView?.reloadData()
        }
    }
    
    private func updateAddressOnCardLabelHeightConstraint() {
        
        guard let label = self.addressOnCardLabel, let constraint = self.addressOnCardLabelHeightConstraint else {
            
            self.addressOnCardLabelHeightConstraint?.constant = 0.0
            return
        }
        
        let constraintSize = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let text = label.attributedText ?? NSAttributedString()
        let boundingRect = text.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesDeviceMetrics], context: nil)
        
        let height = ceil(boundingRect.height + Constants.extraAddressHeight)
        
        constraint.constant = height
    }
}

// MARK: - BindingWithModelCell
extension CardInputTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        self.iconsTableView?.dataSource = self.model?.tableViewHandler
        self.iconsTableView?.delegate = self.model?.tableViewHandler
        
        if let cardNumberField = self.cardNumberTextField {
            
            self.model?.bind(cardNumberField, displayLabel: nil, for: .cardNumber)
        }
        
        if let expirationDateField = self.expirationDateTextField {
            
            self.model?.bind(expirationDateField, displayLabel: nil, editableView: self.expirationDateEditableView, for: .expirationDate)
        }
        
        if let cvvField = self.cvvTextField {
            
            self.model?.bind(cvvField, displayLabel: nil, for: .cvv)
        }
        
        if let nameField = self.nameOnCardTextField {
            
            self.model?.bind(nameField, displayLabel: nil, for: .nameOnCard)
        }
        
        if let addressLabel = self.addressOnCardLabel {
            
            self.model?.bind(nil, displayLabel: addressLabel, for: .addressOnCard)
        }
        
        if let saveCardSwitch = self.saveCardSwitch, let descriptionLabel = self.saveCardDescriptionLabel {
            
            self.model?.bind(saveCardSwitch, displayLabel: descriptionLabel, for: .saveCard)
        }
        
        self.updateSectionsVisibility(animated: false, updateConstraintsOnly: true, forceLayout: false)
		
		self.isContentBinded = true
        
        self.saveCardSwitch?.onTintColor = UIColor(tap_hex: "2ACE00")?.loadCompatibleDarkModeColor(forColorNamed: "SaveCardSwitchTintColor")
        self.cardNumberTextField?.textColor = UIColor(tap_hex: "FFFFFF")?.loadCompatibleDarkModeColor(forColorNamed: "CardInputTextFieldColor")
        self.cvvTextField?.textColor = UIColor(tap_hex: "FFFFFF")?.loadCompatibleDarkModeColor(forColorNamed: "CardInputTextFieldColor")
        self.nameOnCardTextField?.textColor = UIColor(tap_hex: "FFFFFF")?.loadCompatibleDarkModeColor(forColorNamed: "CardInputTextFieldColor")
        self.expirationDateTextField?.textColor = UIColor(tap_hex: "FFFFFF")?.loadCompatibleDarkModeColor(forColorNamed: "CardInputTextFieldColor")
        
        
        guard let session = Process.shared.externalSession, let dataSource = session.dataSource, let providedCardName:String = dataSource.cardHolderName as? String else { return }
        
        self.nameOnCardTextField?.text = providedCardName.uppercased()
        self.nameOnCardTextField?.isUserInteractionEnabled = dataSource.cardHolderNameIsEditable ?? true
        self.nameOnCardTextField?.isEnabled = dataSource.cardHolderNameIsEditable ?? true
        print(providedCardName.uppercased())
        self.model?.inputData[.nameOnCard] = providedCardName.uppercased()
    }
    
    internal func unbindContent() {
        
        self.iconsTableView?.dataSource = nil
        self.iconsTableView?.delegate = nil
		
		self.isContentBinded = false
    }
    
    private func updateSectionsVisibility(animated: Bool, updateConstraintsOnly: Bool = false, forceLayout: Bool) {
        
        if updateConstraintsOnly {
            
            self.updateCardScannerButtonVisibility  (animated: animated, layout: false)
            self.updateAddressOnCardFieldVisibility (animated: animated, layout: false)
            self.updateSaveCardSectionVisibility    (animated: animated, layout: false)
            
            return
        }
        
        let closureThatPossiblyRequiresLayout: () -> Bool = {
            
            let needScannerButtonLayout = self.updateCardScannerButtonVisibility    (animated: animated, layout: true)
            let needAddressOnCardLayout = self.updateAddressOnCardFieldVisibility   (animated: animated, layout: true)
            let needSaveCardLayout      = self.updateSaveCardSectionVisibility      (animated: animated, layout: true)
            
            return needScannerButtonLayout || needAddressOnCardLayout || needSaveCardLayout
        }
        
        if let nonnullModel = self.model {
            
            nonnullModel.updateCellLayout(animated: animated) {
                
                _ = closureThatPossiblyRequiresLayout()
            }
        }
        else {
            
            let requiresLayout = closureThatPossiblyRequiresLayout()
            if requiresLayout || forceLayout {
                
                let animations: TypeAlias.ArgumentlessClosure = {
                    
                    self.tap_layout()
                }
                
                if animated {
                    
                    UIView.animate(withDuration: Constants.layoutAnimationDuration, animations: animations)
                }
                else {
                    
                    UIView.performWithoutAnimation {
                        
                        animations()
                    }
                }
            }
        }
    }
}

// MARK: - GlowingViewHandler
extension CardInputTableViewCell: GlowingViewHandler {
    
    internal var glowingView: UIView { return self }
}
