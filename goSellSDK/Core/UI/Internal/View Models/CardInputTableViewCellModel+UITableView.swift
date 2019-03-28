//
//  CardInputTableViewCellModel+UITableView.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class UIKit.UITableView.UITableView
import protocol UIKit.UITableView.UITableViewDataSource
import protocol UIKit.UITableView.UITableViewDelegate
import class UIKit.UITableViewCell.UITableViewCell

internal extension CardInputTableViewCellModel {
    
    // MARK: - Internal -
    
    class CardInputTableViewCellModelTableViewHandler: NSObject {
        
        fileprivate unowned let model: CardInputTableViewCellModel
        
        internal required init(model: CardInputTableViewCellModel) {
            
            self.model = model
            super.init()
        }
    }
    
    // MARK: Methods
    
    static func generateTableViewCellModels(with urls: [URL]) -> [ImageTableViewCellModel] {
        
        var result: [ImageTableViewCellModel] = []
        
        urls.forEach {
            
            let indexPath = self.nextImageTableViewCellIndexPath(for: result)
            let model = ImageTableViewCellModel(indexPath: indexPath, imageURL: $0)
            
            result.append(model)
        }
        
        return result
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private static func nextImageTableViewCellIndexPath(for temporaryResult: [ImageTableViewCellModel]) -> IndexPath {
        
        return IndexPath(row: temporaryResult.count, section: 0)
    }
}

// MARK: - UITableViewDataSource
extension CardInputTableViewCellModel.CardInputTableViewCellModelTableViewHandler: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.model.displayedTableViewCellModels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = self.model.displayedTableViewCellModels[indexPath.row]
        let cell = cellModel.dequeueCell(from: tableView)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CardInputTableViewCellModel.CardInputTableViewCellModelTableViewHandler: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cellModel = self.model.displayedTableViewCellModels[indexPath.row]
        cellModel.updateCell()
    }
}
