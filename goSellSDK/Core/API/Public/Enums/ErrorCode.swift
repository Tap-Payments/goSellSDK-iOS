//
//  ErrorCode.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// All possible error codes.
@objc public enum ErrorCode: Int, Codable {
	
	// API codes
	
	/// API error indicating that required request headers are missing.
	case requestHeadersMissing                  = 1100
	
	/// Given key is not matching the environment.
	case keyAndEnvironmentMismatch              = 1101
	
	/// Request is empty.
	case emptyRequest                           = 1102
	
	/// Input is invalid.
	case invalidInput                           = 1103
	
	/// Customer ID is missing.
	case missingCustomerID                      = 1104
	
	/// Customer ID is invalid.
	case invalidCustomerID                      = 1105
	
	/// Customer with the given ID not found.
	case customerNotFound                       = 1106
	
	/// Card does not belong to the customer.
	case customerIDMismatch                     = 1107
	
	/// Card saving feature is disabled.
	case saveCardFeatureDisabled                = 1108
	
	/// Non-3D secure transactions are forbidden.
	case non3DSecureTransactionsForbidden       = 1109
	
	/// Redirect URL is missing.
	case redirectURLMissing                     = 1110
	
	/// Redirect URL is invalid.
	case redirectURLInvalid                     = 1111
	
	/// Authorize ID is missing.
	case authorizeIDMissing                     = 1112
	
	/// Authorize ID is invalid.
	case authorizeIDInvalid                     = 1113
	
	/// Please check authorize status.
	case authorizeStatus                        = 1114
	
	/// Authorize ID not found.
	case authorizeIDNotFound                    = 1115
	
	/// Save card feature is not supported.
	case saveCardFeatureNotSupported            = 1116
	
	/// Amount is invalid.
	case invalidAmount                          = 1117
	
	/// Currency is invalid.
	case invalidCurrency                        = 1118
	
	/// Currency is not supported.
	case unsupportedCurrency                    = 1119
	
	/// Statement descriptor is invalid.
	case invalidStatementDescriptor             = 1120
	
	/// Description is invalid.
	case invalidDescription                     = 1121
	
	/// Invalid merchant order reference.
	case invalidMerchantOrderReference          = 1122
	
	/// Invalid merchant transaction reference.
	case invalidMerchantTransactionReference    = 1123
	
	/// Source ID is missing.
	case missingSourceID                        = 1124
	
	/// Source ID is invalid.
	case invalidSourceID                        = 1125
	
	/// Source is already used.
	case sourceAlreadyUsed                      = 1126
	
	/// Invalid metadata key.
	case invalidMetadataKey                     = 1127
	
	/// Invalid metadata value.
	case invalidMetadataValue                   = 1128
	
	/// Missing customer ID or customer information. One of two is required.
	case missingCustomerIDOrCustomerInformation = 1129
	
	/// Missing customer's first name.
	case missingCustomerFirstName               = 1130
	
	/// Invalid customer's first name.
	case invalidCustomerFirstName               = 1131
	
	/// Missing customer's last name.
	case missingCustomerLastName                = 1132
	
	/// Invalid customer's last name.
	case invalidCustomerLastName                = 1133
	
	/// Invalid customer's middle name.
	case invalidCustomerMiddleName              = 1134
	
	/// Phone number is missing.
	case missingPhoneNumber                     = 1135
	
	/// Invalid phone number country code.
	case invalidPhoneNumberCountryCode          = 1136
	
	/// Invalid phone number.
	case invalidPhoneNumber                     = 1137
	
	/// Invalid email address.
	case invalidEmailAddress                    = 1138
	
	/// Missing customer phone number and email.
	case missingCustomerPhoneNumberAndEmail     = 1139
	
	/// Invalid card number.
	case invalidCardNumber                      = 1140
	
	/// Invalid expiration date.
	case invalidExpirationDate                  = 1141
	
	/// Missing charge ID.
	case missingChargeID                        = 1142
	
	/// Invalid charge ID.
	case invalidChargeID                        = 1143
	
	/// Charge ID not found.
	case chargeIDNotFound                       = 1144
	
	/// Missing authentication type.
	case missingAuthenticationType              = 1145
	
	/// Invalid authentication type.
	case invalidAuthenticationType              = 1146
	
	/// Missing confirmation code.
	case missingConfirmationCode                = 1147
	
	/// Invalid confirmation code.
	case invalidConfirmationCode                = 1148
	
	/// Currency code mismatch.
	case currencyCodeMismatch                   = 1149
	
	/// Capture amount exceeds.
	case captureAmountExceeds                   = 1150
	
	/// Gateway timed out.
	case gatewayTimeout                         = 1151
	
	/// Invalid authorize auto schedule type.
	case invalidAuthorizeAutoScheduleType       = 1152
	
	/// Invalid authorize auto schedule time.
	case invalidAuthorizeAutoScheduleTime       = 1153
	
	/// Missing BIN number.
	case missingBINNumber                       = 1154
	
	/// Invalid BIN number.
	case invalidBINNumber                       = 1155
	
	/// Invalid JSON request.
	case invalidJSONRequest                     = 2100
	
	/// Server unavailable.
	case serverUnavailable                      = 2101
	
	/// Request not found.
	case requestNotFound                        = 2102
	
	/// Application required.
	case applicationRequired                    = 2103
	
	/// Invalid API key.
	case invalidAPIKey                          = 2104
	
	/// Missing API credentials.
	case missingAPICredentials                  = 2105
	
	/// Public key was given instead of secret.
	case publicKeyGivenInsteadOfSecret          = 2106
	
	/// Permission denied.
	case permissionDenied                       = 3100
	
	// SDK codes
	
	/// Invalid country code.
	case invalidCountryCode                     = 8000
	
	/// Invalid amount modificator type.
	case invalidAmountModificatorType           = 8001
	
	/// Invalid unit of measurement.
	case invalidUnitOfMeasurement               = 8002
	
	/// Invalid measurement.
	case invalidMeasurement                     = 8003
	
	/// Invalid enumeration value.
	case invalidEnumValue                       = 8004
	
	/// Invalid address type
	case invalidAddressType						= 8005
	
	/// Invalid token type.
	case invalidTokenType						= 8006
	
	/// No merchant data.
	case noMerchantData							= 8007
	
	/// Serialization error.
	case serialization                          = 8100
	
	/// Network error has occured.
	case network                                = 8200
	
	/// Operation cancelled.
	case cancel                                 = 8201
	
	/// Customer already exists.
	case customerAlreadyExists					= 8301
	
	/// Card already exists.
	case cardAlreadyExists						= 8302
	
	/// Card is not supported
	case unsupportedCard						= 8400
	
	/// CVV code is invalid (length).
	case invalidCVV								= 8401
	
	/// Address on card is invalid.
	case invalidAddress							= 8402
	
	/// Invalid cardholder name.
	case invalidCardholderName					= 8403
	
	/// Unknown error.
	case unknown                                = 9999
}
