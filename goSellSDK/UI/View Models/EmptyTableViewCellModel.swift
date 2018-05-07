//
//  EmptyTableViewCellModel.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class EmptyTableViewCellModel: CellViewModel {
    
    internal weak var cell: EmptyTableViewCell?
}

// MARK: - SingleCellModel
extension EmptyTableViewCellModel: SingleCellModel {}
