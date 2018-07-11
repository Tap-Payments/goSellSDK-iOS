//
//  PaymentOptionTableCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import class UIKit.UITableView.UITableView

/// Base class for payment options view models.
internal class PaymentOptionTableCellViewModel: TableViewCellViewModel, PaymentOptionCellViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal var isSelected = false {
        
        didSet {
            
            self.updateCellGlow()
        }
    }
    
    internal override var indexPathOfCellToSelect: IndexPath? {
        
        return self.indexPath
    }
    
    internal var isReadyForPayment: Bool {
        
        return false
    }
    
    internal var affectsPayButtonState: Bool {
        
        return false
    }
    
    internal var initiatesPaymentOnSelection: Bool {
        
        return false
    }
    
    // MARK: Methods
    
    internal override func tableViewDidSelectCell(_ sender: UITableView) {
        
        super.tableViewDidSelectCell(sender)
        PaymentDataManager.shared.deselectAllPaymentOptionsModels(except: self)
    }
    
    internal override func tableViewDidDeselectCell(_ sender: UITableView) {
        
        super.tableViewDidDeselectCell(sender)
        PaymentDataManager.shared.deselectPaymentOption(self)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updateCellGlow() {
        
        guard let glowingCell = self.tableView?.cellForRow(at: self.indexPath) as? GlowingCell else { return }
        
        if self.isSelected {
            
            glowingCell.startGlowing()
        }
        else {
            
            glowingCell.stopGlowing()
        }
    }
}
