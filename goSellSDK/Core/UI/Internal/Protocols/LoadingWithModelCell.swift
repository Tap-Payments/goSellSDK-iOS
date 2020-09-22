//
//  LoadingWithModelCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKitV2.ClassProtocol

internal protocol LoadingWithModelCell: ClassProtocol {
    
    associatedtype ModelType = CellViewModel
    
    /// Reference to the model.
    var model: ModelType? { get set }
    
    /// Updates content of the receiver, optionally animated.
    func updateContent(animated: Bool)
}
