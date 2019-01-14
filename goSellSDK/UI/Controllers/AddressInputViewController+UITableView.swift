//
//  AddressInputViewController+UITableView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class    UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class    UIKit.UITableViewCell.UITableViewCell

// MARK: - UITableViewDataSource
extension AddressInputViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.addressFieldsDataManager?.cellViewModels.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.model(at: indexPath)
        
        if let emptyModel = model as? EmptyTableViewCellModel {
            
            let cell = emptyModel.dequeueCell(from: tableView)
            return cell
        }
        if let dropdownModel = model as? AddressDropdownFieldTableViewCellModel {
            
            let cell = dropdownModel.dequeueCell(from: tableView)
            return cell
        }
        if let inputModel = model as? AddressTextInputFieldTableViewCellModel {
            
            let cell = inputModel.dequeueCell(from: tableView)
            cell.bindContent()
            return cell
        }
        
        fatalError("Data source is corrupted.")
    }
    
    private func model(at indexPath: IndexPath) -> TableViewCellViewModel {
        
        guard let model = self.addressFieldsDataManager?.cellViewModels.first(where: { $0.indexPath == indexPath }) else {
            
            fatalError("Data source is corrupted.")
        }
        
        return model
    }
}

// MARK: - UITableViewDelegate
extension AddressInputViewController: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model = self.model(at: indexPath)
        
        if let emptyModel = model as? EmptyTableViewCellModel {
            
            emptyModel.updateCell()
        }
        if let dropdownModel = model as? AddressDropdownFieldTableViewCellModel {
            
            dropdownModel.updateCell()
        }
        if let inputModel = model as? AddressTextInputFieldTableViewCellModel {
            
            inputModel.updateCell()
        }
        
        self.addressFieldsDataManager?.tableViewWillDisplayCell(connectedTo: model)
    }
    
    internal func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let inputCell = cell as? AddressTextInputFieldTableViewCell {
            
            inputCell.unbindContent()
        }
    }
}
