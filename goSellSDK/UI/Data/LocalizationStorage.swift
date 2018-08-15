//
//  LocalizationStorage.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

internal class LocalizationStorage {
    
    // MARK: - Internal -
    // MARK: Methods
    
    internal static func alertTitleKey(for error: ErrorCode) -> String {
        
        return "error_\(error.rawValue)_alert_title"
    }
    
    internal static func alertMessageKey(for error: ErrorCode) -> String {
        
        return "error_\(error.rawValue)_alert_message"
    }
    
    internal static func localizedString(for key: String) -> String {
        
        guard let data = self.localizationData[goSellSDK.localeIdentifier] else { return key }
        
        if let result = data[key] {
            
            return result
        }
        else {
            
            return key
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static let localizationData: [String: [String: String]] = [
    
        "en": [
        
            LocalizationStorage.alertTitleKey(for: .invalidInput): "Invalid Input",
            LocalizationStorage.alertMessageKey(for: .invalidInput): "Required inputs are invalid.",
            
            LocalizationStorage.alertTitleKey(for: .missingCustomerID): "Missing Customer ID",
            LocalizationStorage.alertMessageKey(for: .missingCustomerID): "Customer ID is missing.",
            
            LocalizationStorage.alertTitleKey(for: .saveCardFeatureDisabled): "Save Card",
            LocalizationStorage.alertMessageKey(for: .saveCardFeatureDisabled): "Save card feature is disabled.",
            
            LocalizationStorage.alertTitleKey(for: .non3DSecureTransactionsForbidden): "3D Secure",
            LocalizationStorage.alertMessageKey(for: .non3DSecureTransactionsForbidden): "Non-3D secure transactions are forbidden.",
            
            LocalizationStorage.alertTitleKey(for: .authorizeIDMissing): "Authorize ID",
            LocalizationStorage.alertMessageKey(for: .authorizeIDMissing): "Authorize ID is missing.",
            
            LocalizationStorage.alertTitleKey(for: .authorizeIDInvalid): "Authorize ID",
            LocalizationStorage.alertMessageKey(for: .authorizeIDInvalid): "Authorize ID is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .authorizeStatus): "Authorize Status",
            LocalizationStorage.alertMessageKey(for: .authorizeStatus): "Please check authorize status.",
            
            LocalizationStorage.alertTitleKey(for: .authorizeIDNotFound): "Authorize ID",
            LocalizationStorage.alertMessageKey(for: .authorizeIDNotFound): "Authorize ID not found.",
            
            LocalizationStorage.alertTitleKey(for: .saveCardFeatureNotSupported): "Save Card",
            LocalizationStorage.alertMessageKey(for: .saveCardFeatureNotSupported): "Save card feature is not supported.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCardNumber): "Card Number",
            LocalizationStorage.alertMessageKey(for: .invalidCardNumber): "Invalid card number.",
            
            LocalizationStorage.alertTitleKey(for: .invalidExpirationDate): "Expiration Date",
            LocalizationStorage.alertMessageKey(for: .invalidExpirationDate): "Invalid expiration date.",
            
            LocalizationStorage.alertTitleKey(for: .missingChargeID): "Charge ID",
            LocalizationStorage.alertMessageKey(for: .missingChargeID): "Charge ID is missing.",
            
            LocalizationStorage.alertTitleKey(for: .invalidChargeID): "Charge ID",
            LocalizationStorage.alertMessageKey(for: .invalidChargeID): "Charge ID is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .chargeIDNotFound): "Charge ID",
            LocalizationStorage.alertMessageKey(for: .chargeIDNotFound): "Charge ID not found.",
            
            LocalizationStorage.alertTitleKey(for: .missingConfirmationCode): "Confirmation Code",
            LocalizationStorage.alertMessageKey(for: .missingConfirmationCode): "Confirmation code is missing.",
            
            LocalizationStorage.alertTitleKey(for: .invalidConfirmationCode): "Confirmation Code",
            LocalizationStorage.alertMessageKey(for: .invalidConfirmationCode): "Confirmation code is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .currencyCodeMismatch): "Currency Code",
            LocalizationStorage.alertMessageKey(for: .currencyCodeMismatch): "Currency code is not matching with existing currency code.",
            
            LocalizationStorage.alertTitleKey(for: .captureAmountExceeds): "Capture Amount",
            LocalizationStorage.alertMessageKey(for: .captureAmountExceeds): "Capture amount exceeds with outstanding authorized amount.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCountryCode): "Country Code",
            LocalizationStorage.alertMessageKey(for: .invalidCountryCode): "Country code is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .serialization): "Serialization",
            LocalizationStorage.alertMessageKey(for: .serialization): "Serialization error has occured.",
            
            LocalizationStorage.alertTitleKey(for: .sourceAlreadyUsed): "Source Used",
            LocalizationStorage.alertMessageKey(for: .sourceAlreadyUsed): "Source is already used.",
            
            LocalizationStorage.alertTitleKey(for: .gatewayTimeout): "Gateway Timeout",
            LocalizationStorage.alertMessageKey(for: .gatewayTimeout): "Gateway timed out.",
            
            LocalizationStorage.alertTitleKey(for: .network): "Network",
            LocalizationStorage.alertMessageKey(for: .network): "Network error has occured.",
            
            LocalizationStorage.alertTitleKey(for: .unknown): "Unknown Error",
            LocalizationStorage.alertMessageKey(for: .unknown): "An unknown error has occured.",
            
            LocalizationStorage.alertTitleKey(for: .missingCustomerIDOrCustomerInformation): "Customer Information",
            LocalizationStorage.alertMessageKey(for: .missingCustomerIDOrCustomerInformation): "Customer ID or customer information is required.",
            
            LocalizationStorage.alertTitleKey(for: .missingCustomerFirstName): "First Name",
            LocalizationStorage.alertMessageKey(for: .missingCustomerFirstName): "Customer first name is missing.",
            
            LocalizationStorage.alertTitleKey(for: .missingCustomerLastName): "Last Name",
            LocalizationStorage.alertMessageKey(for: .missingCustomerLastName): "Customer last name is missing.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCustomerFirstName): "First Name",
            LocalizationStorage.alertMessageKey(for: .invalidCustomerFirstName): "Customer first name is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCustomerLastName): "Last Name",
            LocalizationStorage.alertMessageKey(for: .invalidCustomerLastName): "Customer last name is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCustomerMiddleName): "Middle Name",
            LocalizationStorage.alertMessageKey(for: .invalidCustomerMiddleName): "Customer middle name is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .missingPhoneNumber): "Phone Number",
            LocalizationStorage.alertMessageKey(for: .missingPhoneNumber): "Phone number is missing.",
            
            LocalizationStorage.alertTitleKey(for: .invalidPhoneNumberCountryCode): "Phone Number",
            LocalizationStorage.alertMessageKey(for: .invalidPhoneNumberCountryCode): "Phone number country code is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidPhoneNumber): "Phone Number",
            LocalizationStorage.alertMessageKey(for: .invalidPhoneNumber): "Phone number is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidEmailAddress): "Email Address",
            LocalizationStorage.alertMessageKey(for: .invalidEmailAddress): "Email address is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .missingCustomerPhoneNumberAndEmail): "Customer Information",
            LocalizationStorage.alertMessageKey(for: .missingCustomerPhoneNumberAndEmail): "Customer information is missing. Either email or phone number should be provided.",
            
            LocalizationStorage.alertTitleKey(for: .missingAuthenticationType): "Authentication Type",
            LocalizationStorage.alertMessageKey(for: .missingAuthenticationType): "Authentication type is missing.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAuthorizeAutoScheduleType): "Auto Schedule",
            LocalizationStorage.alertMessageKey(for: .invalidAuthorizeAutoScheduleType): "Invalid authorize auto schedule type.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAuthorizeAutoScheduleTime): "Auto Schedule",
            LocalizationStorage.alertMessageKey(for: .invalidAuthorizeAutoScheduleTime): "Invalid authorize auto schedule time.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAuthenticationType): "Authentication Type",
            LocalizationStorage.alertMessageKey(for: .invalidAuthenticationType): "Authentication type is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAmountModificatorType): "Amount Modificator Type",
            LocalizationStorage.alertMessageKey(for: .invalidAmountModificatorType): "Amount modificator type is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidUnitOfMeasurement): "Measurement Unit",
            LocalizationStorage.alertMessageKey(for: .invalidUnitOfMeasurement): "Measurement unit is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidMeasurement): "Measurement",
            LocalizationStorage.alertMessageKey(for: .invalidMeasurement): "Measurement is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAmount): "Amount",
            LocalizationStorage.alertMessageKey(for: .invalidAmount): "Amount is invalid.",
            
            LocalizationStorage.alertTitleKey(for: .invalidCurrency): "Currency",
            LocalizationStorage.alertMessageKey(for: .invalidCurrency): "Invalid currency.",
            
            LocalizationStorage.alertTitleKey(for: .unsupportedCurrency): "Currency",
            LocalizationStorage.alertMessageKey(for: .unsupportedCurrency): "Unsupported currency.",
            
            LocalizationStorage.alertTitleKey(for: .serverUnavailable): "Server Unavailable",
            LocalizationStorage.alertMessageKey(for: .serverUnavailable): "Server is currently unavailable. Please try again later.",
            
            LocalizationStorage.alertTitleKey(for: .requestNotFound): "Server Unavailable",
            LocalizationStorage.alertMessageKey(for: .requestNotFound): "Server is currently unavailable. Please try again later.",
            
            LocalizationStorage.alertTitleKey(for: .invalidAPIKey): "API Key",
            LocalizationStorage.alertMessageKey(for: .invalidAPIKey): "You have provided invalid API key.",
            
            LocalizationStorage.alertTitleKey(for: .missingAPICredentials): "API Credentials",
            LocalizationStorage.alertMessageKey(for: .missingAPICredentials): "API credentials are missing.",
            
            LocalizationStorage.alertTitleKey(for: .publicKeyGivenInsteadOfSecret): "API Key",
            LocalizationStorage.alertMessageKey(for: .publicKeyGivenInsteadOfSecret): "Public API key given. Please use secret API key instead.",
            
            LocalizationStorage.alertTitleKey(for: .permissionDenied): "Permission Denied",
            LocalizationStorage.alertMessageKey(for: .permissionDenied): "Insufficient permissions.",
        ]
    ]
}
