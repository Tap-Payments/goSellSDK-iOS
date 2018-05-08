//
//  PaymentOptionCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Base class for payment options view models.
internal class PaymentOptionCellViewModel: CellViewModel {
    
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
    
    // MARK: Methods
    
    internal override func tableViewDidSelectCell(_ sender: UITableView) {
        
        super.tableViewDidSelectCell(sender)
        PaymentDataManager.shared.deselectAllPaymentOptionsModels(except: self)
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
