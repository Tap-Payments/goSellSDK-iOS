//
//  SingleCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol
import class UIKit.UICollectionView.UICollectionView
import class UIKit.UICollectionViewCell.UICollectionViewCell
import class UIKit.UITableView.UITableView
import class UIKit.UITableViewCell.UITableViewCell
import class UIKit.UIView.UIView

internal protocol SingleCellModel: ClassProtocol {
    
    associatedtype CellClass: LoadingWithModelCell
    
    var cell: CellClass? { get set }
}

internal extension SingleCellModel {
    
    internal func updateCell(animated: Bool = false) {
        
        self.cell?.updateContent(animated: animated)
    }
    
    private func connect(with cell: CellClass) {
        
        self.cell = cell
        
        if let castedSelf = self as? CellClass.ModelType {

            cell.model = castedSelf
        }
    }
}

internal extension SingleCellModel where CellClass: UITableViewCell {
    
    internal func dequeueCell(from tableView: UITableView) -> CellClass {
        
        guard let loadedCell = tableView.dequeueReusableCell(withIdentifier: CellClass.className) as? CellClass else {
            
            fatalError("Failed to load cell of class \(CellClass.className) with reuse identifier: \(CellClass.className)")
        }
        
        self.connect(with: loadedCell)
        
        return loadedCell
    }
}

internal extension SingleCellModel where CellClass: UICollectionViewCell {
    
    internal func dequeueCell(from collectionView: UICollectionView, for indexPath: IndexPath) -> CellClass {
        
        guard let loadedCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellClass.className, for: indexPath) as? CellClass else {
            
            fatalError("Failed to load cell of class \(CellClass.className) with reuse identifier: \(CellClass.className)")
        }
        
        self.connect(with: loadedCell)
        
        return loadedCell
    }
}
