//
//  BindingWithModelCell.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal protocol BindingWithModelCell: LoadingWithModelCell {
    
    /// Binds cell's content with the model (e.g. setting up table view data source with the model ).
    func bindContent()
    
    /// Unbinds cell's content from the model.
    func unbindContent()
}
