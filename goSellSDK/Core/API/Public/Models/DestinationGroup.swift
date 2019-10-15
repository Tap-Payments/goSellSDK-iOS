//
//  DestinationGroup.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Group of destinations.
@objcMembers public final class DestinationGroup: NSObject, Codable {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// List of Destinations.
	public var destinations: [Destination]?

	
	// MARK: Methods
	
	/// Initializes Destinations object with all the parameters.
	///
	/// - Parameters:
	///   - destinations: List of destinations.
	public init(destinations: [Destination]? = nil) {
		
		self.destinations			= destinations
	}
	
	
	// MARK: - Private -
	
	private enum CodingKeys: String, CodingKey {
		
		case destinations	= "destination"
	}
}


