//
//  InternalSessionProtocol.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
internal protocol InternalSessionProtocol: SessionProtocol {
	
	var externalSession: SessionProtocol { get }
}
