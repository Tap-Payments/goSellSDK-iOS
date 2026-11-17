//
//  StaticlyDestroyable.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import protocol TapAdditionsKitV2.ClassProtocol
import struct   TapAdditionsKitV2.TypeAlias

internal protocol StaticlyDestroyable: ClassProtocol {
    
    static var hasAliveInstance: Bool { get }
}

internal protocol ImmediatelyDestroyable: StaticlyDestroyable {
    
    static func destroyInstance()
}

internal protocol DelayedDestroyable: StaticlyDestroyable {
    
    static func destroyInstance(_ completion: TypeAlias.ArgumentlessClosure?)
}
