//
//  UIModeDisplayEnum.swift
//  goSellSDK
//
//  Created by Osama Rabie on 27/07/2022.
//

import Foundation
import UIKit

/// Decides which UI (light or dark) to follow
@objc public enum UIModeDisplayEnum: Int, CaseIterable {
    
    /// Always show the light mode
    @objc(light) case light
    
    /// Always show the dark mode
    @objc(dark) case dark
    
    /// Change the mode as per the device's settings
    @objc(followDevice) case followDevice
    
    // MARK: - Private -
    // MARK: Properties
    /// Default transaction mode.
    internal static let `default`: UIModeDisplayEnum = .followDevice
    
    private var stringRepresentation: String {
        
        switch self {
            
        case .light:        return "LIGHT"
        case .dark:         return "DARK"
        case .followDevice: return "FOLLOW_DEVICE"
        }
    }
    
    // MARK: Methods
    
    private init(stringRepresentation: String) {
        
        switch stringRepresentation {
            
        case UIModeDisplayEnum.light.stringRepresentation:
            
            self = .light
            
        case UIModeDisplayEnum.dark.stringRepresentation:
            
            self = .dark
            
        case UIModeDisplayEnum.followDevice.stringRepresentation:
            
            self = .followDevice
            
        default:
            
            self = .followDevice
        }
    }
}

// MARK: - CustomStringConvertible
extension UIModeDisplayEnum: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
            
        case .light:                return "Light"
        case .dark:                 return "Dark"
        case .followDevice:         return "Follow Device"
            
        }
    }
}

// MARK: - CustomStringConvertible
@available(iOS 13.0, *)
extension UIModeDisplayEnum {
    
    internal var userInterface: UIUserInterfaceStyle {
        
        switch self {
            
        case .light:                return .light
        case .dark:                 return .dark
        case .followDevice:         return ( UITraitCollection.current.userInterfaceStyle == .dark ) ? .dark : .light
            
        }
    }
}

// MARK: - Encodable
extension UIModeDisplayEnum: Encodable {
    
    /// Encodes the contents of the receiver.
    ///
    /// - Parameter encoder: Encoder.
    /// - Throws: EncodingError
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.stringRepresentation)
    }
}

// MARK: - Decodable
extension UIModeDisplayEnum: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        self.init(stringRepresentation: stringValue)
    }
}
