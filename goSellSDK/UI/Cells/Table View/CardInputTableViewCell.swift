//
//  CardInputTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct   CoreGraphics.CGBase.CGFloat
import struct   CoreGraphics.CGGeometry.CGPoint
import struct   CoreGraphics.CGGeometry.CGSize
import class    EditableTextInsetsTextField.EditableTextInsetsTextField
import struct   TapAdditionsKit.TypeAlias
import class    TapEditableView.TapEditableView
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
    
    // MARK: Methods
    
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
            
            self.firstResponder?.resignFirstResponder()
            self.controls?.forEach { $0.isUserInteractionEnabled = false }
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
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconsTableView: UITableView?
    
    @IBOutlet private weak var cardNumberTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var cardScannerButton: UIButton?
    
    @IBOutlet private var constraintsToDisableWhenCardScanningAvailable: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenCardScanningAvailable: [NSLayoutConstraint]?
    
    @IBOutlet private weak var expirationDateTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var expirationDateEditableView: TapEditableView?
    
    @IBOutlet private weak var cvvTextField: EditableTextInsetsTextField? {
        
        didSet {
        
            self.cvvTextField?.textInsets = Constants.cvvFieldInsets
        }
    }
    
    @IBOutlet private weak var nameOnCardTextField: EditableTextInsetsTextField?
    
    @IBOutlet private weak var saveCardSwitch: UISwitch?
    
    @IBOutlet private var controls: [UIView]?
    
    @IBOutlet private weak var addressOnCardLabel: UILabel?
    @IBOutlet private weak var addressOnCardLabelHeightConstraint: NSLayoutConstraint?
    @IBOutlet private weak var addressOnCardArrowImageView: UIImageView?
    
    @IBOutlet private var constraintsToDisableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    @IBOutlet private var constraintsToEnableWhenAddressOnCardRequired: [NSLayoutConstraint]?
    
    @IBOutlet private weak var saveCardContainerView: UIView?
    @IBOutlet private weak var saveCardContainerViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Methods
    
    private func enableUserInteractionAndUpdateToolbarInAllControls() {
        
        self.controls?.forEach { $0.isUserInteractionEnabled = true }
        self.controls?.forEach { $0.updateToolbarButtonsState() }
    }
    
    @discardableResult private func updateCardScannerButtonVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
            
            let nonnullConstraintsToDeactivateIfScanningEnabled = self.constraintsToDisableWhenCardScanningAvailable,
            let nonnullConstraintsToActivateIfScanningEnabled = self.constraintsToEnableWhenCardScanningAvailable
        
        else { return false }
        
        let scanButtonAlphaAnimation: TypeAlias.ArgumentlessClosure = {
            
            self.cardScannerButton?.alpha = (self.model?.isScanButtonVisible ?? false) ? 1.0 : 0.0
        }
        
        return NSLayoutConstraint.reactivate(inCaseIf: self.model?.isScanButtonVisible ?? false,
                                             constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfScanningEnabled,
                                             constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfScanningEnabled,
                                             viewToLayout: layout ? self.contentView : nil,
                                             animationDuration: animated ? self.contentView.layer.longestAnimationDuration : 0.0,
                                             additionalAnimations: scanButtonAlphaAnimation)
    }
    
    @discardableResult private func updateAddressOnCardFieldVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
        
            let nonnullConstraintsToDeactivateIfAddressRequired = self.constraintsToDisableWhenAddressOnCardRequired,
            let nonnullConstraintsToActivateIfAddressRequired = self.constraintsToEnableWhenAddressOnCardRequired
        
        else { return false }
        
        return NSLayoutConstraint.reactivate(inCaseIf: self.model?.displaysAddressFields ?? false,
                                             constraintsToDisableOnSuccess: nonnullConstraintsToDeactivateIfAddressRequired,
                                             constraintsToEnableOnSuccess: nonnullConstraintsToActivateIfAddressRequired,
                                             viewToLayout: layout ? self.contentView : nil,
                                             animationDuration: animated ? self.contentView.layer.longestAnimationDuration : 0.0)
    }
    
    @discardableResult private func updateSaveCardSectionVisibility(animated: Bool, layout: Bool) -> Bool {
        
        guard
            
            let saveCardContainerHeightConstraint = self.saveCardContainerViewHeightConstraint,
            let saveCardView = self.saveCardContainerView,
            let showsSaveCardSection = self.model?.showsSaveCardSection else { return false }
        
        let containerHeight = showsSaveCardSection ? Constants.saveCardContainerViewHeight : 0.0
        let alpha: CGFloat = showsSaveCardSection ? 1.0 : 0.0
        
        guard saveCardContainerHeightConstraint.constant != containerHeight else { return false }
        
        let animations: TypeAlias.ArgumentlessClosure = {
            
            saveCardView.alpha = alpha
            saveCardContainerHeightConstraint.constant = containerHeight
            if layout {
                
                self.layout()
            }
        }
        
        let animationDuration = animated ? self.contentView.layer.longestAnimationDuration : 0.0
        UIView.animate(withDuration: animationDuration, animations: animations)
        
        return true
    }
}

// MARK: - LoadingWithModelCell
extension CardInputTableViewCell: LoadingWithModelCell {

    internal func updateContent(animated: Bool) {

        self.updateTableViewContent(animated)
        
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
        
        self.setGlowing(self.model?.isSelected ?? false)
        
        self.addressOnCardArrowImageView?.image = self.model?.addressOnCardArrowImage
        self.cardScannerButton?.setImage(self.model?.scanButtonImage, for: .normal)
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
        
        if let saveCardSwitch = self.saveCardSwitch {
            
            self.model?.bind(saveCardSwitch, displayLabel: nil, for: .saveCard)
        }
        
        self.updateSectionsVisibility(animated: false, updateConstraintsOnly: true, forceLayout: false)
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
                    
                    self.layout()
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

// MARK: - GlowingCell
extension CardInputTableViewCell: GlowingCell {
    
    internal var glowingView: UIView { return self }
}
