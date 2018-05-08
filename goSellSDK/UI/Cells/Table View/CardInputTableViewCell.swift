//
//  CardInputTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGBase.CGFloat
import class EditableTextInsetsTextField.EditableTextInsetsTextField
import struct TapAdditionsKit.TypeAlias
import class TapEditableView.TapEditableView
import class UIKit.NSLayoutConstraint.NSLayoutConstraint
import class UIKit.UICollectionView.UICollectionView
import class UIKit.UIScreen.UIScreen
import var UIKit.UITableView.UITableViewAutomaticDimension
import class UIKit.UITableViewCell.UITableViewCell

internal class CardInputTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CardInputTableViewCellModel?
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isSelected {
            
            return super.hitTest(point, with: event)
        }
        
        self.enableUserInteractionAndUpdateToolbarInAllControls()
        
        self.model?.manuallySelectCellAndCallTableViewDelegate()
        
        return super.hitTest(point, with: event)
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        
//        if selected {
//
//            self.enableUserInteractionAndUpdateToolbarInAllControls()
//            self.model?.manuallySelectCellAndCallTableViewDelegate()
//        }
        if !selected {
            
            self.firstResponder?.resignFirstResponder()
            self.controls?.forEach { $0.isUserInteractionEnabled = false }
        }
        
        
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let cvvFieldInsets = UIEdgeInsets(top: 0.0, left: 26.0, bottom: 0.0, right: 0.0)
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var iconsTableView: UITableView?
    
    @IBOutlet private weak var cardNumberTextField: EditableTextInsetsTextField?
    @IBOutlet private weak var cardScannerButton: UIButton?
    
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
    
    // MARK: Methods
    
    private func enableUserInteractionAndUpdateToolbarInAllControls() {
        
        self.controls?.forEach { $0.isUserInteractionEnabled = true }
        self.controls?.forEach { $0.updateToolbarButtonsState() }
    }
}

// MARK: - LoadingWithModelCell
extension CardInputTableViewCell: LoadingWithModelCell {

    internal func updateContent(animated: Bool) {

        self.updateCollectionViewContent(animated)
        
        self.setGlowing(self.model?.isSelected ?? false)
    }

    private func updateCollectionViewContent(_ animated: Bool) {

        if animated {

            self.iconsTableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        else {

            self.iconsTableView?.reloadData()
        }
    }
}

// MARK: - BindingWithModelCell
extension CardInputTableViewCell: BindingWithModelCell {
    
    internal func bindContent() {
        
        self.iconsTableView?.dataSource = self.model?.tableViewHandler
        self.iconsTableView?.delegate = self.model?.tableViewHandler
        
        if let cardNumberField = self.cardNumberTextField {
            
            self.model?.bind(cardNumberField, for: .cardNumber)
        }
        
        if let expirationDateField = self.expirationDateTextField {
            
            self.model?.bind(expirationDateField, editableView: self.expirationDateEditableView, for: .expirationDate)
        }
        
        if let cvvField = self.cvvTextField {
            
            self.model?.bind(cvvField, for: .cvv)
        }
        
        if let nameField = self.nameOnCardTextField {
            
            self.model?.bind(nameField, for: .nameOnCard)
        }
    }
}

// MARK: - GlowingCell
extension CardInputTableViewCell: GlowingCell {
    
    internal var glowingView: UIView { return self }
}
