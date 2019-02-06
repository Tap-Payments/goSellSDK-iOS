//
//  APISession.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// API session class, for API calls.
@objcMembers public final class APISession: NSObject, Singleton {
	
	// MARK: - Public -
	
	/// Completion closure to all API calls that has 2 parameters. At least 1 is not `nil`.
	///
	/// - Parameters:
	///   - response: Response object.
	///   - error: Error object.
	public typealias Completion<Response> = (_ response: Response?, _ error: TapSDKError?) -> Void

	// MARK: Properties
	
	/// Shared instance.
	@objc(sharedInstance)
	public static let shared = APISession()
	
	// MARK: Methods
	
	/// Retrieves all saved cards for the given customer.
	///
	/// - Parameters:
	///   - customer: Customer identifier.
	///   - completion: Closure that will be called once request finishes.
	@objc(retrieveAllCardsOfCustomer:completion:)
	public func retrieveAllCards(of customer: String, completion: @escaping ([SavedCard]?, TapSDKError?) -> Void) {
		
		APIClient.shared.listAllCards(for: customer) { (response, error) in
			
			completion(response?.cards, error)
		}
	}
	
	// MARK: - Private -
	// MARK: Methods
	
	private override init() { super.init() }
}
