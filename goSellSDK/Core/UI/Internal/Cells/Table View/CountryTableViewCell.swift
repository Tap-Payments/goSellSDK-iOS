//
//  CountryTableViewCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct TapAdditionsKitV2.TypeAlias
import class UIKit.UIImageView.UIImageView
import class UIKit.UILabel.UILabel
import class UIKit.UIView.UIView

internal class CountryTableViewCell: BaseTableViewCell {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var model: CountryTableViewCellModel?
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let selectionAnimationDuration: TimeInterval = 0.25
        
        //@available(*, unavailable) private init() { }
    }
    
    // MARK: Properties
    
    @IBOutlet private weak var countryNameLabel: UILabel?
    @IBOutlet private weak var checkmarkImageView: UIImageView?
}

// MARK: - LoadingWithModelCell
extension CountryTableViewCell: LoadingWithModelCell {
    
    internal func updateContent(animated: Bool) {
        
        self.countryNameLabel?.text = self.model?.displayText
        self.checkmarkImageView?.image = self.model?.checkmarkImage
        self.updateSelectionState(animated: animated)
    }
    
    private func updateSelectionState(animated: Bool) {
        
        let animations: TypeAlias.ArgumentlessClosure = { [weak self] in
            
            self?.checkmarkImageView?.alpha = (self?.model?.isSelected ?? false) ? 1.0 : 0.0
        }
        
        UIView.animate(withDuration: animated ? Constants.selectionAnimationDuration : 0.0, animations: animations)
    }
}
