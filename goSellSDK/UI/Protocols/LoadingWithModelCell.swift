//
//  LoadingWithModelCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

import protocol TapAdditionsKit.ClassProtocol

internal protocol LoadingWithModelCell: ClassProtocol {
    
    associatedtype ModelType = CellViewModel
    
    /// Reference to the model.
    var model: ModelType? { get set }
    
    /// Updates content of the receiver, optionally animated.
    func updateContent(animated: Bool)
}
