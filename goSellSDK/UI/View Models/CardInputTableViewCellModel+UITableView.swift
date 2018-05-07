//
//  CardInputTableViewCellModel+UITableView.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal extension CardInputTableViewCellModel {
    
    internal class CardInputTableViewCellModelTableViewHandler: NSObject {
        
        fileprivate unowned let model: CardInputTableViewCellModel
        
        internal required init(model: CardInputTableViewCellModel) {
            
            self.model = model
            super.init()
        }
    }
}

internal extension CardInputTableViewCellModel {
    
    internal static func generateTableViewCellModels(with urls: [URL]) -> [ImageTableViewCellModel] {
        
        var result: [ImageTableViewCellModel] = []
        
        for url in urls {
            
            let indexPath = self.nextImageTableViewCellIndexPath(for: result)
            let model = ImageTableViewCellModel(indexPath: indexPath, imageURL: url)
            
            result.append(model)
        }
        
        return result
    }
    
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
