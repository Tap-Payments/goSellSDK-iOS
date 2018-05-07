//
//  CellViewModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class CellViewModel: ViewModel {
    
    // MARK: - Internal -
    // MARK: Properties
    
    internal weak var tableView: UITableView?
    
    internal var indexPath: IndexPath
    
    internal var indexPathOfCellToSelect: IndexPath? {
        
        return nil
    }
    
    // MARK: Methods
    
    internal init(indexPath: IndexPath) {
        
        self.indexPath = indexPath
    }
    
    internal func tableViewDidSelectCell(_ sender: UITableView) {
        
        if let glowingCell = sender.cellForRow(at: self.indexPath) as? GlowingCell {
            
            glowingCell.startGlowing()
        }
    }
    
    internal func tableViewDidDeselectCell(_ sender: UITableView) {
        
        if let glowingCell = sender.cellForRow(at: self.indexPath) as? GlowingCell {
            
            glowingCell.stopGlowing()
        }
    }
    
    internal func manuallySelectCellAndCallTableViewDelegate() {
        
        guard let nonnullTableView = self.tableView else { return }
        
        if let alreadySelectedIndexPath = nonnullTableView.indexPathForSelectedRow, alreadySelectedIndexPath != self.indexPath {
            
            nonnullTableView.deselectRow(at: alreadySelectedIndexPath, animated: true)
            nonnullTableView.delegate?.tableView?(nonnullTableView, didDeselectRowAt: alreadySelectedIndexPath)
        }
        
        nonnullTableView.selectRow(at: self.indexPath, animated: true, scrollPosition: .none)
        nonnullTableView.delegate?.tableView?(nonnullTableView, didSelectRowAt: self.indexPath)
    }
}
