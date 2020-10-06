//
//  PaymentOptionTableCellViewModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
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
    
    internal var paymentOption: PaymentOption? {
        return nil
    }
	
	internal var errorCode: ErrorCode? {
		return nil
	}
    
    // MARK: Methods
    
    internal override func tableViewDidSelectCell(_ sender: UITableView) {
        
        super.tableViewDidSelectCell(sender)
        Process.shared.viewModelsHandlerInterface.deselectAllPaymentOptionsModels(except: self)
    }
    
    internal override func tableViewDidDeselectCell(_ sender: UITableView) {
        
        super.tableViewDidDeselectCell(sender)
        Process.shared.viewModelsHandlerInterface.deselectPaymentOption(self)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func updateCellGlow() {
        
        guard let glowingCell = self.tableView?.cellForRow(at: self.indexPath) as? GlowingViewHandler else { return }
        
        glowingCell.setGlowing(self.isSelected)
    }
}
