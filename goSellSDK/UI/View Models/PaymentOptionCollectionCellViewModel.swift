//
//  PaymentOptionCollectionCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class    UIKit.UICollectionView.UICollectionView

internal class PaymentOptionCollectionCellViewModel: CollectionViewCellViewModel, PaymentOptionCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var isSelected: Bool = false {
        
        didSet {
        
            self.updateCellGlow()
        }
    }
    
    internal var indexPathOfCellToSelect: IndexPath? {
        
        return self.indexPath
    }
    
    internal var isReadyForPayment: Bool {
        
        return true
    }
    
    internal var affectsPayButtonState: Bool {
        
        return true
    }
    
    internal var initiatesPaymentOnSelection: Bool {
        
        return false
    }
    
    internal var paymentOption: PaymentOption? {
        
        return nil
    }
    
    // MARK: Methods
    
    internal override func collectionViewDidSelectCell(_ sender: UICollectionView) {
        
        super.collectionViewDidSelectCell(sender)
        PaymentDataManager.shared.deselectAllPaymentOptionsModels(except: self)
    }
    
    internal override func collectionViewDidDeselectCell(_ sender: UICollectionView) {
        
        super.collectionViewDidDeselectCell(sender)
        PaymentDataManager.shared.deselectPaymentOption(self)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updateCellGlow() {
        
        guard let glowingCell = self.collectionView?.cellForItem(at: self.indexPath) as? GlowingCell else { return }
        
        if self.isSelected {
            
            glowingCell.startGlowing()
        }
        else {
            
            glowingCell.stopGlowing()
        }
    }
}
