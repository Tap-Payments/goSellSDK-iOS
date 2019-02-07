//
//  BindingWithModelCell.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal protocol BindingWithModelCell: LoadingWithModelCell {
	
	var isContentBinded: Bool { get }
	
    /// Binds cell's content with the model (e.g. setting up table view data source with the model ).
    func bindContent()
    
    /// Unbinds cell's content from the model.
    func unbindContent()
}
