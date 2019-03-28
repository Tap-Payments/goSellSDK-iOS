//
//  Customer.Request.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

internal extension Customer {
	
	/// Request to create the customer.
	struct Request: Encodable {
		
		// MARK: - Internal -
		// MARK: Properties
		
		/// Customer first name.
		internal let firstName: String
		
		/// Customer email address.
		internal let emailAddress: EmailAddress
		
		/// Customer phone number.
		internal let phoneNumber: PhoneNumber
		
		/// Customer middle name.
		internal var middleName: String?
		
		/// Customer last name.
		internal var lastName: String?
		
		/// Customer description.
		internal var descriptionText: String?
		
		/// Customer metadata.
		internal var metadata: Metadata?
		
		/// Customer default currency.
		internal var currency: Currency?
		
		/// Customer title.
		internal var title: String?
		
		/// Customer nationality.
		internal var nationality: String?
		
		// MARK: Methods
		
		/// Creates the model with `firstName`, `lastName`, `emailAddress` and `phoneNumber`.
		///
		/// - Parameters:
		///   - firstName: First name.
		///   - lastName: Last name.
		///   - emailAddress: Email address.
		///   - phoneNumber: Phone number.
		internal init(firstName: String, emailAddress: EmailAddress, phoneNumber: PhoneNumber) {
			
			self.firstName		= firstName
			self.emailAddress	= emailAddress
			self.phoneNumber	= phoneNumber
		}
		
		/// Creates customer request from the `customer` object.
		///
		/// - Parameter customer: Customer object to create customer request from.
		/// - Throws: An error in case if some of required fields are missing in the `customer`.
		internal init(customer: Customer) throws {
			
			guard customer.identifier == nil else {
				
				let userInfo = [ErrorConstants.UserInfoKeys.customerInfo: "Failed to create the customer: already created."]
				let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.customerAlreadyExists.rawValue, userInfo: userInfo)
				throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
			}
			
			guard
				
				let nonnullFirstName = customer.firstName,
				let nonnullEmailAddress = customer.emailAddress,
				let nonnullPhoneNumber = customer.phoneNumber else {
					
					let userInfo = [ErrorConstants.UserInfoKeys.customerInfo: "Failed to create the customer: At least email address, phone number and first name shouldn't be nil."]
					let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCustomerInfo.rawValue, userInfo: userInfo)
					throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil, body: nil)
			}
			
			self.firstName			= nonnullFirstName
			self.emailAddress		= nonnullEmailAddress
			self.phoneNumber		= nonnullPhoneNumber
			self.middleName			= customer.middleName
			self.lastName			= customer.lastName
			self.descriptionText	= customer.descriptionText
			self.metadata			= customer.metadata
			self.currency			= customer.currency
			self.title				= customer.title
			self.nationality		= customer.nationality
		}
		
		// MARK: - Private -
		
		private enum CodingKeys: String, CodingKey {
			
			case firstName			= "first_name"
			case middleName			= "middle_name"
			case lastName			= "last_name"
			case emailAddress		= "email"
			case phoneNumber		= "phone"
			case descriptionText	= "description"
			case metadata			= "metadata"
			case currency			= "currency"
			case title				= "title"
			case nationality		= "nationality"
		}
	}
}
