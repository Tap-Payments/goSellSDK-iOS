//
//  SessionProtocol.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
/// Session interface.
@objc public protocol SessionProtocol {
	
	/// Session data source.
	var dataSource: SessionDataSource? { get set }
	
	/// Session delegate.
	var delegate: SessionDelegate? { get set }
	
	/// Session appearance.
	var appearance: SessionAppearance? { get set }
}
