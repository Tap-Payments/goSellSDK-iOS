//
//  SingleCellModel.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol
import class    UIKit.UICollectionView.UICollectionView
import class    UIKit.UICollectionViewCell.UICollectionViewCell
import class    UIKit.UITableView.UITableView
import class    UIKit.UITableViewCell.UITableViewCell
import class    UIKit.UIView.UIView

internal protocol SingleCellModel: ClassProtocol {
    
    associatedtype CellClass: LoadingWithModelCell
    
    var cell: CellClass? { get set }
}

internal extension SingleCellModel {
    
    func updateCell(animated: Bool = false) {
        
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
    
    func dequeueCell(from tableView: UITableView) -> CellClass {
        
        let reuseIdentifier: String = CellClass.tap_className
        
        if let loadedCell: CellClass = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? CellClass {
            
            if let tableViewCellModel: TableViewCellViewModel = self as? TableViewCellViewModel {
                
                tableViewCellModel.tableView = tableView
            }
            
            self.connect(with: loadedCell)
            
            return loadedCell
        }
        else {
            
            fatalError("Failed to load cell of class \(reuseIdentifier) with reuse identifier: \(reuseIdentifier)")
        }
    }
}

internal extension SingleCellModel where CellClass: UICollectionViewCell {
    
    func dequeueCell(from collectionView: UICollectionView, for indexPath: IndexPath) -> CellClass {
        
        let reuseIdentifier = CellClass.tap_className
        
        if let loadedCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CellClass {
            
            if let collectionViewCellModel = self as? CollectionViewCellViewModel {
                
                collectionViewCellModel.collectionView = collectionView
            }
            
            self.connect(with: loadedCell)
            
            return loadedCell
        }
        else {
            
            fatalError("Failed to load cell of class \(reuseIdentifier) with reuse identifier: \(reuseIdentifier)")
        }
    }
}
