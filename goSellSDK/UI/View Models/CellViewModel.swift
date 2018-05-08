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
    
    internal func tableViewDidSelectCell(_ sender: UITableView) { }
    
    internal func tableViewDidDeselectCell(_ sender: UITableView) { }
    
    internal func manuallySelectCellAndCallTableViewDelegate() {
        
        self.tableView?.selectRow(at: self.indexPath, animated: true, scrollPosition: .none, callDelegate: true)
    }
}
