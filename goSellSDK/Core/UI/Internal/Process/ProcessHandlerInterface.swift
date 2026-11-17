//
//  ProcessHandlerInterface.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import protocol	TapAdditionsKitV2.ClassProtocol

internal protocol ProcessHandlerInterface: ClassProtocol {
	
	associatedtype Mode
	associatedtype ProcessClass: ProcessGenericInterface where ProcessClass.HandlerMode == Self.Mode
	
	var process: ProcessClass { get }
	
	init(process: ProcessClass)
}
